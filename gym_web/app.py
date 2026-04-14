from flask import Flask, render_template, request, redirect, session, flash, make_response
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector
from datetime import date, timedelta, datetime
import os
import secrets
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from io import BytesIO
import re
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import letter
from reportlab.lib.colors import HexColor

app = Flask(__name__)
# Usa la variable de entorno para la seguridad
app.secret_key = os.environ.get("SECRET_KEY", "clave_segura_de_kevin_123")

@app.after_request
def sin_cache(response):
    """Evita que el navegador cachee páginas — el botón Atrás pide login."""
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "0"
    return response

# --- CONFIGURACIÓN DE BASE DE DATOS (ÚNICA Y LIMPIA) ---
def conectar_db():
    return mysql.connector.connect(
        host=os.environ.get('MYSQLHOST'),
        user=os.environ.get('MYSQLUSER'),
        password=os.environ.get('MYSQLPASSWORD'),
        database=os.environ.get('MYSQLDATABASE'),
        port=int(os.environ.get('MYSQLPORT', 3306))
    )

PRECIO_MENSUAL = 225.00

# --- CONFIGURACIÓN DE CORREO ---
GMAIL_USER     = os.environ.get("GMAIL_USER", "kevinmperez29@gmail.com")
GMAIL_PASSWORD = os.environ.get("GMAIL_PASSWORD", "xlqpntzngoeexkaaw")

# ─────────────────────────────────────────────
# HELPERS
# ─────────────────────────────────────────────

def registrar_log(tipo, detalle, afectado_id=None, afectado_nombre=None):
    """Registra una acción en la tabla de auditoría.
    Usa session['usuario_id'] que almacena el CUI del usuario activo."""
    actor_cui    = session.get("usuario_id")   # CUI del actor (admin/empleado/cliente)
    actor_nombre = session.get("nombre", "Sistema")
    actor_rol    = session.get("rol", "—")
    try:
        conn   = conectar_db()
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO auditoria (tipo, actor_id, actor_nombre, actor_rol,
                                   afectado_id, afectado_nombre, detalle)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (tipo, actor_cui, actor_nombre, actor_rol,
               afectado_id, afectado_nombre, detalle))
        conn.commit()
        conn.close()
    except Exception as e:
        print(f"[LOG ERROR] {e}")


# ─────────────────────────────────────────────
# HELPER — Enviar correo de recuperación
# ─────────────────────────────────────────────

def enviar_correo_reset(destino, token, nombre):
    base_url = os.environ.get("BASE_URL", "http://localhost:5000")
    link     = f"{base_url}/reset_password/{token}"
    asunto = "Recuperación de contraseña — Bodyflex Gym"

    html = f"""
    <!DOCTYPE html>
    <html><head><meta charset="UTF-8"></head>
    <body style="margin:0;padding:0;background:#0f0f0f;font-family:'Helvetica Neue',Arial,sans-serif;">
      <table width="100%" cellpadding="0" cellspacing="0" style="background:#0f0f0f;padding:40px 20px;">
        <tr><td align="center">
          <table width="500" cellpadding="0" cellspacing="0"
                 style="background:#1a1a1a;border-radius:16px;border:1px solid #2e2e2e;overflow:hidden;">
            <tr>
              <td style="background:#141414;padding:28px 36px;border-bottom:1px solid #2e2e2e;">
                <span style="font-weight:900;font-size:22px;color:#f5f5f5;letter-spacing:-0.5px;">
                  BODYFLEX<span style="color:#FF6B00;">GYM</span>
                </span>
              </td>
            </tr>
            <tr>
              <td style="padding:36px;">
                <div style="font-size:36px;margin-bottom:16px;">🔑</div>
                <h1 style="color:#f5f5f5;font-size:22px;font-weight:700;margin:0 0 12px;">
                  Recupera tu contraseña
                </h1>
                <p style="color:#9ca3af;font-size:14px;line-height:1.6;margin:0 0 28px;">
                  Hola <strong style="color:#f5f5f5;">{nombre}</strong>, recibimos una solicitud para
                  restablecer la contraseña de tu cuenta en Bodyflex Gym.
                </p>
                <table cellpadding="0" cellspacing="0" style="margin-bottom:28px;">
                  <tr>
                    <td style="background:#FF6B00;border-radius:10px;">
                      <a href="{link}"
                         style="display:inline-block;padding:14px 32px;color:#fff;text-decoration:none;
                                font-weight:700;font-size:15px;">
                        Restablecer contraseña →
                      </a>
                    </td>
                  </tr>
                </table>
                <div style="background:#222;border:1px solid #2e2e2e;border-radius:10px;padding:16px;margin-bottom:24px;">
                  <p style="color:#9ca3af;font-size:13px;margin:0;">
                    ⏰ Este enlace expira en <strong style="color:#FF6B00;">1 hora</strong>.
                    Si no solicitaste este cambio, ignora este correo.
                  </p>
                </div>
                <p style="color:#555;font-size:11px;margin:0;word-break:break-all;">
                  Si el botón no funciona copia este enlace:<br>
                  <span style="color:#FF6B00;">{link}</span>
                </p>
              </td>
            </tr>
            <tr>
              <td style="background:#141414;padding:20px 36px;border-top:1px solid #2e2e2e;">
                <p style="color:#555;font-size:11px;margin:0;text-align:center;">
                  Bodyflex Gym — Este correo fue generado automáticamente.
                </p>
              </td>
            </tr>
          </table>
        </td></tr>
      </table>
    </body></html>
    """

    texto = f"Hola {nombre},\n\nRestablecer contraseña:\n{link}\n\nExpira en 1 hora.\n\n— Bodyflex Gym"

    msg = MIMEMultipart("alternative")
    msg["Subject"] = asunto
    msg["From"]    = f"Bodyflex Gym <{GMAIL_USER}>"
    msg["To"]      = destino
    msg.attach(MIMEText(texto, "plain"))
    msg.attach(MIMEText(html, "html"))

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(GMAIL_USER, GMAIL_PASSWORD)
        server.sendmail(GMAIL_USER, destino, msg.as_string())


