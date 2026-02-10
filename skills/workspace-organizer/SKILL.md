---
name: workspace-organizer
description: Reglas de organización del workspace. Usar cuando se creen archivos, proyectos, o se necesite saber dónde guardar algo.
---

# Workspace Organizer

Sistema de organización de archivos y proyectos.

## Cuándo Usar Este Skill

- Al crear un nuevo archivo y no saber dónde guardarlo
- Al iniciar un nuevo proyecto
- Al recibir archivos del usuario
- Al generar documentación o reportes
- Para limpiar o reorganizar

---

## 🏗️ Estructura del VPS

```
/home/[user]/
│
├── 🏠 .openclaw/              ← RUNTIME DEL AGENTE
│   ├── workspace/             ← Espacio de trabajo principal
│   ├── secrets/               ← API keys y credenciales
│   ├── media/                 ← Archivos multimedia
│   └── logs/                  ← Logs del sistema
│
├── 📦 projects/               ← CÓDIGO DE PROYECTOS
│   ├── proyecto-alpha/
│   ├── proyecto-beta/
│   └── [nuevo-proyecto]/
│
├── 📜 scripts/                ← AUTOMATIZACIONES
│   └── [scripts varios]
│
└── 🔧 clawdbot/               ← CÓDIGO FUENTE OPENCLAW (no tocar)
```

---

## 📁 Estructura del Workspace

```
~/.openclaw/workspace/
│
├── 📄 ARCHIVOS DE SISTEMA (raíz)
│   ├── AGENTS.md      → Reglas de operación
│   ├── SOUL.md        → Personalidad
│   ├── USER.md        → Info del usuario
│   ├── IDENTITY.md    → Identidad del agente
│   ├── MEMORY.md      → Memoria largo plazo
│   ├── TOOLS.md       → Notas de herramientas
│   └── HEARTBEAT.md   → Checklist periódico
│
├── 🧠 memory/
│   ├── daily/         → Diarios (YYYY-MM-DD.md)
│   └── projects/      → Estado de proyectos (proyecto-*.md)
│
├── 🚀 projects/       → Documentación de proyectos
│   ├── proyecto-alpha/
│   └── proyecto-beta/
│
├── 📚 docs/
│   ├── guias/         → Tutoriales, how-tos
│   └── references/    → Workflows, patrones
│
├── 🛠️ skills/         → Skills personalizados
│
└── ⏳ temp/           → Temporal (auto-limpieza)
```

---

## 📋 Reglas de Organización

### ¿Dónde Guardar Qué?

| Tipo de Archivo | Ubicación | Ejemplo |
|-----------------|-----------|---------|
| Código de proyecto | `~/projects/[nombre]/` | `~/projects/mi-app/` |
| Estado de proyecto | `workspace/memory/projects/` | `proyecto-mi-app.md` |
| Docs de proyecto | `workspace/projects/[nombre]/` | `projects/mi-app/README.md` |
| Diario del día | `workspace/memory/daily/` | `2026-02-10.md` |
| Tutorial/guía | `workspace/docs/guias/` | `como-instalar-X.md` |
| Workflow/patrón | `workspace/docs/references/` | `deploy-workflow.md` |
| Archivo temporal | `workspace/temp/` | `borrador.md` |
| Script de automatización | `~/scripts/` | `backup.sh` |
| Skill personalizado | `workspace/skills/` | `mi-skill/SKILL.md` |
| Error log | `workspace/memory/projects/` | `proyecto-X-error-log.md` |

### Nuevo Proyecto (con código)

```
1. mkdir ~/projects/[nombre]/
2. Crear workspace/memory/projects/proyecto-[nombre].md
3. Crear workspace/projects/[nombre]/ para docs
```

### Nuevo Proyecto (solo documentación)

```
1. Crear workspace/memory/projects/proyecto-[nombre].md
2. Crear workspace/projects/[nombre]/ si necesita archivos
```

### Archivo Temporal vs Permanente

**TEMPORAL (va a temp/):**
- Borradores
- Exports puntuales
- Archivos de una sola conversación
- Pruebas

**PERMANENTE (NO va a temp/):**
- Documentación de proyectos
- Guías reutilizables
- Workflows
- Referencias

---

## 🧹 Limpieza Automática

| Ubicación | Retención |
|-----------|-----------|
| `workspace/temp/` | 15 días |
| `media/inbound/` | 15 días |
| `logs/*.log` | 30 días |

---

## 📝 Convenciones de Nombres

### Archivos
- Usar kebab-case: `mi-archivo.md`
- Incluir fecha si es relevante: `2026-02-10-reporte.md`
- Ser descriptivo: `estrategia-ventas.md` NO `doc1.md`

### Carpetas
- Usar kebab-case: `mi-proyecto/`
- Sin espacios ni caracteres especiales

### Proyectos
- Estado: `proyecto-[nombre].md`
- Error log: `proyecto-[nombre]-error-log.md`
- Código: `~/projects/[nombre]/`
- Docs: `workspace/projects/[nombre]/`

---

## 🛠️ Skills

### Dos Ubicaciones

| Ubicación | Propósito |
|-----------|-----------|
| `~/clawdbot/skills/` | Skills de OpenClaw (NO MODIFICAR) |
| `workspace/skills/` | **Skills personalizados (CREAR AQUÍ)** |

### Estructura de un Skill

```
workspace/skills/mi-skill/
├── SKILL.md          # Documentación principal (requerido)
├── references/       # Archivos de referencia (opcional)
└── scripts/          # Scripts del skill (opcional)
```

---

## 🔧 Comandos Útiles

```bash
# Ver estructura del workspace
tree ~/.openclaw/workspace -L 2

# Ver tamaño de temp
du -sh ~/.openclaw/workspace/temp/

# Buscar archivos recientes
find ~/.openclaw/workspace -mtime -1 -type f

# Limpiar temp manualmente
find ~/.openclaw/workspace/temp -mtime +15 -delete
```

---

*Este skill define la organización. Consultarlo antes de crear archivos.*
