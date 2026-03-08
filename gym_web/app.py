from flask import Flask, render_template, request, redirect, session, flash, make_response
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
from datetime import date, timedelta
import os
from io import BytesIO
from reportlab.lib.pagesizes import letter
from reportlab.lib.colors import HexColor
from reportlab.lib.units import inch
from reportlab.pdfgen import canvas

app = Flask(__name__)
app.secret_key = os.environ.get("SECRET_KEY", "clave_dev_local_cambiar_en_produccion")

PRECIO_MENSUAL = 225.00


def conectar_db():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="gymdb"
    )


# ─────────────────────────────────────────────
# REGISTRO E INICIO DE SESIÓN
# ─────────────────────────────────────────────

@app.route("/registrar", methods=["POST"])
def registrar():
    nombre   = request.form.get("nombre",   "").strip()
    apellido = request.form.get("apellido", "").strip()
    email    = request.form.get("correo",   "").strip()
    password = request.form.get("password", "").strip()

    if not nombre or not apellido or not email or not password:
        flash("Todos los campos son obligatorios", "error")
        return redirect("/registro")

    if "@" not in email:
        flash("Correo inválido", "error")
        return redirect("/registro")

    conn   = conectar_db()
    cursor = conn.cursor()

    cursor.execute("SELECT id_usuario FROM usuarios WHERE email=%s", (email,))
    if cursor.fetchone():
        conn.close()
        flash("Ese correo ya está registrado", "error")
        return redirect("/registro")

    password_hash = generate_password_hash(password)
    cursor.execute("""
        INSERT INTO usuarios (nombre, apellido, email, password, estado)
        VALUES (%s, %s, %s, %s, 'activo')
    """, (nombre, apellido, email, password_hash))
    conn.commit()

    id_generado  = cursor.lastrowid
    numero_socio = f"SOC-{id_generado:04d}"
    cursor.execute("UPDATE usuarios SET numero_socio=%s WHERE id_usuario=%s", (numero_socio, id_generado))
    conn.commit()
    conn.close()

    flash("Cuenta creada exitosamente. ¡Inicia sesión!", "success")
    return redirect("/login")


@app.route("/iniciar", methods=["POST"])
def iniciar():
    email    = request.form.get("identificador")
    password = request.form.get("password")

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM usuarios WHERE email=%s", (email,))
    usuario = cursor.fetchone()

    if usuario and usuario["estado"].lower() == "activo" and check_password_hash(usuario["password"], password):
        session["usuario_id"] = usuario["id_usuario"]
        session["nombre"]     = usuario["nombre"]
        session["rol"]        = usuario["rol"]

        cursor.execute("SELECT id_usuario FROM perfil WHERE id_usuario=%s", (usuario["id_usuario"],))
        perfil = cursor.fetchone()
        conn.close()

        if usuario["rol"] == "admin":
            return redirect("/admin")
        if usuario["rol"] == "empleado":
            return redirect("/empleado")
        if not perfil:
            return redirect("/completar_perfil")
        return redirect("/panel")

    conn.close()
    flash("Correo o contraseña incorrectos", "error")
    return redirect("/login")


# ─────────────────────────────────────────────
# PANEL ADMIN — acceso total
# ─────────────────────────────────────────────