# ─────────────────────────────────────────────
# REGISTRO E INICIO DE SESIÓN
# ─────────────────────────────────────────────

@app.route("/registrar", methods=["POST"])
def registrar():
    nombre        = request.form.get("nombre",         "").strip()
    apellido      = request.form.get("apellido",       "").strip()
    email         = request.form.get("correo",         "").strip()
    password      = request.form.get("password",       "").strip()
    numero_doc    = request.form.get("numero_doc",     "").strip()
    tipo_doc      = request.form.get("tipo_doc",       "CUI").strip()

    if not nombre or not apellido or not email or not password or not numero_doc:
        flash("Todos los campos son obligatorios", "error")
        return redirect("/registro")

    if "@" not in email:
        flash("Correo inválido", "error")
        return redirect("/registro")

    # Validar número de documento (CUI o DPI = 13 dígitos)
    if not numero_doc.isdigit() or len(numero_doc) != 13:
        flash("El CUI/DPI debe tener exactamente 13 dígitos", "error")
        return redirect("/registro")

    if tipo_doc not in ("CUI", "DPI"):
        tipo_doc = "CUI"

    import re
    if len(password) < 8:
        flash("La contraseña debe tener al menos 8 caracteres", "error")
        return redirect("/registro")
    if not re.search(r"[A-Z]", password):
        flash("La contraseña debe tener al menos una mayúscula", "error")
        return redirect("/registro")
    if not re.search(r"[a-z]", password):
        flash("La contraseña debe tener al menos una minúscula", "error")
        return redirect("/registro")
    if not re.search(r"[0-9]", password):
        flash("La contraseña debe tener al menos un número", "error")
        return redirect("/registro")
    if not re.search(r"[^A-Za-z0-9]", password):
        flash("La contraseña debe tener al menos un carácter especial (ej: @, #, $, !)", "error")
        return redirect("/registro")

    conn   = conectar_db()
    cursor = conn.cursor()

    cursor.execute("SELECT cui FROM usuarios WHERE email=%s", (email,))
    if cursor.fetchone():
        conn.close()
        flash("Ese correo ya está registrado", "error")
        return redirect("/registro")

    cursor.execute("SELECT cui FROM usuarios WHERE cui=%s", (int(numero_doc),))
    if cursor.fetchone():
        conn.close()
        flash("Ese CUI/DPI ya está registrado", "error")
        return redirect("/registro")

    password_hash = generate_password_hash(password)
    cursor.execute("""
        INSERT INTO usuarios (cui, tipo_doc, nombre, apellido, email, password, estado)
        VALUES (%s, %s, %s, %s, %s, %s, 'activo')
    """, (int(numero_doc), tipo_doc, nombre, apellido, email, password_hash))
    conn.commit()
    conn.close()

    flash("Cuenta creada exitosamente. ¡Inicia sesión!", "success")
    return redirect("/login")


@app.route("/iniciar", methods=["POST"])
def iniciar():
    """Valida credenciales usando el correo electrónico.
    Guarda el CUI en sesión como session['usuario_id']."""
    email    = request.form.get("identificador", "").strip()
    password = request.form.get("password", "")

    if not email or not password:
        flash("Completa todos los campos", "error")
        return redirect("/login")

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT cui, nombre, apellido, email, password, estado, rol, edad
        FROM usuarios WHERE email = %s
    """, (email,))
    usuario = cursor.fetchone()

    if not usuario:
        conn.close()
        flash("Correo o contraseña incorrectos", "error")
        return redirect("/login")

    if usuario["estado"].lower() != "activo":
        conn.close()
        flash("Tu cuenta está inactiva. Contacta al gimnasio.", "error")
        return redirect("/login")

    if not check_password_hash(usuario["password"], password):
        conn.close()
        flash("Correo o contraseña incorrectos", "error")
        return redirect("/login")

    # ✅ Credenciales correctas — guardar CUI como identificador de sesión
    conn.close()
    session["usuario_id"] = usuario["cui"]   # CUI = llave primaria única
    session["nombre"]     = usuario["nombre"]
    session["rol"]        = usuario["rol"]

    registrar_log("login", "Inició sesión")

    if usuario["rol"] == "admin":
        return redirect("/admin")
    if usuario["rol"] == "empleado":
        return redirect("/empleado")
    # Si el cliente no ha completado su perfil (edad es NULL), redirigir
    if not usuario["edad"]:
        return redirect("/completar_perfil")
    return redirect("/panel")


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
            u.cui, u.tipo_doc, u.nombre, u.apellido, u.email,
            u.estado, u.rol,
            u.edad, u.peso, u.altura, u.objetivo, u.clase, u.horario,
            (SELECT MAX(fecha_vencimiento) FROM pagos WHERE pagos.cui_usuario = u.cui) AS ultimo_vencimiento
        FROM usuarios u
        WHERE u.rol NOT IN ('admin', 'empleado')
    """
    params = []

    if buscar:
        query += " AND (u.nombre LIKE %s OR u.apellido LIKE %s)"
        params.extend([f"%{buscar}%", f"%{buscar}%"])

    cursor.execute(query, params)
    usuarios = cursor.fetchall()

    cursor.execute("SELECT cui, tipo_doc, nombre, apellido, email, estado FROM usuarios WHERE rol='empleado'")
    empleados = cursor.fetchall()

    conn.close()

    fecha_hoy = date.today()

    if filtro == "vencidos":
        usuarios = [u for u in usuarios if u["ultimo_vencimiento"] and u["ultimo_vencimiento"] < fecha_hoy]
    if filtro == "activos":
        usuarios = [u for u in usuarios if u["ultimo_vencimiento"] and u["ultimo_vencimiento"] >= fecha_hoy]

    return render_template("admin.html", usuarios=usuarios, empleados=empleados,
                           fecha_hoy=fecha_hoy, precio_mensual=PRECIO_MENSUAL)


