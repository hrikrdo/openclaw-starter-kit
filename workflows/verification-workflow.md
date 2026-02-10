# ✅ Verification Workflow

## Regla de Oro

> **NUNCA reportar "listo" sin verificar que funciona**

---

## 📋 Checklist Universal

### Después de CUALQUIER cambio:

```
1. ¿El cambio se aplicó?
   □ Archivo guardado correctamente
   □ Servicio reiniciado si necesario
   □ Build/compile exitoso

2. ¿Funciona como esperado?
   □ Probé el caso principal
   □ Probé edge cases relevantes
   □ La funcionalidad anterior sigue funcionando

3. ¿Verifiqué de forma independiente?
   □ No confié solo en mi cambio
   □ Usé curl/browser/logs para confirmar
   □ El usuario puede verificar también
```

---

## 🔧 Verificaciones por Tipo

### Cambios en Código Backend

```bash
# 1. Verificar que el servicio está corriendo
ps aux | grep [servicio]
systemctl status [servicio]

# 2. Verificar que responde
curl -s http://localhost:[port]/health
curl -s http://localhost:[port]/[endpoint]

# 3. Verificar logs por errores
tail -20 /var/log/[servicio].log
journalctl -u [servicio] -n 20
```

### Cambios en Código Frontend

```bash
# 1. Limpiar caché y rebuild
rm -rf .next && npm run build

# 2. Verificar que el build terminó sin errores
echo $?  # Debe ser 0

# 3. Verificar que los assets existen
ls -la .next/static/css/
ls -la .next/static/chunks/

# 4. Verificar que el servidor responde
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000

# 5. Verificar cambio específico en CSS (si aplica)
grep "[mi-clase]" .next/static/css/*.css
```

### Cambios en Configuración

```bash
# 1. Validar sintaxis
[comando-de-validacion] /path/to/config

# 2. Backup antes de aplicar
cp /path/to/config /path/to/config.bak

# 3. Aplicar y verificar
systemctl restart [servicio]
systemctl status [servicio]

# 4. Probar funcionalidad
[comando-de-prueba]
```

### Cambios en Base de Datos

```bash
# 1. Verificar conexión
psql -c "SELECT 1" || echo "No conecta"

# 2. Verificar que el cambio existe
psql -c "SELECT * FROM [tabla] LIMIT 5"

# 3. Verificar integridad
psql -c "SELECT COUNT(*) FROM [tabla]"
```

### Cambios en Archivos de Sistema (workspace)

```bash
# 1. Verificar que el archivo existe
ls -la /path/to/file

# 2. Verificar contenido
head -20 /path/to/file
grep "[texto-clave]" /path/to/file

# 3. Verificar permisos si relevante
stat /path/to/file
```

---

## 🚨 Señales de Alerta

**Parar y revisar si:**
- El build tiene warnings (aunque no errores)
- El servicio tarda mucho en iniciar
- Los logs muestran excepciones/errores
- El comportamiento es diferente al esperado
- "Funcionaba antes y ahora no"

---

## 📝 Formato de Reporte

**Al reportar que algo está listo:**

```
✅ [Descripción del cambio]

Verificaciones:
- [x] Build exitoso
- [x] Servicio respondiendo
- [x] Funcionalidad probada: [descripción]

Cómo verificar tú mismo:
[instrucciones para el usuario]
```

---

## ❌ Ejemplos de Malas Prácticas

| Malo | Por qué | Mejor |
|------|---------|-------|
| "Ya está, edité el archivo" | No verificaste que funciona | "Edité X, reinicié Y, probé con Z y funciona" |
| "El build pasó" | Build puede pasar pero la app fallar | "Build pasó y la página carga correctamente" |
| "Debería funcionar" | Asunción, no verificación | "Probé con curl y devuelve 200" |

---

*La confianza se gana con verificaciones, no con suposiciones.*