@app.route("/admin")
def admin_panel():
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")

    buscar = request.args.get("buscar")
    filtro = request.args.get("filtro")

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT 
            u.id_usuario, u.nombre, u.apellido, u.email,
            u.estado, u.rol,
            p.edad, p.peso, p.altura, p.objetivo, p.clase, p.horario,
            (SELECT MAX(fecha_vencimiento) FROM pagos WHERE pagos.id_usuario = u.id_usuario) AS ultimo_vencimiento
        FROM usuarios u
        LEFT JOIN perfil p ON u.id_usuario = p.id_usuario
        WHERE u.rol NOT IN ('admin', 'empleado')
    """
    params = []

    if buscar:
        query += " AND (u.nombre LIKE %s OR u.apellido LIKE %s)"
        params.extend([f"%{buscar}%", f"%{buscar}%"])

    cursor.execute(query, params)
    usuarios = cursor.fetchall()

    # Empleados para gestionar
    cursor.execute("SELECT id_usuario, nombre, apellido, email, estado FROM usuarios WHERE rol='empleado'")
    empleados = cursor.fetchall()

    conn.close()

    fecha_hoy = date.today()

    if filtro == "vencidos":
        usuarios = [u for u in usuarios if u["ultimo_vencimiento"] and u["ultimo_vencimiento"] < fecha_hoy]
    if filtro == "activos":
        usuarios = [u for u in usuarios if u["ultimo_vencimiento"] and u["ultimo_vencimiento"] >= fecha_hoy]

    return render_template("admin.html", usuarios=usuarios, empleados=empleados, fecha_hoy=fecha_hoy, precio_mensual=PRECIO_MENSUAL)


@app.route("/admin/hacer_admin/<int:id_usuario>", methods=["POST"])
def hacer_admin(id_usuario):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("UPDATE usuarios SET rol='admin' WHERE id_usuario=%s", (id_usuario,))
    conn.commit(); conn.close()
    flash("Usuario promovido a administrador", "success")
    return redirect("/admin")


@app.route("/admin/quitar_admin/<int:id_usuario>", methods=["POST"])
def quitar_admin(id_usuario):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    if id_usuario == session["usuario_id"]:
        flash("No puedes quitarte tu propio rol admin", "error")
        return redirect("/admin")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("UPDATE usuarios SET rol='user' WHERE id_usuario=%s", (id_usuario,))
    conn.commit(); conn.close()
    flash("Rol admin removido", "success")
    return redirect("/admin")


@app.route("/admin/hacer_empleado/<int:id_usuario>", methods=["POST"])
def hacer_empleado(id_usuario):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("UPDATE usuarios SET rol='empleado' WHERE id_usuario=%s", (id_usuario,))
    conn.commit(); conn.close()
    flash("Usuario asignado como empleado", "success")
    return redirect("/admin")


@app.route("/admin/quitar_empleado/<int:id_usuario>", methods=["POST"])
def quitar_empleado(id_usuario):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("UPDATE usuarios SET rol='user' WHERE id_usuario=%s", (id_usuario,))
    conn.commit(); conn.close()
    flash("Rol empleado removido", "success")
    return redirect("/admin")


@app.route("/admin/pagos/<int:id_usuario>")
def ver_pagos(id_usuario):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT u.nombre, u.apellido,
               p.id_pago, p.monto, p.fecha_pago, p.fecha_vencimiento
        FROM pagos p
        JOIN usuarios u ON u.id_usuario = p.id_usuario
        WHERE u.id_usuario = %s ORDER BY p.fecha_pago DESC
    """, (id_usuario,))
    pagos = cursor.fetchall()

    cursor.execute("SELECT COALESCE(SUM(monto), 0) AS total_ingresos FROM pagos WHERE id_usuario = %s", (id_usuario,))
    resumen = cursor.fetchone()
    conn.close()

    nombre_socio = f"{pagos[0]['nombre']} {pagos[0]['apellido']}" if pagos else "Sin pagos"
    total_meses  = int(float(resumen["total_ingresos"]) / PRECIO_MENSUAL)

    return render_template("pagos_admin.html", pagos=pagos, total=total_meses,
                           total_ingresos=resumen["total_ingresos"],
                           nombre_socio=nombre_socio, id_usuario=id_usuario)


@app.route("/admin/desactivar/<int:id_usuario>", methods=["POST"])
def desactivar_usuario(id_usuario):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("UPDATE usuarios SET estado='inactivo' WHERE id_usuario=%s", (id_usuario,))
    conn.commit(); conn.close()
    flash("Usuario desactivado", "success")
    return redirect("/admin")


@app.route("/admin/reactivar/<int:id_usuario>", methods=["POST"])
def reactivar_usuario(id_usuario):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("UPDATE usuarios SET estado='activo' WHERE id_usuario=%s", (id_usuario,))
    conn.commit(); conn.close()
    flash("Usuario reactivado", "success")
    return redirect("/admin")