@app.route("/admin/hacer_admin/<int:cui>", methods=["POST"])
def hacer_admin(cui):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("SELECT nombre, apellido FROM usuarios WHERE cui=%s", (cui,))
    u = cursor.fetchone()
    cursor.execute("UPDATE usuarios SET rol='admin' WHERE cui=%s", (cui,))
    conn.commit(); conn.close()
    registrar_log("rol", "Promovió a Admin", afectado_id=cui,
                  afectado_nombre=f"{u[0]} {u[1]}" if u else None)
    flash("Usuario promovido a administrador", "success")
    return redirect("/admin")


@app.route("/admin/quitar_admin/<int:cui>", methods=["POST"])
def quitar_admin(cui):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    if cui == session["usuario_id"]:
        flash("No puedes quitarte tu propio rol admin", "error")
        return redirect("/admin")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("SELECT nombre, apellido FROM usuarios WHERE cui=%s", (cui,))
    u = cursor.fetchone()
    cursor.execute("UPDATE usuarios SET rol='user' WHERE cui=%s", (cui,))
    conn.commit(); conn.close()
    registrar_log("rol", "Quitó rol Admin → Usuario", afectado_id=cui,
                  afectado_nombre=f"{u[0]} {u[1]}" if u else None)
    flash("Rol admin removido", "success")
    return redirect("/admin")


@app.route("/admin/hacer_empleado/<int:cui>", methods=["POST"])
def hacer_empleado(cui):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("SELECT nombre, apellido FROM usuarios WHERE cui=%s", (cui,))
    u = cursor.fetchone()
    cursor.execute("UPDATE usuarios SET rol='empleado' WHERE cui=%s", (cui,))
    conn.commit(); conn.close()
    registrar_log("rol", "Asignó como Empleado", afectado_id=cui,
                  afectado_nombre=f"{u[0]} {u[1]}" if u else None)
    flash("Usuario asignado como empleado", "success")
    return redirect("/admin")


@app.route("/admin/quitar_empleado/<int:cui>", methods=["POST"])
def quitar_empleado(cui):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("SELECT nombre, apellido FROM usuarios WHERE cui=%s", (cui,))
    u = cursor.fetchone()
    cursor.execute("UPDATE usuarios SET rol='user' WHERE cui=%s", (cui,))
    conn.commit(); conn.close()
    registrar_log("rol", "Quitó rol Empleado → Usuario", afectado_id=cui,
                  afectado_nombre=f"{u[0]} {u[1]}" if u else None)
    flash("Rol empleado removido", "success")
    return redirect("/admin")


