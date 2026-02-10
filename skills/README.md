# 🛠️ Skills - Habilidades del Agente

## Skills Incluidos en el Kit

| Skill | Descripción |
|-------|-------------|
| `workspace-organizer` | Organización de archivos y proyectos |
| `skill-creator` | Crear nuevos skills personalizados |

## 🔍 Buscar Más Skills

Antes de investigar manualmente, siempre buscar si existe un skill:

### skills.sh (Directorio Principal)

```bash
# Buscar en la web
web_search "site:skills.sh [tema]"

# Visitar directamente
# https://skills.sh

# Instalar skill
npx skills add owner/repo --yes
```

### ClawdHub

```bash
web_search "site:clawdhub.com [tema]"
```

## 📦 Instalar Skills

```bash
# Desde skills.sh
npx skills add owner/repo --yes

# Ejemplos populares:
npx skills add anthropics/analysis --yes
npx skills add vercel/nextjs --yes
npx skills add openai/prompting --yes
```

## 🔧 Crear Skills Propios

Usa el skill `skill-creator` incluido:

1. Leer `skill-creator/SKILL.md`
2. Ejecutar `scripts/init_skill.py`
3. Editar el skill
4. Empaquetar con `scripts/package_skill.py`

### Estructura de un Skill

```
mi-skill/
├── SKILL.md          # Documentación (requerido)
├── scripts/          # Scripts ejecutables (opcional)
├── references/       # Documentación extra (opcional)
└── assets/           # Archivos de salida (opcional)
```

### Frontmatter Requerido

```yaml
---
name: mi-skill
description: Descripción clara de qué hace y cuándo usarlo.
---
```

## 📍 Ubicaciones

| Tipo | Ubicación |
|------|-----------|
| Skills de OpenClaw | `~/clawdbot/skills/` (no modificar) |
| Skills personalizados | `workspace/skills/` (crear aquí) |
| Skills instalados | `workspace/skills/.agents/skills/` |

## 🎯 Regla de Oro

> **Siempre buscar si existe un skill antes de investigar manualmente.**
> Los skills están curados, probados y optimizados para no desperdiciar contexto.

---

*Skills disponibles en: https://skills.sh*