@app.route("/admin/registrar_pago/<int:id_usuario>", methods=["POST"])
def registrar_pago(id_usuario):
    if "usuario_id" not in session or session.get("rol") not in ("admin", "empleado"):
        return redirect("/login")

    meses  = int(request.form["meses"])
    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT MAX(fecha_vencimiento) AS ultimo FROM pagos WHERE id_usuario=%s", (id_usuario,))
    resultado = cursor.fetchone()

    hoy        = date.today()
    fecha_base = resultado["ultimo"] if resultado["ultimo"] and resultado["ultimo"] >= hoy else hoy
    nueva_fecha = fecha_base + timedelta(days=30 * meses)
    monto_total = PRECIO_MENSUAL * meses

    cursor = conn.cursor()
    cursor.execute("INSERT INTO pagos (id_usuario, fecha_pago, fecha_vencimiento, monto) VALUES (%s,%s,%s,%s)",
                   (id_usuario, hoy, nueva_fecha, monto_total))
    conn.commit(); conn.close()

    flash(f"Pago de {meses} mes(es) registrado — Q{monto_total:.2f}", "success")

    # Redirige según quién registró el pago
    if session.get("rol") == "empleado":
        return redirect("/empleado")
    return redirect("/admin")


# ─────────────────────────────────────────────
# PANEL EMPLEADO — solo registrar pagos
# ─────────────────────────────────────────────

@app.route("/empleado")
def empleado_panel():
    if "usuario_id" not in session or session.get("rol") not in ("admin", "empleado"):
        return redirect("/login")

    buscar = request.args.get("buscar", "")
    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT u.id_usuario, u.nombre, u.apellido, u.numero_socio, u.estado,
               (SELECT MAX(fecha_vencimiento) FROM pagos WHERE id_usuario = u.id_usuario) AS ultimo_vencimiento
        FROM usuarios u
        WHERE u.rol = 'user'
    """
    params = []
    if buscar:
        query += " AND (u.nombre LIKE %s OR u.apellido LIKE %s OR u.numero_socio LIKE %s)"
        params.extend([f"%{buscar}%", f"%{buscar}%", f"%{buscar}%"])

    query += " ORDER BY u.nombre"
    cursor.execute(query, params)
    usuarios = cursor.fetchall()
    conn.close()

    return render_template("empleado.html", usuarios=usuarios, fecha_hoy=date.today(),
                           precio_mensual=PRECIO_MENSUAL, buscar=buscar)


# ─────────────────────────────────────────────
# PANEL USUARIO
# ─────────────────────────────────────────────

@app.route("/panel")
def panel():
    if "usuario_id" not in session:
        return redirect("/login")
    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT u.nombre, u.apellido, u.email,
               p.edad, p.peso, p.altura, p.clase, p.horario, p.objetivo
        FROM usuarios u
        JOIN perfil p ON u.id_usuario = p.id_usuario
        WHERE u.id_usuario=%s
    """, (session["usuario_id"],))
    perfil = cursor.fetchone()
    conn.close()
    return render_template("panel.html", perfil=perfil)


@app.route("/completar_perfil")
def completar_perfil():
    if "usuario_id" not in session:
        return redirect("/login")
    return render_template("perfil.html")


@app.route("/guardar_perfil", methods=["POST"])
def guardar_perfil():
    if "usuario_id" not in session:
        return redirect("/login")
    edad = request.form["edad"]; peso = request.form["peso"]
    altura = request.form["altura"]; objetivo = request.form["objetivo"]
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("INSERT INTO perfil (id_usuario, edad, peso, altura, objetivo) VALUES (%s,%s,%s,%s,%s)",
                   (session["usuario_id"], edad, peso, altura, objetivo))
    conn.commit(); conn.close()
    return redirect("/panel")