@app.route("/admin/pagos/<int:cui>")
def ver_pagos(cui):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT u.nombre, u.apellido,
               p.id_pago, p.monto, p.fecha_pago, p.fecha_vencimiento
        FROM pagos p
        JOIN usuarios u ON u.cui = p.cui_usuario
        WHERE u.cui = %s ORDER BY p.fecha_pago DESC
    """, (cui,))
    pagos = cursor.fetchall()

    cursor.execute("SELECT COALESCE(SUM(monto), 0) AS total_ingresos FROM pagos WHERE cui_usuario = %s", (cui,))
    resumen = cursor.fetchone()
    conn.close()

    nombre_socio = f"{pagos[0]['nombre']} {pagos[0]['apellido']}" if pagos else "Sin pagos"
    total_meses  = int(float(resumen["total_ingresos"]) / PRECIO_MENSUAL)

    return render_template("pagos_admin.html", pagos=pagos, total=total_meses,
                           total_ingresos=resumen["total_ingresos"],
                           nombre_socio=nombre_socio, cui=cui)


@app.route("/admin/desactivar/<int:cui>", methods=["POST"])
def desactivar_usuario(cui):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("SELECT nombre, apellido FROM usuarios WHERE cui=%s", (cui,))
    u = cursor.fetchone()
    cursor.execute("UPDATE usuarios SET estado='inactivo' WHERE cui=%s", (cui,))
    conn.commit(); conn.close()
    registrar_log("desactivar", "Desactivó la cuenta", afectado_id=cui,
                  afectado_nombre=f"{u[0]} {u[1]}" if u else None)
    flash("Usuario desactivado", "success")
    return redirect("/admin")


@app.route("/admin/reactivar/<int:cui>", methods=["POST"])
def reactivar_usuario(cui):
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("SELECT nombre, apellido FROM usuarios WHERE cui=%s", (cui,))
    u = cursor.fetchone()
    cursor.execute("UPDATE usuarios SET estado='activo' WHERE cui=%s", (cui,))
    conn.commit(); conn.close()
    registrar_log("activacion", "Reactivó la cuenta", afectado_id=cui,
                  afectado_nombre=f"{u[0]} {u[1]}" if u else None)
    flash("Usuario reactivado", "success")
    return redirect("/admin")


@app.route("/admin/registrar_pago/<int:cui>", methods=["POST"])
def registrar_pago(cui):
    if "usuario_id" not in session or session.get("rol") not in ("admin", "empleado"):
        return redirect("/login")

    meses_lista = request.form.get("meses_lista", "")
    anio_sel    = request.form.get("anio_sel", str(date.today().year))
    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT MAX(fecha_vencimiento) AS ultimo FROM pagos WHERE cui_usuario=%s", (cui,))
    resultado = cursor.fetchone()

    cursor.execute("SELECT nombre, apellido FROM usuarios WHERE cui=%s", (cui,))
    socio = cursor.fetchone()

    hoy        = date.today()
    fecha_base = resultado["ultimo"] if resultado["ultimo"] and resultado["ultimo"] >= hoy else hoy
    meses_nombres = ["Enero","Febrero","Marzo","Abril","Mayo","Junio",
                     "Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]

    # Parsear meses seleccionados
    if meses_lista:
        meses_nums = sorted([int(m) for m in meses_lista.split(",") if m.strip().isdigit()])
        meses      = len(meses_nums)
        anio_i     = int(anio_sel)
        nombres_sel = [meses_nombres[m-1] for m in meses_nums]
        if meses == 1:
            mes_pagado = f"{nombres_sel[0]} {anio_i}"
        else:
            mes_pagado = f"{', '.join(nombres_sel[:-1])} y {nombres_sel[-1]} {anio_i}"
    else:
        meses  = int(request.form.get("meses", 1))
        mes_i  = fecha_base.month if fecha_base > hoy else hoy.month
        anio_i = int(anio_sel)
        if meses == 1:
            mes_pagado = f"{meses_nombres[mes_i-1]} {anio_i}"
        else:
            mes_fin  = ((mes_i - 1 + meses - 1) % 12) + 1
            anio_fin = anio_i + ((mes_i - 1 + meses - 1) // 12)
            mes_pagado = f"{meses_nombres[mes_i-1]} {anio_i} — {meses_nombres[mes_fin-1]} {anio_fin}"

    nueva_fecha = fecha_base + timedelta(days=30 * meses)
    monto_total = PRECIO_MENSUAL * meses

    cursor = conn.cursor()
    cursor.execute("INSERT INTO pagos (cui_usuario, fecha_pago, fecha_vencimiento, monto, mes_pagado) VALUES (%s,%s,%s,%s,%s)",
                   (cui, hoy, nueva_fecha, monto_total, mes_pagado))
    conn.commit(); conn.close()

    nombre_socio = f"{socio['nombre']} {socio['apellido']}" if socio else "—"
    registrar_log("pago", f"Registró pago de {meses} mes(es) — Q{monto_total:.2f}",
                  afectado_id=cui, afectado_nombre=nombre_socio)

    flash(f"Pago de {meses} mes(es) registrado — Q{monto_total:.2f}", "success")

    if session.get("rol") == "empleado":
        return redirect("/empleado")
    return redirect("/admin")


# ─────────────────────────────────────────────
# AUDITORÍA
# ─────────────────────────────────────────────

@app.route("/admin/auditoria")
def auditoria():
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")

    buscar      = request.args.get("buscar", "").strip()
    tipo_filtro = request.args.get("tipo", "").strip()
    pagina      = int(request.args.get("pagina", 1))
    por_pagina  = 30
    offset      = (pagina - 1) * por_pagina

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)

    condiciones = []
    params      = []

    if buscar:
        condiciones.append("(actor_nombre LIKE %s OR afectado_nombre LIKE %s OR detalle LIKE %s)")
        params.extend([f"%{buscar}%", f"%{buscar}%", f"%{buscar}%"])

    if tipo_filtro:
        condiciones.append("tipo = %s")
        params.append(tipo_filtro)

    where = ("WHERE " + " AND ".join(condiciones)) if condiciones else ""

    cursor.execute(f"SELECT COUNT(*) AS total FROM auditoria {where}", params)
    total_acciones = cursor.fetchone()["total"]
    total_paginas  = max(1, -(-total_acciones // por_pagina))

    cursor.execute(
        f"SELECT * FROM auditoria {where} ORDER BY fecha DESC LIMIT %s OFFSET %s",
        params + [por_pagina, offset]
    )
    auditoria_registros = cursor.fetchall()

    hoy_str = date.today().strftime("%Y-%m-%d")
    cursor.execute("SELECT COUNT(*) AS c FROM auditoria WHERE tipo='pago' AND DATE(fecha)=%s", (hoy_str,))
    pagos_hoy = cursor.fetchone()["c"]

    cursor.execute("SELECT COUNT(*) AS c FROM auditoria WHERE tipo='rol'")
    cambios_rol = cursor.fetchone()["c"]

    cursor.execute("SELECT COUNT(*) AS c FROM auditoria WHERE tipo='desactivar'")
    desactivaciones = cursor.fetchone()["c"]

    conn.close()

    return render_template("auditoria.html",
        auditoria=auditoria_registros,
        total_acciones=total_acciones,
        pagos_hoy=pagos_hoy,
        cambios_rol=cambios_rol,
        desactivaciones=desactivaciones,
        buscar=buscar,
        tipo_filtro=tipo_filtro,
        pagina=pagina,
        total_paginas=total_paginas,
    )


# ─────────────────────────────────────────────
# CAMBIAR CONTRASEÑA (sabe la actual)
# ─────────────────────────────────────────────

@app.route("/cambiar_password", methods=["GET", "POST"])
def cambiar_password():
    if "usuario_id" not in session:
        return redirect("/login")

    if request.method == "GET":
        return render_template("cambiar_password.html")

    actual    = request.form.get("password_actual", "").strip()
    nueva     = request.form.get("password_nueva", "").strip()
    confirmar = request.form.get("password_confirmar", "").strip()

    if not actual or not nueva or not confirmar:
        flash("Todos los campos son obligatorios", "error")
        return redirect("/cambiar_password")

    if nueva != confirmar:
        flash("Las contraseñas nuevas no coinciden", "error")
        return redirect("/cambiar_password")

    if len(nueva) < 6:
        flash("La contraseña debe tener al menos 6 caracteres", "error")
        return redirect("/cambiar_password")

    if nueva == actual:
        flash("La nueva contraseña debe ser diferente a la actual", "error")
        return redirect("/cambiar_password")

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT password FROM usuarios WHERE cui=%s", (session["usuario_id"],))
    usuario = cursor.fetchone()

    if not usuario or not check_password_hash(usuario["password"], actual):
        conn.close()
        flash("La contraseña actual es incorrecta", "error")
        return redirect("/cambiar_password")

    nuevo_hash = generate_password_hash(nueva)
    cursor = conn.cursor()
    cursor.execute("UPDATE usuarios SET password=%s WHERE cui=%s",
                   (nuevo_hash, session["usuario_id"]))
    conn.commit()
    conn.close()

    registrar_log("perfil", "Cambió su contraseña")
    flash("Contraseña actualizada correctamente ✓", "success")

    rol = session.get("rol")
    if rol == "admin":     return redirect("/admin")
    if rol == "empleado":  return redirect("/empleado")
    return redirect("/panel")


# ─────────────────────────────────────────────
# RECUPERAR CONTRASEÑA (olvidada)
# ─────────────────────────────────────────────


@app.route("/recuperar_contra", methods=["GET"])
def recuperar_contra_form():
    return render_template("recuperar_contra.html")


@app.route("/recuperar_contra", methods=["POST"])
def recuperar_contra():
    correo = request.form.get("correo", "").strip().lower()

    if not correo or "@" not in correo:
        flash("Ingresa un correo válido", "error")
        return redirect("/recuperar_contra")

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT cui, nombre, email FROM usuarios WHERE email=%s AND estado='activo'", (correo,))
    usuario = cursor.fetchone()

    if usuario:
        token  = secrets.token_urlsafe(48)
        expira = datetime.now() + timedelta(hours=1)

        cursor = conn.cursor()
        cursor.execute("UPDATE recuperar_contra SET usado=1 WHERE cui_usuario=%s AND usado=0", (usuario["cui"],))
        cursor.execute("""
            INSERT INTO recuperar_contra (cui_usuario, token, expira)
            VALUES (%s, %s, %s)
        """, (usuario["cui"], token, expira))
        conn.commit()
        conn.close()

        try:
            enviar_correo_reset(usuario["email"], token, usuario["nombre"])
        except Exception as e:
            print(f"[EMAIL ERROR] {e}")
            flash(f"Error al enviar el correo: {str(e)}", "error")
            return redirect("/recuperar_contra")
    else:
        conn.close()

    flash("Si ese correo está registrado, recibirás un enlace en los próximos minutos.", "success")
    return redirect("/recuperar_contra")


@app.route("/reset_password/<token>", methods=["GET"])
def reset_password_form(token):
    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT * FROM recuperar_contra
        WHERE token=%s AND usado=0 AND expira > NOW()
    """, (token,))
    reset = cursor.fetchone()
    conn.close()

    if not reset:
        flash("El enlace es inválido o ya expiró. Solicita uno nuevo.", "error")
        return redirect("/recuperar_contra")

    return render_template("reset_password.html", token=token)


