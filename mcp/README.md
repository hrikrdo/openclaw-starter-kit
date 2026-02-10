# 🔌 MCP Servers - Configuración

Los MCP (Model Context Protocol) servers extienden las capacidades del agente.

## MCPs Recomendados

| MCP | Propósito | Prioridad |
|-----|-----------|-----------|
| **NotebookLM** | Base de conocimiento, investigación | ⭐⭐⭐ Alta |
| **Google Stitch** | Generación de UI/diseño | ⭐⭐ Media |

---

## 📚 NotebookLM MCP

### Qué es
Permite al agente crear, consultar y actualizar notebooks en Google NotebookLM para mantener una base de conocimiento persistente.

### Instalación Rápida

```bash
# 1. Instalar el servidor
pip install -U notebooklm-mcp-server

# 2. Autenticar con Google
notebooklm-mcp-auth
# Abrirá navegador para OAuth

# 3. Verificar herramientas (debe mostrar ≥32)
mcporter tools notebooklm

# 4. Prueba
mcporter call notebooklm.notebook_list
```

### 📖 Guía Completa

Para instalación paso a paso con troubleshooting:
→ **[NOTEBOOKLM-INSTALACION.md](./NOTEBOOKLM-INSTALACION.md)**

### Herramientas Disponibles

```bash
# Listar herramientas
mcporter tools notebooklm
```

Principales:
- `notebook_create` - Crear notebook
- `notebook_query` - Consultar notebook
- `notebook_add_url` - Agregar URL como fuente
- `notebook_add_text` - Agregar texto como fuente
- `notebook_list` - Listar notebooks
- `audio_overview_create` - Crear resumen de audio

### Uso en el Agente

```bash
# Crear notebook
mcporter call notebooklm.notebook_create \
  title="Mi Base de Conocimiento"

# Agregar fuente (URL)
mcporter call notebooklm.notebook_add_url \
  notebook_id="abc123" \
  url="https://docs.example.com/guide"

# Consultar
mcporter call notebooklm.notebook_query \
  notebook_id="abc123" \
  query="¿Cómo resolver X problema?"
```

### Mejores Prácticas

1. **Un notebook por área/dominio**, no por proyecto
2. **Agregar fuentes de calidad**: docs oficiales, artículos de expertos
3. **Documentar errores** como fuentes de texto
4. **Consultar antes de codificar**

---

## 🎨 Google Stitch MCP (Opcional)

### Qué es
Permite generar interfaces de usuario desde descripciones de texto.

### Instalación

```bash
mcporter add stitch
mcporter auth stitch
```

### Herramientas Disponibles
- `create_project` - Crear proyecto
- `generate_screen_from_text` - Generar UI desde texto
- `list_projects` - Listar proyectos
- `get_screen` - Obtener pantalla generada

---

## 🔧 Comandos Útiles

```bash
# Ver MCPs configurados
mcporter list

# Ver herramientas de un MCP
mcporter tools [nombre]

# Probar herramienta
mcporter call [mcp].[herramienta] arg1="valor1"

# Re-autenticar
mcporter auth [nombre]
```

---

## 📝 Agregar al TOOLS.md

Después de configurar MCPs, documenta en `TOOLS.md`:

```markdown
### MCP Servers
- **NotebookLM**: `mcporter call notebooklm.<tool>` - 32 herramientas
- **Google Stitch**: `mcporter call stitch.<tool>` - 6 herramientas
```

---

*Última actualización: 2026-02-10*
