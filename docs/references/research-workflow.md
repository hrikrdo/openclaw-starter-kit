# 🔬 Research Workflow - Búsqueda Profunda

## Propósito
Workflow para investigar y aprender de forma efectiva antes de trabajar en cualquier área.

**⚠️ REGLA:** Cuando Richard diga "investiga", SIEMPRE seguir este workflow completo incluyendo NotebookLM con Deep Research.

---

## 📋 Workflow Completo

### 1️⃣ Antes de Empezar (Investigación)

```
1. Identificar el área/problema
2. Crear/verificar notebook en NotebookLM
3. EJECUTAR DEEP RESEARCH (NotebookLM busca ~40-100 fuentes automáticamente)
4. Esperar e importar fuentes
5. Consultar notebook para síntesis
6. Condensar todo en documento final
```

### 2️⃣ Deep Research con NotebookLM (OBLIGATORIO)

```bash
# PASO 1: Crear notebook (si no existe)
mcporter call notebooklm.notebook_create title="Investigación: [tema]"

# PASO 2: Iniciar Deep Research (NotebookLM busca en web automáticamente)
mcporter call notebooklm.research_start \
  query="[pregunta de investigación detallada]" \
  source="web" \
  mode="deep" \
  notebook_id="[notebook_id]"

# Modos disponibles:
# - fast: ~30 segundos, ~10 fuentes
# - deep: ~5 minutos, ~40-100 fuentes ⭐ PREFERIDO

# PASO 3: Esperar a que termine
mcporter call notebooklm.research_status \
  notebook_id="[notebook_id]" \
  task_id="[task_id del paso anterior]" \
  poll_interval=30 \
  max_wait=300

# PASO 4: Importar fuentes al notebook
mcporter call notebooklm.research_import \
  notebook_id="[notebook_id]" \
  task_id="[task_id]"
```

### 3️⃣ Fuentes Adicionales (Opcional)

```bash
# Si quiero agregar fuentes específicas que conozco:
mcporter call notebooklm.notebook_add_url notebook_id="..." url="..."

# O contenido de web_fetch:
web_fetch url="..." maxChars=15000
mcporter call notebooklm.notebook_add_text notebook_id="..." text="..." title="..."
```

### 4️⃣ Consultar para Síntesis

```bash
# Preguntas específicas al notebook
mcporter call notebooklm.notebook_query \
  notebook_id="..." \
  query="¿cuál es la mejor opción para [problema]?"

mcporter call notebooklm.notebook_query \
  notebook_id="..." \
  query="pros y contras de cada alternativa"

mcporter call notebooklm.notebook_query \
  notebook_id="..." \
  query="recomendación final para [contexto específico]"
```

### 5️⃣ Buscar Skills Existentes

```bash
# Buscar skills ya curados
web_search "site:skills.sh tema"

# Instalar si existe
npx skills add owner/repo --yes
```

### 3️⃣ Antes de Codificar

```bash
# 1. Consultar notebook
mcporter call notebooklm.notebook_query notebook_id="..." query="problema específico"

# 2. Leer skill relevante
cat skills/.agents/skills/nombre-skill/SKILL.md

# 3. Revisar documento de mejores prácticas
cat docs/references/area-best-practices.md
```

### 4️⃣ Después de Errores

```bash
# 1. Documentar en error log
edit memory/projects/proyecto-error-log.md

# 2. Agregar lección a NotebookLM
mcporter call notebooklm.notebook_add_text notebook_id="..." text="..." title="Error..."

# 3. Actualizar mejores prácticas
edit docs/references/area-best-practices.md

# 4. Actualizar MEMORY.md con lección clave
```

### 4️⃣ Condensar y Documentar

```bash
# 1. Consultar notebook con preguntas específicas
mcporter call notebooklm.notebook_query notebook_id="..." query="resumen ejecutivo de opciones"
mcporter call notebooklm.notebook_query notebook_id="..." query="pros y contras de cada opción"
mcporter call notebooklm.notebook_query notebook_id="..." query="recomendación final basada en [contexto]"

# 2. Crear documento final en workspace
# Incluir: resumen, opciones, análisis, recomendación, referencias

# 3. El notebook queda como knowledge base para futuras consultas
```

---

## 📚 Notebooks por Área

| Área | Notebook ID | Fuentes | URL |
|------|-------------|---------|-----|
| **Trading Master** | `31701561-d2de-4c21-adb6-27989ee69cf8` | **102+** | [Link](https://notebooklm.google.com/notebook/31701561-d2de-4c21-adb6-27989ee69cf8) |
| React/Next.js | `824daaac-b632-4fb5-841f-0bc11610ab8b` | 11+ | [Link](https://notebooklm.google.com/notebook/824daaac-b632-4fb5-841f-0bc11610ab8b) |
| UI/UX Design | `585bf082-5290-4d05-9123-235d17ba057b` | 13 | [Link](https://notebooklm.google.com/notebook/585bf082-5290-4d05-9123-235d17ba057b) |

---

## 🎯 Reglas Clave

1. **NUNCA empezar a codificar sin consultar el notebook**
2. **Buscar 10-20 fuentes**, no solo 3-4
3. **Incluir documentación oficial + artículos de expertos + casos reales**
4. **Después de errores, SIEMPRE agregar al notebook**
5. **Skills > Investigación manual** (ya están curados)

---

## 📖 URLs de Notebooks

- **Trading Master (PRINCIPAL):** https://notebooklm.google.com/notebook/31701561-d2de-4c21-adb6-27989ee69cf8
- **React/Next.js:** https://notebooklm.google.com/notebook/824daaac-b632-4fb5-841f-0bc11610ab8b
- **UI/UX Design:** https://notebooklm.google.com/notebook/585bf082-5290-4d05-9123-235d17ba057b

---

*Última actualización: 2026-02-09*
