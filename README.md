# 🚀 OpenClaw Starter Kit

**Template completo para nuevas instalaciones de OpenClaw**

Un agente que no arranca desde cero. Incluye estructura, workflows, y conocimiento base para ser efectivo desde el día uno.

---

## ✨ ¿Qué incluye?

### 📄 Archivos Base (Editables)
Archivos para personalizar la identidad del agente:

| Archivo | Propósito |
|---------|-----------|
| `SOUL.md` | Personalidad y comportamiento |
| `IDENTITY.md` | Nombre, emoji, descripción |
| `USER.md` | Información del usuario |

### 📋 Archivos de Sistema (Pre-configurados)
Archivos que definen cómo opera el agente:

| Archivo | Propósito |
|---------|-----------|
| `AGENTS.md` | Manual de operaciones completo |
| `TOOLS.md` | Template para notas de herramientas |
| `HEARTBEAT.md` | Template para verificaciones periódicas |
| `MEMORY.md` | Template de memoria inicial |

### 📚 Workflows Incluidos
Procesos documentados para tareas comunes:

| Workflow | Descripción |
|----------|-------------|
| `research-workflow.md` | Cómo investigar efectivamente antes de actuar |
| `error-handling-workflow.md` | Cómo manejar y documentar errores |
| `verification-workflow.md` | Cómo verificar que los cambios funcionan |

### 🛠️ Skills Incluidos
Habilidades pre-configuradas:

| Skill | Descripción |
|-------|-------------|
| `workspace-organizer` | Reglas de organización de archivos y proyectos |

### 🔌 MCP Servers
Configuración de servicios externos:

| MCP | Descripción |
|-----|-------------|
| `NotebookLM` | Base de conocimiento con Google NotebookLM |
| `Google Stitch` | Generación de UI (opcional) |

### 📁 Estructura de Carpetas
Organización lista para usar:

```
workspace/
├── memory/
│   ├── daily/      # Diarios por fecha
│   └── projects/   # Estado de proyectos
├── projects/       # Docs de proyectos
├── docs/
│   ├── guias/      # Tutoriales
│   └── references/ # Workflows
├── skills/         # Skills personalizados
└── temp/           # Temporales
```

### 🔧 Scripts
Automatizaciones incluidas:

| Script | Descripción |
|--------|-------------|
| `setup-workspace.sh` | Configura toda la estructura automáticamente |
| `cleanup-temp.sh` | Limpia archivos temporales (para cron) |

---

## 🎯 Beneficios

✅ **No arranca desde cero** - Conocimiento base incluido

✅ **Organización clara** - Sabe dónde guardar cada cosa

✅ **Documenta automáticamente** - Workflows para no perder aprendizajes

✅ **Verifica su trabajo** - Checklist obligatoria post-cambios

✅ **Mejora continua** - Sistema de retroalimentación integrado

---

## 📦 Instalación Rápida

```bash
# 1. Después de instalar OpenClaw...

# 2. Obtener el kit
git clone https://github.com/hrikrdo/openclaw-starter-kit.git ~/starter-kit

# 3. Ejecutar setup
cd ~/starter-kit
chmod +x scripts/setup-workspace.sh
./scripts/setup-workspace.sh

# 4. Personalizar (obligatorio)
nano ~/.openclaw/workspace/IDENTITY.md
nano ~/.openclaw/workspace/SOUL.md
nano ~/.openclaw/workspace/USER.md

# 5. Listo! El agente ya tiene conocimiento base.
```

---

## 📖 Documentación

- **Instalación completa:** `docs/INSTALACION-COMPLETA.md`
- **Instalación en Contabo:** `docs/INSTALACION-CONTABO.md`
- **🔐 Seguridad para equipos:** `docs/SEGURIDAD-EQUIPOS.md`
- **Configuración de MCPs:** `mcp/README.md`
- **Workflows:** `workflows/*.md`
- **Skills:** `skills/*/SKILL.md`

---

## 🗂️ Contenido del Kit

```
openclaw-starter-kit/
├── README.md                    # Este archivo
├── base/                        # Archivos de sistema
│   ├── SOUL.md                  # [Editable] Personalidad
│   ├── IDENTITY.md              # [Editable] Identidad
│   ├── USER.md                  # [Editable] Info usuario
│   ├── AGENTS.md                # Manual de operaciones
│   ├── TOOLS.md                 # Template herramientas
│   ├── HEARTBEAT.md             # Template heartbeat
│   └── MEMORY.md                # Template memoria
├── workflows/                   # Procesos documentados
│   ├── research-workflow.md
│   ├── error-handling-workflow.md
│   └── verification-workflow.md
├── skills/                      # Skills incluidos
│   └── workspace-organizer/
│       └── SKILL.md
├── scripts/                     # Automatizaciones
│   └── setup-workspace.sh
└── docs/                        # Documentación
    └── INSTALACION-COMPLETA.md
```

---

## 🔄 Actualizaciones

Para actualizar el kit en una instalación existente:

```bash
# Solo actualiza archivos de sistema (no toca los personalizados)
cd ~/starter-kit
git pull
./scripts/setup-workspace.sh
```

El script NO sobrescribe SOUL.md, IDENTITY.md, USER.md ni MEMORY.md si ya existen.

---

## 🤝 Contribuir

¿Tienes workflows o skills útiles? ¡Agrégalos al kit!

1. Fork el repositorio
2. Agrega tu workflow a `workflows/`
3. O tu skill a `skills/`
4. Crea un PR

---

## 📜 Licencia

MIT - Usa, modifica, comparte libremente.

---

*OpenClaw Starter Kit v1.0*
*Basado en guía de [Velvet Shark](https://velvetshark.com/clawdbot-the-self-hosted-ai-that-siri-should-have-been)*
*Repo oficial OpenClaw: https://github.com/clawdbot/clawdbot*