@app.route("/reset_password/<token>", methods=["POST"])
def reset_password(token):
    nueva     = request.form.get("password_nueva", "").strip()
    confirmar = request.form.get("password_confirmar", "").strip()

    if not nueva or not confirmar:
        flash("Completa todos los campos", "error")
        return redirect(f"/reset_password/{token}")

    if nueva != confirmar:
        flash("Las contraseñas no coinciden", "error")
        return redirect(f"/reset_password/{token}")

    if len(nueva) < 6:
        flash("La contraseña debe tener al menos 6 caracteres", "error")
        return redirect(f"/reset_password/{token}")

    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
        SELECT * FROM recuperar_contra
        WHERE token=%s AND usado=0 AND expira > NOW()
    """, (token,))
    reset = cursor.fetchone()

    if not reset:
        conn.close()
        flash("El enlace expiró. Solicita uno nuevo.", "error")
        return redirect("/recuperar_contra")

    nuevo_hash = generate_password_hash(nueva)
    cursor = conn.cursor()
    cursor.execute("UPDATE usuarios SET password=%s WHERE cui=%s",
                   (nuevo_hash, reset["cui_usuario"]))
    cursor.execute("UPDATE recuperar_contra SET usado=1 WHERE token=%s", (token,))
    conn.commit()
    conn.close()

    flash("¡Contraseña restablecida! Ya puedes iniciar sesión.", "success")
    return redirect("/login")


# ─────────────────────────────────────────────
# PANEL EMPLEADO
# ─────────────────────────────────────────────

@app.route("/empleado")
def empleado_panel():
    if "usuario_id" not in session or session.get("rol") not in ("admin", "empleado"):
        return redirect("/login")

    buscar = request.args.get("buscar", "")
    conn   = conectar_db()
    cursor = conn.cursor(dictionary=True)

    query = """
        SELECT u.cui, u.tipo_doc, u.nombre, u.apellido, u.estado,
               (SELECT MAX(fecha_vencimiento) FROM pagos WHERE cui_usuario = u.cui) AS ultimo_vencimiento
        FROM usuarios u
        WHERE u.rol = 'user'
    """
    params = []
    if buscar:
        query += " AND (u.nombre LIKE %s OR u.apellido LIKE %s)"
        params.extend([f"%{buscar}%", f"%{buscar}%"])

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

    # Datos del perfil
    cursor.execute("""
        SELECT nombre, apellido, email,
               edad, peso, altura, clase, horario, objetivo, fecha_registro
        FROM usuarios
        WHERE cui=%s
    """, (session["usuario_id"],))
    perfil = cursor.fetchone()

    # Calcular IMC
    imc = None
    imc_categoria = None
    imc_color = None
    imc_consejo = None
    if perfil and perfil["peso"] and perfil["altura"] and float(perfil["altura"]) > 0:
        peso_kg = float(perfil["peso"]) * 0.453592  # libras a kg
        altura_m = float(perfil["altura"])
        imc = round(peso_kg / (altura_m ** 2), 1)
        if imc < 18.5:
            imc_categoria = "Bajo peso"
            imc_color = "blue"
            imc_consejo = "Tu peso está por debajo del rango saludable. Considera aumentar tu ingesta calórica con alimentos nutritivos."
        elif imc < 25:
            imc_categoria = "Peso normal"
            imc_color = "green"
            imc_consejo = "¡Excelente! Tu peso está en el rango saludable. Mantén tus hábitos de ejercicio y alimentación."
        elif imc < 30:
            imc_categoria = "Sobrepeso"
            imc_color = "yellow"
            imc_consejo = "Estás ligeramente por encima del rango saludable. El ejercicio regular y una dieta balanceada te ayudarán."
        else:
            imc_categoria = "Obesidad"
            imc_color = "red"
            imc_consejo = "Te recomendamos consultar con un especialista para un plan personalizado de ejercicio y nutrición."

    # Estadísticas de pagos
    cursor.execute("""
        SELECT COUNT(*) AS total_pagos,
               COALESCE(SUM(monto), 0) AS total_pagado,
               MAX(fecha_vencimiento) AS vencimiento
        FROM pagos WHERE cui_usuario=%s
    """, (session["usuario_id"],))
    stats = cursor.fetchone()

    # Meses como miembro
    meses_miembro = 0
    if perfil and perfil["fecha_registro"]:
        from datetime import datetime
        hoy = date.today()
        reg = perfil["fecha_registro"]
        if hasattr(reg, 'date'):
            reg = reg.date()
        meses_miembro = (hoy.year - reg.year) * 12 + (hoy.month - reg.month)

    # Historial de pagos
    cursor.execute("""
        SELECT id_pago, fecha_pago, fecha_vencimiento, monto, mes_pagado
        FROM pagos WHERE cui_usuario=%s
        ORDER BY fecha_pago DESC
    """, (session["usuario_id"],))
    historial_pagos = cursor.fetchall()

    # Streak: meses consecutivos pagados a tiempo
    hoy_date = date.today()
    cursor.execute("""
        SELECT YEAR(fecha_pago) as anio, MONTH(fecha_pago) as mes
        FROM pagos WHERE cui_usuario=%s
        ORDER BY fecha_pago DESC
    """, (session["usuario_id"],))
    pagos_meses = cursor.fetchall()
    streak = 0
    if pagos_meses:
        seen = set((r["anio"], r["mes"]) for r in pagos_meses)
        check_year, check_month = hoy_date.year, hoy_date.month
        for _ in range(120):
            if (check_year, check_month) in seen:
                streak += 1
                if check_month == 1:
                    check_month = 12; check_year -= 1
                else:
                    check_month -= 1
            else:
                break

    conn.close()
    return render_template("panel.html", perfil=perfil,
                           imc=imc, imc_categoria=imc_categoria,
                           imc_color=imc_color, imc_consejo=imc_consejo,
                           stats=stats, meses_miembro=meses_miembro,
                           historial_pagos=historial_pagos,
                           streak=streak)


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
    cursor.execute("UPDATE usuarios SET edad=%s, peso=%s, altura=%s, objetivo=%s WHERE cui=%s",
                   (edad, peso, altura, objetivo, session["usuario_id"]))
    conn.commit(); conn.close()
    registrar_log("perfil", f"Completó perfil — Objetivo: {objetivo}")
    return redirect("/panel")


@app.route("/actualizar_info", methods=["POST"])
def actualizar_info():
    if "usuario_id" not in session:
        return redirect("/login")
    nombre = request.form.get("nombre"); apellido = request.form.get("apellido")
    email  = request.form.get("email");  peso     = request.form.get("peso")
    conn = conectar_db(); cursor = conn.cursor()
    if nombre and apellido and email:
        cursor.execute("UPDATE usuarios SET nombre=%s, apellido=%s, email=%s WHERE cui=%s",
                       (nombre, apellido, email, session["usuario_id"]))
    if peso:
        cursor.execute("UPDATE usuarios SET peso=%s WHERE cui=%s", (peso, session["usuario_id"]))
    conn.commit(); conn.close()
    if nombre: session["nombre"] = nombre
    registrar_log("perfil", "Actualizó su información personal")
    flash("Información actualizada", "success")
    return redirect("/panel")


@app.route("/actualizar_objetivo", methods=["POST"])
def actualizar_objetivo():
    if "usuario_id" not in session:
        return redirect("/login")
    objetivo = request.form.get("objetivo")
    if objetivo:
        conn = conectar_db(); cursor = conn.cursor()
        cursor.execute("UPDATE usuarios SET objetivo=%s WHERE cui=%s",
                       (objetivo, session["usuario_id"]))
        conn.commit(); conn.close()
        registrar_log("perfil", f"Cambió su objetivo a: {objetivo}")
        flash("Objetivo actualizado correctamente", "success")
    return redirect("/panel")


@app.route("/actualizar_entrenamiento", methods=["POST"])
def actualizar_entrenamiento():
    if "usuario_id" not in session:
        return redirect("/login")
    clase = request.form["clase"]; horario = request.form["horario"]
    conn = conectar_db(); cursor = conn.cursor()
    cursor.execute("UPDATE usuarios SET clase=%s, horario=%s WHERE cui=%s",
                   (clase, horario, session["usuario_id"]))
    conn.commit(); conn.close()
    registrar_log("perfil", f"Actualizó entrenamiento — {clase} / {horario}")
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
               u.cui, u.tipo_doc, u.nombre, u.apellido, u.email
        FROM pagos p
        JOIN usuarios u ON u.cui = p.cui_usuario
        WHERE p.id_pago = %s
    """, (id_pago,))
    pago = cursor.fetchone()
    conn.close()

    if not pago:
        flash("Pago no encontrado", "error")
        return redirect("/panel")

    # Admins y empleados pueden ver cualquier recibo
    # Clientes solo pueden ver SUS propios recibos
    es_admin_emp = session.get("rol") in ("admin", "empleado")
    es_dueno     = pago["cui"] == session.get("usuario_id")
    if not es_admin_emp and not es_dueno:
        return redirect("/panel")

    buf = BytesIO()
    c = canvas.Canvas(buf, pagesize=letter)
    width, height = letter

    negro     = HexColor("#0d0d0d")
    naranja   = HexColor("#FF6B00")
    gris_dark = HexColor("#333333")
    gris      = HexColor("#666666")
    blanco    = HexColor("#ffffff")
    verde     = HexColor("#22c55e")

    c.setFillColor(negro)
    c.rect(0, height - 140, width, 140, fill=True, stroke=False)

    logo_path = os.path.join(app.static_folder, 'logo.png')
    if os.path.exists(logo_path):
        c.drawImage(logo_path, 50, height - 95, width=55, height=55,
                    preserveAspectRatio=True, mask='auto')
    c.setFillColor(blanco)
    c.setFont("Helvetica-Bold", 28)
    c.drawString(115, height - 60, "BODYFLEX")
    c.setFillColor(naranja)
    c.drawString(115 + c.stringWidth("BODYFLEX", "Helvetica-Bold", 28), height - 60, "GYM")

    c.setFillColor(HexColor("#aaaaaa"))
    c.setFont("Helvetica", 10)
    c.drawString(115, height - 80, "Recibo de pago de membresía")

    c.setFillColor(naranja)
    c.setFont("Helvetica-Bold", 12)
    c.drawRightString(width - 50, height - 55, f"RECIBO #{pago['id_pago']:04d}")

    c.setFillColor(HexColor("#aaaaaa"))
    c.setFont("Helvetica", 10)
    fecha_str = pago['fecha_pago'].strftime('%d/%m/%Y') if pago['fecha_pago'] else 'N/A'
    c.drawRightString(width - 50, height - 75, f"Fecha: {fecha_str}")

    c.setStrokeColor(naranja)
    c.setLineWidth(3)
    c.line(50, height - 150, width - 50, height - 150)

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
    num_socio = f"CUI: {pago['cui']}"
    c.drawString(50, y - 38, f"No. Socio: {num_socio}")

    y = height - 290
    c.setFillColor(HexColor("#f5f5f5"))
    c.rect(50, y - 5, width - 100, 28, fill=True, stroke=False)

    c.setFillColor(gris)
    c.setFont("Helvetica-Bold", 9)
    c.drawString(60, y + 3, "PAGO")
    c.drawString(280, y + 3, "FECHA PAGO")
    c.drawString(390, y + 3, "VENCIMIENTO")
    c.drawRightString(width - 60, y + 3, "MONTO")

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

    y -= 15
    c.setStrokeColor(HexColor("#e0e0e0"))
    c.setLineWidth(0.5)
    c.line(50, y, width - 50, y)

    y -= 30
    c.setFillColor(negro)
    c.setFont("Helvetica-Bold", 10)
    c.drawString(60, y + 3, "TOTAL")
    c.setFont("Helvetica-Bold", 16)
    c.drawRightString(width - 60, y + 3, f"Q{pago['monto']:.2f}")

    y -= 70
    c.setStrokeColor(verde)
    c.setFillColor(verde)
    c.setLineWidth(2)
    c.roundRect(width / 2 - 60, y - 5, 120, 35, 6, fill=False, stroke=True)
    c.setFont("Helvetica-Bold", 18)
    c.drawCentredString(width / 2, y + 5, "PAGADO")

    c.setFillColor(HexColor("#f8f8f8"))
    c.rect(0, 0, width, 60, fill=True, stroke=False)
    c.setStrokeColor(HexColor("#e0e0e0"))
    c.setLineWidth(0.5)
    c.line(0, 60, width, 60)
    c.setFillColor(gris)
    c.setFont("Helvetica", 8)
    c.drawCentredString(width / 2, 35, "Bodyflex Gym — Sistema de Gestión de Membresías")
    c.drawCentredString(width / 2, 22, f"Recibo generado automáticamente · {date.today().strftime('%d/%m/%Y')}")

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