@app.route("/actualizar_info", methods=["POST"])
def actualizar_info():
    if "usuario_id" not in session:
        return redirect("/login")
    nombre = request.form.get("nombre"); apellido = request.form.get("apellido")
    email  = request.form.get("email");  peso     = request.form.get("peso")
    conn = conectar_db(); cursor = conn.cursor()
    if nombre and apellido and email:
        cursor.execute("UPDATE usuarios SET nombre=%s, apellido=%s, email=%s WHERE id_usuario=%s",
                       (nombre, apellido, email, session["usuario_id"]))
    if peso:
        cursor.execute("UPDATE perfil SET peso=%s WHERE id_usuario=%s", (peso, session["usuario_id"]))
    conn.commit(); conn.close()
    if nombre: session["nombre"] = nombre
    flash("Información actualizada", "success")
    return redirect("/panel")


@app.route("/actualizar_entrenamiento", methods=["POST"])
def actualizar_entrenamiento():
    if "usuario_id" not in session:
        return redirect("/login")
    clase = request.form["clase"]; horario = request.form["horario"]
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("UPDATE perfil SET clase=%s, horario=%s WHERE id_usuario=%s",
                   (clase, horario, session["usuario_id"]))
    conn.commit(); conn.close()
    flash("Entrenamiento actualizado", "success")
    return redirect("/panel")


# ─────────────────────────────────────────────
# RECIBO PDF
# ─────────────────────────────────────────────

