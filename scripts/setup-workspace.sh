#!/bin/bash

# ============================================
# OpenClaw Starter Kit - Setup Script
# ============================================
# Este script configura la estructura completa
# del workspace después de instalar OpenClaw
# ============================================

set -e

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Directorio base
WORKSPACE="${HOME}/.openclaw/workspace"
TEMPLATE_DIR="$(dirname "$0")/.."

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   OpenClaw Starter Kit - Setup${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

# Verificar que OpenClaw está instalado
if [ ! -d "${HOME}/.openclaw" ]; then
    echo -e "${YELLOW}⚠️  OpenClaw no está instalado.${NC}"
    echo "Ejecuta primero: openclaw setup"
    echo "Ver: https://docs.openclaw.ai/start/getting-started"
    exit 1
fi

# Crear estructura de directorios
echo -e "${GREEN}📁 Creando estructura de directorios...${NC}"

mkdir -p "${WORKSPACE}/memory/daily"
mkdir -p "${WORKSPACE}/memory/projects"
mkdir -p "${WORKSPACE}/projects"
mkdir -p "${WORKSPACE}/docs/guias"
mkdir -p "${WORKSPACE}/docs/references"
mkdir -p "${WORKSPACE}/skills"
mkdir -p "${WORKSPACE}/temp"
mkdir -p "${HOME}/projects"
mkdir -p "${HOME}/scripts"

echo "   ✓ Directorios creados"

# Copiar archivos base
echo -e "${GREEN}📄 Copiando archivos de sistema...${NC}"

# Solo copiar si no existen (no sobrescribir)
for file in SOUL.md IDENTITY.md USER.md; do
    if [ ! -f "${WORKSPACE}/${file}" ]; then
        cp "${TEMPLATE_DIR}/base/${file}" "${WORKSPACE}/${file}"
        echo "   ✓ ${file} (nuevo)"
    else
        echo "   - ${file} (ya existe, no modificado)"
    fi
done

# Estos sí se pueden sobrescribir (son operacionales, no personales)
for file in AGENTS.md TOOLS.md HEARTBEAT.md; do
    cp "${TEMPLATE_DIR}/base/${file}" "${WORKSPACE}/${file}"
    echo "   ✓ ${file}"
done

# MEMORY.md solo si no existe
if [ ! -f "${WORKSPACE}/MEMORY.md" ]; then
    cp "${TEMPLATE_DIR}/base/MEMORY.md" "${WORKSPACE}/MEMORY.md"
    echo "   ✓ MEMORY.md (nuevo)"
else
    echo "   - MEMORY.md (ya existe, no modificado)"
fi

# Copiar workflows
echo -e "${GREEN}📚 Copiando workflows...${NC}"

cp "${TEMPLATE_DIR}/workflows/"*.md "${WORKSPACE}/docs/references/"
echo "   ✓ Workflows copiados a docs/references/"

# Copiar skills
echo -e "${GREEN}🛠️  Copiando skills...${NC}"

cp -r "${TEMPLATE_DIR}/skills/"* "${WORKSPACE}/skills/"
echo "   ✓ Skills copiados"

# Crear README en carpetas
echo -e "${GREEN}📝 Creando READMEs...${NC}"

cat > "${WORKSPACE}/memory/README.md" << 'EOF'
# Memory

## Estructura

- `daily/` - Diarios por fecha (YYYY-MM-DD.md)
- `projects/` - Estado de proyectos (proyecto-*.md)

## Uso

### Diario
Crear archivo con la fecha del día para registrar eventos importantes.

### Proyecto
Crear `proyecto-[nombre].md` para cada proyecto activo.
Crear `proyecto-[nombre]-error-log.md` para errores del proyecto.
EOF

cat > "${WORKSPACE}/projects/README.md" << 'EOF'
# Projects

Carpetas de documentación por proyecto.

## Estructura

```
projects/
├── proyecto-alpha/
│   ├── README.md
│   └── [otros docs]
└── proyecto-beta/
    └── README.md
```

## Nota

El código de proyectos va en `~/projects/`, no aquí.
Esta carpeta es para documentación y archivos de trabajo.
EOF

cat > "${WORKSPACE}/temp/README.md" << 'EOF'
# Temp

Archivos temporales. Se limpian automáticamente después de 15 días.

## Uso

- Borradores
- Exports puntuales
- Pruebas
- Archivos de una sola conversación

## No poner aquí

- Documentación permanente
- Archivos de proyectos
- Configuraciones
EOF

echo "   ✓ READMEs creados"

# Crear script de limpieza
echo -e "${GREEN}🧹 Creando script de limpieza...${NC}"

cat > "${HOME}/scripts/cleanup-temp.sh" << 'EOF'
#!/bin/bash
# Limpieza automática de archivos temporales

WORKSPACE="${HOME}/.openclaw/workspace"
MEDIA="${HOME}/.openclaw/media"
LOGS="${HOME}/logs"

echo "$(date): Iniciando limpieza..."

# Temp: 15 días
find "${WORKSPACE}/temp" -type f -mtime +15 -delete 2>/dev/null
echo "  - temp/ limpiado"

# Media inbound: 15 días
find "${MEDIA}/inbound" -type f -mtime +15 -delete 2>/dev/null
echo "  - media/inbound/ limpiado"

# Logs: 30 días
find "${LOGS}" -name "*.log" -mtime +30 -delete 2>/dev/null
echo "  - logs/ limpiado"

echo "$(date): Limpieza completada"
EOF

chmod +x "${HOME}/scripts/cleanup-temp.sh"
echo "   ✓ cleanup-temp.sh creado"

# Resumen
echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${GREEN}✅ Setup completado!${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo "Próximos pasos:"
echo ""
echo "1. Edita los archivos personales:"
echo "   - ${WORKSPACE}/SOUL.md"
echo "   - ${WORKSPACE}/IDENTITY.md"
echo "   - ${WORKSPACE}/USER.md"
echo ""
echo "2. Configura limpieza automática (opcional):"
echo "   crontab -e"
echo "   # Agregar: 0 3 * * * ${HOME}/scripts/cleanup-temp.sh >> ${HOME}/logs/cleanup.log 2>&1"
echo ""
echo "3. Inicia OpenClaw:"
echo "   openclaw gateway install   # Instalar como servicio"
echo "   openclaw gateway status    # Verificar estado"
echo ""
