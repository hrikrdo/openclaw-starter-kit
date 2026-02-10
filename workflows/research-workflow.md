# 🔬 Research Workflow - Investigación Efectiva

## Propósito
Workflow para investigar y aprender de forma efectiva ANTES de trabajar en cualquier área nueva.

---

## 🎯 Regla Principal

> **NUNCA empezar a codificar/resolver sin investigar primero**

---

## 📋 Workflow Completo

### Fase 1: Antes de Empezar

```
1. Identificar el área/problema claramente
2. ¿Ya sé algo sobre esto?
   → Buscar en MEMORY.md (memory_search)
   → Revisar docs/references/
   
3. ¿Existe notebook en NotebookLM?
   → Si sí: consultar primero
   → Si no: crear notebook temático

4. Hacer BÚSQUEDA PROFUNDA (mínimo 10 fuentes)
5. Agregar fuentes relevantes al notebook
6. Sintetizar conocimiento clave antes de actuar
```

### Fase 2: Búsqueda Profunda

```bash
# 🔍 PASO 1: Buscar skills existentes PRIMERO (ya están curados)
web_search "site:skills.sh [tema]"
# Si encuentras un skill útil:
npx skills add owner/repo --yes

# También buscar en ClawdHub
web_search "site:clawdhub.com [tema]"

# 🔍 PASO 2: Buscar en web múltiples ángulos
web_search "[tema] best practices 2024"
web_search "[tema] common mistakes solutions"
web_search "[tema] advanced techniques"
web_search "[tema] official documentation"

# 🔍 PASO 3: Agregar fuentes útiles a NotebookLM
mcporter call notebooklm.notebook_add_url \
  notebook_id="..." \
  url="..."
```

### ⚡ Instalar Skills desde skills.sh

```bash
# Buscar skill disponible
# Visitar: https://skills.sh y buscar el tema

# Instalar skill
npx skills add owner/repo --yes

# Ejemplos:
npx skills add anthropics/analysis --yes
npx skills add vercel/nextjs --yes
```

**Regla:** Siempre buscar si existe un skill antes de investigar manualmente. Los skills ya están curados y probados.

### Fase 3: Antes de Codificar/Resolver

```bash
# 1. Consultar notebook consolidado
mcporter call notebooklm.notebook_query \
  notebook_id="..." \
  query="[problema específico]"

# 2. Leer skill si existe
cat skills/[relevant-skill]/SKILL.md

# 3. Revisar mejores prácticas documentadas
cat docs/references/[area]-best-practices.md
```

### Fase 4: Después de Errores

```bash
# 1. Documentar en error log del proyecto
edit memory/projects/proyecto-[X]-error-log.md

# 2. Agregar lección al notebook
mcporter call notebooklm.notebook_add_text \
  notebook_id="..." \
  text="Error: [descripción]. Solución: [fix]. Lección: [aprendizaje]" \
  title="Error [fecha]: [título]"

# 3. Actualizar mejores prácticas si aplica
edit docs/references/[area]-best-practices.md

# 4. Si es lección importante global → MEMORY.md
```

---

## 📊 Niveles de Investigación

| Complejidad | Fuentes Mínimas | Tiempo |
|-------------|-----------------|--------|
| Simple (bug conocido) | 2-3 | 5 min |
| Medio (feature nueva) | 5-10 | 15-30 min |
| Complejo (área nueva) | 15-20+ | 1-2 hrs |

---

## 🗂️ Organización de Notebooks

### Estructura Recomendada
- **Un notebook por área/dominio** (no por proyecto)
- Ejemplos: "Frontend React", "Trading", "DevOps", "UI/UX"

### Qué agregar a notebooks:
- ✅ Documentación oficial
- ✅ Artículos de expertos reconocidos
- ✅ Casos de estudio reales
- ✅ Errores resueltos con explicación
- ✅ Best practices consolidadas

### Qué NO agregar:
- ❌ Artículos genéricos/superficiales
- ❌ Contenido desactualizado (>2 años)
- ❌ Opiniones sin fundamento

---

## 🔁 Mantenimiento de Conocimiento

### Semanal
- Revisar errores de la semana
- Agregar fuentes relevantes encontradas
- Actualizar docs/references si hay patrones nuevos

### Mensual
- Auditar notebooks (eliminar fuentes obsoletas)
- Consolidar lecciones en MEMORY.md
- Actualizar workflows si hay mejoras

---

## ✅ Checklist Pre-Trabajo

- [ ] ¿Busqué en memoria/docs existentes?
- [ ] ¿Consulté el notebook relevante?
- [ ] ¿Tengo al menos 5 fuentes para temas medios?
- [ ] ¿Entiendo el problema antes de solucionarlo?
- [ ] ¿Sé dónde documentaré lo que aprenda?

---

*Última actualización: [fecha]*