@app.route("/recibo/<int:id_pago>")
def generar_recibo(id_pago):
    if "usuario_id" not in session:
        return redirect("/login")

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT p.id_pago, p.monto, p.fecha_pago, p.fecha_vencimiento,
               u.nombre, u.apellido, u.email, u.numero_socio
        FROM pagos p
        JOIN usuarios u ON u.id_usuario = p.id_usuario
        WHERE p.id_pago = %s
    """, (id_pago,))
    pago = cursor.fetchone()
    conn.close()

    if not pago:
        flash("Pago no encontrado", "error")
        return redirect("/admin")

    # Solo admin/empleado o el propio usuario puede ver el recibo
    if session.get("rol") not in ("admin", "empleado"):
        return redirect("/panel")

    buf = BytesIO()
    c = canvas.Canvas(buf, pagesize=letter)
    width, height = letter

    # ── Colores (tema naranja comercial) ──
    negro     = HexColor("#0d0d0d")
    naranja   = HexColor("#FF6B00")
    gris_dark = HexColor("#333333")
    gris      = HexColor("#666666")
    blanco    = HexColor("#ffffff")
    verde     = HexColor("#22c55e")

    # ── Fondo del header ──
    c.setFillColor(negro)
    c.rect(0, height - 140, width, 140, fill=True, stroke=False)

    # ── Logo / Nombre Gym ──
    logo_path = os.path.join(app.static_folder, 'logo.png')
    if os.path.exists(logo_path):
        c.drawImage(logo_path, 50, height - 95, width=55, height=55, preserveAspectRatio=True, mask='auto')
    c.setFillColor(blanco)
    c.setFont("Helvetica-Bold", 28)
    c.drawString(115, height - 60, "BODYFLEX")
    c.setFillColor(naranja)
    c.drawString(115 + c.stringWidth("BODYFLEX", "Helvetica-Bold", 28), height - 60, "GYM")

    # ── Subtítulo ──
    c.setFillColor(HexColor("#aaaaaa"))
    c.setFont("Helvetica", 10)
    # Alinear debajo del título "BODYFLEX GYM"
    c.drawString(115, height - 80, "Recibo de pago de membresía")

    # ── Número de recibo ──
    c.setFillColor(naranja)
    c.setFont("Helvetica-Bold", 12)
    c.drawRightString(width - 50, height - 55, f"RECIBO #{pago['id_pago']:04d}")

    c.setFillColor(HexColor("#aaaaaa"))
    c.setFont("Helvetica", 10)
    fecha_str = pago['fecha_pago'].strftime('%d/%m/%Y') if pago['fecha_pago'] else 'N/A'
    c.drawRightString(width - 50, height - 75, f"Fecha: {fecha_str}")

    # ── Línea naranja decorativa ──
    c.setStrokeColor(naranja)
    c.setLineWidth(3)
    c.line(50, height - 150, width - 50, height - 150)

    # ── Datos del socio ──
    y = height - 195
    c.setFillColor(gris)
    c.setFont("Helvetica", 9)
    c.drawString(50, y + 15, "DATOS DEL SOCIO")

    c.setFillColor(negro)
    c.setFont("Helvetica-Bold", 13)
    c.drawString(50, y - 5, f"{pago['nombre']} {pago['apellido']}")

    c.setFillColor(gris_dark)
    c.setFont("Helvetica", 10)
    c.drawString(50, y - 22, f"Correo: {pago['email']}")
    num_socio = pago['numero_socio'] or 'N/A'
    c.drawString(50, y - 38, f"No. Socio: {num_socio}")

    # ── Tabla de detalle de pago ──
    y = height - 290

    # Header de tabla
    c.setFillColor(HexColor("#f5f5f5"))
    c.rect(50, y - 5, width - 100, 28, fill=True, stroke=False)

    c.setFillColor(gris)
    c.setFont("Helvetica-Bold", 9)
    c.drawString(60, y + 3, "PAGO")
    c.drawString(280, y + 3, "FECHA PAGO")
    c.drawString(390, y + 3, "VENCIMIENTO")
    c.drawRightString(width - 60, y + 3, "MONTO")

    # Fila de datos
    y -= 32
    c.setFillColor(negro)
    c.setFont("Helvetica", 11)
    meses = int(float(pago['monto']) / PRECIO_MENSUAL)
    concepto = f"Membresía ({meses} {'mes' if meses == 1 else 'meses'})"
    c.drawString(60, y + 3, concepto)

    c.setFont("Helvetica", 10)
    c.drawString(280, y + 3, fecha_str)
    venc_str = pago['fecha_vencimiento'].strftime('%d/%m/%Y') if pago['fecha_vencimiento'] else 'N/A'
    c.drawString(390, y + 3, venc_str)

    c.setFont("Helvetica-Bold", 12)
    c.setFillColor(verde)
    c.drawRightString(width - 60, y + 3, f"Q{pago['monto']:.2f}")

    # Línea separadora
    y -= 15
    c.setStrokeColor(HexColor("#e0e0e0"))
    c.setLineWidth(0.5)
    c.line(50, y, width - 50, y)

    # Total
    y -= 30
    c.setFillColor(negro)
    c.setFont("Helvetica-Bold", 10)
    c.drawString(60, y+3, "TOTAL")
    c.setFont("Helvetica-Bold", 16)
    c.setFillColor(negro)
    c.drawRightString(width - 60, y+3, f"Q{pago['monto']:.2f}")

    # ── Sello de PAGADO ──
    y -= 70
    c.setStrokeColor(verde)
    c.setFillColor(verde)
    c.setLineWidth(2)
    c.roundRect(width/2 - 60, y - 5, 120, 35, 6, fill=False, stroke=True)
    c.setFont("Helvetica-Bold", 18)
    c.drawCentredString(width/2, y + 5, "PAGADO")

    # ── Pie de página ──
    c.setFillColor(HexColor("#f8f8f8"))
    c.rect(0, 0, width, 60, fill=True, stroke=False)

    c.setStrokeColor(HexColor("#e0e0e0"))
    c.setLineWidth(0.5)
    c.line(0, 60, width, 60)

    c.setFillColor(gris)
    c.setFont("Helvetica", 8)
    c.drawCentredString(width/2, 35, "Bodyflex Gym — Sistema de Gestión de Membresías")
    c.drawCentredString(width/2, 22, f"Recibo generado automáticamente · {date.today().strftime('%d/%m/%Y')}")

    c.showPage()
    c.save()
    buf.seek(0)

    response = make_response(buf.read())
    response.headers['Content-Type'] = 'application/pdf'
    response.headers['Content-Disposition'] = f'inline; filename=recibo_{pago["id_pago"]:04d}.pdf'
    return response


# ─────────────────────────────────────────────
# RUTAS SIMPLES
# ─────────────────────────────────────────────

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/registro")
def registro():
    return render_template("registro.html")

@app.route("/logout")
def logout():
    session.clear()
    return redirect("/login")

@app.route("/")
def inicio():
    return render_template("inicio.html")


if __name__ == "__main__":
    app.run(debug=True)