# ─────────────────────────────────────────────
# RUTA DE PRUEBA DE CORREO — solo para desarrollo
# Visita http://localhost:5000/test_email para probar
# BORRA esta ruta antes de subir a producción
# ─────────────────────────────────────────────

@app.route("/test_email")
def test_email():
    if "usuario_id" not in session or session.get("rol") != "admin":
        return redirect("/login")
    try:
        import smtplib
        # Verificar que el password no tenga espacios
        pwd = GMAIL_PASSWORD.replace(" ", "")
        with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
            server.login(GMAIL_USER, pwd)
            from email.mime.text import MIMEText
            msg = MIMEText("✅ Correo de prueba desde Bodyflex Gym — configuración correcta.")
            msg["Subject"] = "Prueba de correo — Bodyflex Gym"
            msg["From"]    = GMAIL_USER
            msg["To"]      = GMAIL_USER
            server.sendmail(GMAIL_USER, GMAIL_USER, msg.as_string())
        return f"""
        <div style='font-family:sans-serif;padding:40px;background:#0f0f0f;color:#f5f5f5;min-height:100vh;'>
            <h2 style='color:#22c55e;'>✅ Correo enviado correctamente</h2>
            <p>Revisa tu bandeja de entrada en <strong>{GMAIL_USER}</strong></p>
            <p style='color:#9ca3af;margin-top:16px;'>Usuario: {GMAIL_USER}<br>
            Password length: {len(pwd)} caracteres</p>
            <a href='/admin' style='color:#FF6B00;'>← Volver al panel</a>
        </div>"""
    except Exception as e:
        return f"""
        <div style='font-family:sans-serif;padding:40px;background:#0f0f0f;color:#f5f5f5;min-height:100vh;'>
            <h2 style='color:#ef4444;'>❌ Error al enviar</h2>
            <p style='background:#1a1a1a;padding:16px;border-radius:8px;border:1px solid #2e2e2e;
                      color:#ef4444;font-family:monospace;'>{str(e)}</p>
            <p style='color:#9ca3af;margin-top:16px;'>Usuario: {GMAIL_USER}<br>
            Password length: {len(GMAIL_PASSWORD.replace(" ",""))} caracteres</p>
            <p style='color:#9ca3af;margin-top:12px;'>Soluciones comunes:<br>
            1. App Password sin espacios (16 caracteres exactos)<br>
            2. Verificación en 2 pasos activa en Gmail<br>
            3. El correo GMAIL_USER debe ser el mismo donde creaste el App Password</p>
            <a href='/admin' style='color:#FF6B00;'>← Volver al panel</a>
        </div>"""


@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/registro")
def registro():
    return render_template("registro.html")

@app.route("/logout")
def logout():
    registrar_log("login", "Cerró sesión")
    session.clear()
    return redirect("/login")

@app.route("/")
def inicio():
    return render_template("inicio.html")




if __name__ == "__main__":
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port, debug=False)
