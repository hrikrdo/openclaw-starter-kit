# 🐛 Error Handling Workflow

## Propósito
Proceso sistemático para manejar errores de forma que:
1. Se resuelvan efectivamente
2. Se documenten para no repetirlos
3. Se conviertan en conocimiento reutilizable

---

## 📋 Workflow de Error

### Paso 1: Identificar y Reproducir

```
1. ¿Cuál es el síntoma exacto?
2. ¿Cuándo ocurre? (siempre, a veces, bajo qué condiciones)
3. ¿Puedo reproducirlo consistentemente?
4. ¿Qué cambió recientemente que pudo causarlo?
```

### Paso 2: Investigar

```
1. ¿Ya resolví esto antes?
   → memory_search "error [síntoma]"
   → Revisar memory/projects/*-error-log.md

2. ¿Está documentado en mis fuentes?
   → Consultar notebook relevante
   → Revisar docs/references/

3. ¿Qué dice la documentación oficial?
   → web_search "[tecnología] [error message]"

4. ¿Hay issues similares reportados?
   → web_search "site:github.com [error]"
   → web_search "site:stackoverflow.com [error]"
```

### Paso 3: Resolver

```
1. Implementar la solución más probable
2. Verificar que resuelve el problema
3. Verificar que no causa efectos secundarios
4. Si no funciona, volver a Paso 2 con nueva info
```

### Paso 4: Documentar (OBLIGATORIO)

```bash
# En el error log del proyecto
edit memory/projects/proyecto-[X]-error-log.md
```

**Formato de documentación:**

```markdown
## [FECHA]: [Título descriptivo del error]

### Síntoma
[Qué se observó - ser específico]

### Causa Raíz  
[Por qué ocurrió - el verdadero origen]

### Solución
[Qué se hizo para arreglarlo - con código si aplica]

### Archivos Modificados
- [lista de archivos]

### Verificación
[Cómo confirmar que está arreglado]

### Lección Aprendida
> [Una frase que capture el aprendizaje clave]
```

### Paso 5: Escalar Conocimiento

```
Si el error es...

ESPECÍFICO del proyecto:
  → Solo en error-log del proyecto

APLICABLE a múltiples proyectos:
  → También en docs/references/[area]-best-practices.md

LECCIÓN FUNDAMENTAL importante:
  → También en MEMORY.md (resumen)
  → También en NotebookLM (detalle completo)
```

---

## 📁 Estructura de Error Logs

```
memory/projects/
├── proyecto-alpha-error-log.md
├── proyecto-beta-error-log.md
└── proyecto-gamma-error-log.md
```

### Template de Error Log

```markdown
# [Proyecto] - Error Log

## Propósito
Registro de errores resueltos para no repetirlos.

---

## [FECHA]: [Título]

### Síntoma
...

### Causa Raíz
...

### Solución
...

### Lección
> ...

---

## Template para Nuevos Errores

(copiar y completar arriba)
```

---

## 🚫 Anti-patrones a Evitar

| ❌ No hacer | ✅ Hacer en su lugar |
|------------|---------------------|
| Resolver y olvidar | Resolver y documentar |
| Documentar vagamente | Incluir código/comandos exactos |
| Solo el síntoma | Incluir causa raíz |
| Asumir que recordaré | Escribir como si fuera otro quien lea |

---

## ✅ Checklist Post-Error

- [ ] ¿El error está resuelto y verificado?
- [ ] ¿Documenté síntoma, causa, solución y lección?
- [ ] ¿Incluí código/comandos de verificación?
- [ ] ¿Escalé a docs/references si es aplicable globalmente?
- [ ] ¿Agregué a NotebookLM si es conocimiento valioso?

---

*"El mejor error es el que solo cometes una vez"*
