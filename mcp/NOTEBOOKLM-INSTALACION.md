# 📚 NotebookLM MCP - Guía de Instalación Completa

**Objetivo:** Instalar y dejar operativo el MCP server de NotebookLM con ≥32 herramientas disponibles.

---

## 📋 Criterios de Éxito

- [ ] MCP visible y conectado
- [ ] ≥32 herramientas disponibles
- [ ] Incluye herramienta para crear notebooks
- [ ] Autenticación completada sin errores
- [ ] Prueba: listado de notebooks OK

---

## Paso 1: Diagnóstico del Entorno

```bash
# Detectar sistema operativo
uname -a

# Verificar versión de Python
python3 --version

# Verificar si hay entorno virtual activo
echo $VIRTUAL_ENV

# Verificar si uv está disponible
which uv || echo "uv no disponible"
```

---

## Paso 2: Instalación del Servidor MCP

### Opción A: Con uv (preferido si disponible)

```bash
uv pip install -U notebooklm-mcp-server
```

### Opción B: Con pip

```bash
python3 -m pip install -U notebooklm-mcp-server
```

### Verificar instalación

```bash
# Confirmar versión instalada
pip show notebooklm-mcp-server

# Verificar que el comando está disponible
which notebooklm-mcp-auth
```

---

## Paso 3: Registro del MCP en Configuración

### 3.1 Localizar archivo de configuración

Para **OpenClaw/mcporter**:
```bash
ls -la ~/.config/mcporter/config.yaml
```

Para **Claude Desktop / Antigravity**:
```bash
# macOS
ls -la ~/Library/Application\ Support/Claude/claude_desktop_config.json

# Linux
ls -la ~/.config/claude/claude_desktop_config.json
```

### 3.2 Hacer backup

```bash
# Para mcporter
cp ~/.config/mcporter/config.yaml ~/.config/mcporter/config.yaml.bak

# Para Claude Desktop (macOS)
cp ~/Library/Application\ Support/Claude/claude_desktop_config.json \
   ~/Library/Application\ Support/Claude/claude_desktop_config.json.bak
```

### 3.3 Agregar configuración

**Para mcporter (config.yaml):**

```yaml
servers:
  notebooklm:
    command: notebooklm-mcp-server
    args: []
    env: {}
```

**Para Claude Desktop (JSON):**

```json
{
  "mcpServers": {
    "notebooklm": {
      "command": "notebooklm-mcp-server",
      "args": []
    }
  }
}
```

### 3.4 Validar sintaxis

```bash
# Para YAML
python3 -c "import yaml; yaml.safe_load(open('~/.config/mcporter/config.yaml'))"

# Para JSON
python3 -c "import json; json.load(open('path/to/config.json'))"
```

---

## Paso 4: Autenticación

### 4.1 Ejecutar autenticación

```bash
notebooklm-mcp-auth
```

### 4.2 Proceso en navegador

1. Se abrirá automáticamente el navegador
2. Inicia sesión con tu cuenta de Google
3. Autoriza los permisos solicitados
4. Espera confirmación "Authentication successful"

### 4.3 Verificar credenciales guardadas

```bash
# Verificar que existe el archivo de credenciales (sin mostrar contenido)
ls -la ~/.notebooklm-mcp/
# O
ls -la ~/.config/notebooklm-mcp/
```

**⚠️ IMPORTANTE:** No mostrar ni compartir el contenido de las credenciales.

---

## Paso 5: Arranque y Verificación

### 5.1 Iniciar servidor (para prueba manual)

```bash
notebooklm-mcp-server
```

### 5.2 Verificar en mcporter

```bash
# Listar servidores configurados
mcporter list

# Ver estado
mcporter status notebooklm
```

---

## Paso 6: Validación de Herramientas

### 6.1 Listar herramientas

```bash
mcporter tools notebooklm
```

### 6.2 Verificar cantidad

```bash
mcporter tools notebooklm | wc -l
# Debe ser ≥32
```

### 6.3 Herramientas principales

| Herramienta | Propósito |
|-------------|-----------|
| `notebook_create` | Crear nuevo notebook |
| `notebook_list` | Listar notebooks existentes |
| `notebook_query` | Consultar/preguntar al notebook |
| `notebook_add_url` | Agregar URL como fuente |
| `notebook_add_text` | Agregar texto como fuente |
| `notebook_delete` | Eliminar notebook |
| `source_list` | Listar fuentes de un notebook |
| `source_delete` | Eliminar fuente |
| `audio_overview_create` | Crear resumen de audio |
| `research_start` | Iniciar investigación |

---

## Paso 7: Prueba Funcional

### 7.1 Listar notebooks existentes

```bash
mcporter call notebooklm.notebook_list
```

### 7.2 Crear notebook de prueba

```bash
mcporter call notebooklm.notebook_create \
  title="Test Notebook"
```

### 7.3 Resultado esperado

```json
{
  "notebook_id": "abc123...",
  "title": "Test Notebook",
  "created": "2026-02-10T..."
}
```

---

## ✅ Confirmación Final

Si todos los pasos fueron exitosos:

```
✅ INSTALACIÓN OPERATIVA

- MCP: notebooklm
- Herramientas: 32+
- Autenticación: OK
- Prueba: Listado de notebooks exitoso
```

---

## 🚨 Troubleshooting

### "Command not found: notebooklm-mcp-server"

```bash
# Verificar PATH
echo $PATH

# Instalar de nuevo
pip install -U notebooklm-mcp-server

# Usar ruta completa
$(python3 -c "import site; print(site.USER_BASE)")/bin/notebooklm-mcp-server
```

### "Authentication failed"

```bash
# Limpiar credenciales y reintentar
rm -rf ~/.notebooklm-mcp/
notebooklm-mcp-auth
```

### "No tools available"

```bash
# Verificar que el servidor está corriendo
ps aux | grep notebooklm

# Reiniciar mcporter
mcporter restart notebooklm
```

### Error de permisos en Google

- Verifica que usas la cuenta de Google correcta
- Puede requerir que habilites "Less secure apps" o uses App Passwords
- Intenta en modo incógnito si hay problemas de caché

---

## 📝 Resumen de Comandos

```bash
# Instalación
pip install -U notebooklm-mcp-server

# Autenticación
notebooklm-mcp-auth

# Verificar herramientas
mcporter tools notebooklm

# Prueba
mcporter call notebooklm.notebook_list
```

---

*Guía de instalación NotebookLM MCP | OpenClaw Starter Kit*
