import sys

with open('c:/Users/Kevin/Desktop/gym_web/gym_web/templates/admin.html', 'r', encoding='utf-8') as f:
    lines = f.readlines()

# find sidebar index
reportes_link = '                <a href="/admin/reportes" class="sidebar-link">\\n                    <span class="icon">📈</span><span class="sidebar-label">Reportes</span>\\n                </a>\\n'
sidebar_insert_idx = next(i for i, l in enumerate(lines) if 'href="/admin/auditoria"' in l) + 3

# find bento stats
bento_stats_start = next(i for i, l in enumerate(lines) if '<!-- ─── BENTO STATS ─── -->' in l)
metrics_start = next(i for i, l in enumerate(lines) if '<!-- ─── METRICS DASHBOARD ─── -->' in l)
socios_start = next(i for i, l in enumerate(lines) if '<!-- ─── SOCIOS ─── -->' in l)

# Create reportes.html
reportes_lines = lines[:sidebar_insert_idx] + [reportes_link] + lines[sidebar_insert_idx:bento_stats_start]
reportes_lines += [
    '                <div class="section-hd">\\n',
    '                    <div class="section-hd-title">Reportes <small>métricas de ingresos</small></div>\\n',
    '                </div>\\n'
]
reportes_lines += lines[metrics_start:socios_start]
reportes_lines += lines[1437:1537] # end of layout up to sidebar toggle script
reportes_lines += lines[1741:1795] # chart js script up to end

# Fix active class
for i, line in enumerate(reportes_lines):
    if 'class="sidebar-link active"' in line and 'href="/admin"' in line:
        reportes_lines[i] = line.replace('class="sidebar-link active"', 'class="sidebar-link"')
    if 'href="/admin/reportes"' in line and 'class="sidebar-link"' in line:
        reportes_lines[i] = line.replace('class="sidebar-link"', 'class="sidebar-link active"')

with open('c:/Users/Kevin/Desktop/gym_web/gym_web/templates/reportes.html', 'w', encoding='utf-8') as f:
    f.writelines(reportes_lines)

print('Created reportes.html')
