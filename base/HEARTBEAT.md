# HEARTBEAT.md - Checklist Periódico

Este archivo define qué revisar en cada heartbeat (polling periódico).

## Instrucciones

Cuando recibas un heartbeat, ejecuta estas verificaciones en orden.
Si todo está OK, responde `HEARTBEAT_OK`.
Si algo necesita atención, responde con el detalle.

---

## Verificaciones

### 1. Health Check Básico
```bash
# Verificar que los servicios críticos responden
# Ejemplo: curl -s http://localhost:PORT/health
```

### 2. Alertas Pendientes
```bash
# Revisar si hay alertas/notificaciones pendientes
# Ejemplo: cat temp/alerts.jsonl
```

### 3. Tareas Programadas
```bash
# Verificar si hay tareas que debieron ejecutarse
# Ejemplo: revisar cron jobs fallidos
```

---

## Formato de Respuesta

**Si todo OK:**
```
HEARTBEAT_OK
```

**Si hay alertas:**
```
⚠️ [Descripción del problema]
[Acción tomada o recomendada]
```

---

## Notas

<!-- 
Agrega aquí verificaciones específicas de tu setup:

### Trading Alerts
- Revisar `/path/to/signals.json` por señales pendientes
- Si hay señales, enviar a Telegram grupo X

### Monitoreo de Servicios  
- curl http://localhost:8000/status
- Si no responde, alertar
-->

*[Personalizar según necesidades]*
