# OpenClaw Starter Kit - Guía de Instalación Completa

**OpenClaw + Estructura de Trabajo + Conocimiento Base**

> Actualizado: Febrero 2026 | Basado en [docs.openclaw.ai](https://docs.openclaw.ai)

---

## 📋 Contenido

1. [Pre-requisitos](#pre-requisitos)
2. [Crear Servidor](#parte-1-crear-servidor)
3. [Configurar Servidor](#parte-2-configurar-servidor)
4. [Instalar Tailscale](#parte-3-instalar-tailscale)
5. [Asegurar SSH](#parte-4-asegurar-ssh)
6. [Instalar OpenClaw](#parte-5-instalar-openclaw)
7. [Aplicar Starter Kit](#parte-6-aplicar-starter-kit)
8. [Personalizar Agente](#parte-7-personalizar-agente)
9. [Ejecutar como Servicio](#parte-8-ejecutar-como-servicio)
10. [Troubleshooting](#troubleshooting)

---

## Pre-requisitos

- Cuenta en proveedor cloud (Hetzner, Contabo, DigitalOcean, etc.)
- Cuenta de Tailscale (gratis)
- Claude Pro ($20/mes) o API key de Anthropic
- Bot de Telegram (o Discord/WhatsApp/Signal)

**Requisitos del servidor:**
- Ubuntu 22.04 o 24.04
- Mínimo 2 vCPU, 4GB RAM (para browser automation)
- 20GB+ disco
- **Node.js 22+** (el instalador lo instala si falta)

**Costo aproximado:**
- VPS: ~$5-7/mes
- Claude Pro: $20/mes (o API con uso)

---

## PARTE 1: Crear Servidor

### 1.1 Crear servidor en tu proveedor

**Hetzner (recomendado para empezar):**
1. Ve a https://console.hetzner.cloud
2. Click "Add Server"
3. Configuración:
```
Location:     Nuremberg (nbg1) o tu preferencia
Image:        Ubuntu 24.04
Type:         CX22 (2 vCPU, 4GB RAM) - €4.50/mes
```

### 1.2 Generar clave SSH (si no tienes)

En tu terminal local:
```bash
ssh-keygen -t ed25519 -C "tu@email.com"
cat ~/.ssh/id_ed25519.pub
```

Agrega la clave pública al servidor durante la creación.

---

## PARTE 2: Configurar Servidor

### 2.1 Conectar por SSH

```bash
ssh root@TU_IP_PUBLICA
```

### 2.2 Actualizar sistema

```bash
apt update && apt upgrade -y
```

### 2.3 Crear usuario openclaw

```bash
# Crear usuario
adduser openclaw
usermod -aG sudo openclaw

# Configurar SSH para el usuario
mkdir -p /home/openclaw/.ssh
cp ~/.ssh/authorized_keys /home/openclaw/.ssh/
chown -R openclaw:openclaw /home/openclaw/.ssh
chmod 700 /home/openclaw/.ssh
chmod 600 /home/openclaw/.ssh/authorized_keys

# Sudo sin password (recomendado para administración completa)
echo "openclaw ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/openclaw
```

> **⚠️ Sobre los Permisos**
> 
> El comando `NOPASSWD: ALL` permite al agente administrar completamente el VPS sin pedir contraseña. Esto es **necesario** para que OpenClaw pueda:
> - Instalar y actualizar software (`apt install`)
> - Crear y gestionar servicios (`systemctl`)
> - Configurar firewall y red (`ufw`, `tailscale`)
> - Editar archivos del sistema (`/etc/...`)
> 
> **¿Es seguro?** Sí, porque:
> 1. El acceso SSH está limitado a Tailscale (red privada)
> 2. No se usa root directamente (mejor auditoría)
> 3. Solo tú tienes acceso a la red Tailscale
> 
> **Alternativa restrictiva:** Si prefieres limitar qué puede hacer el agente:
> ```bash
> # Solo comandos específicos
> echo "openclaw ALL=(ALL) NOPASSWD: /usr/bin/apt, /usr/bin/systemctl, /usr/sbin/ufw" > /etc/sudoers.d/openclaw
> ```

### 2.4 Cambiar al usuario openclaw

```bash
su - openclaw
```

---

## PARTE 3: Instalar Tailscale

Tailscale crea una red privada segura para acceder al servidor.

### 3.1 Instalar en el servidor

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
```

**Te dará una URL** - ábrela para autenticar con tu cuenta.

### 3.2 Obtener IP de Tailscale

```bash
tailscale ip -4
# Anota esta IP (100.x.x.x)
```

### 3.3 Instalar Tailscale en tu computadora

- **Mac:** `brew install --cask tailscale`
- **Windows:** https://tailscale.com/download
- **Linux:** Mismo comando que el servidor

**Usa la misma cuenta para autenticar.**

---

## PARTE 4: Asegurar SSH

### 4.1 Configurar SSH solo por Tailscale

```bash
TAILSCALE_IP=$(tailscale ip -4)

sudo tee /etc/ssh/sshd_config.d/tailscale-only.conf << EOF
ListenAddress $TAILSCALE_IP
ListenAddress 127.0.0.1
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
EOF
```

### 4.2 Reiniciar SSH

```bash
sudo systemctl restart sshd
```

### 4.3 Configurar Firewall

```bash
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0 to any port 22
sudo ufw allow in on tailscale0
sudo ufw --force enable
```

### 4.4 Verificar seguridad

```bash
# Solo debe mostrar IP de Tailscale
ss -tlnp | grep ":22"

# Debe fallar (IP pública cerrada)
nc -zv TU_IP_PUBLICA 22
```

**⚠️ No cierres la sesión actual hasta verificar que puedes conectar por Tailscale.**

---

## PARTE 5: Instalar OpenClaw

### 5.1 Instalar Node.js 22+

**Opción A: NodeSource (recomendado)**
```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**Opción B: nvm (si necesitas múltiples versiones)**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install 22
```

**Verificar:**
```bash
node -v  # Debe ser v22.x.x o superior
```

### 5.2 Instalar OpenClaw

```bash
npm install -g openclaw
```

### 5.3 Verificar instalación

```bash
openclaw --version
openclaw doctor  # Diagnóstico de problemas
```

### 5.4 Configurar OpenClaw

```bash
openclaw setup
```

El wizard te preguntará:
- **Auth:** OAuth (Claude Pro) o API key
- **Channel:** Telegram (recomendado para empezar)

### 5.5 Crear bot de Telegram

1. Abre Telegram y busca **@BotFather**
2. Envía `/newbot`
3. Sigue las instrucciones
4. Copia el **token** que te da
5. Pégalo cuando `openclaw setup` lo pida

---

## PARTE 6: Aplicar Starter Kit

### 6.1 Obtener el Starter Kit

```bash
git clone https://github.com/hrikrdo/openclaw-starter-kit.git ~/starter-kit
```

### 6.2 Ejecutar setup

```bash
cd ~/starter-kit
chmod +x scripts/setup-workspace.sh
./scripts/setup-workspace.sh
```

Esto copia la estructura de workspace a `~/.openclaw/workspace/`.

---

## PARTE 7: Personalizar Agente

### 7.1 Editar identidad

```bash
nano ~/.openclaw/workspace/IDENTITY.md
```

### 7.2 Editar personalidad

```bash
nano ~/.openclaw/workspace/SOUL.md
```

### 7.3 Editar info del usuario

```bash
nano ~/.openclaw/workspace/USER.md
```

---

## PARTE 8: Ejecutar como Servicio

### 8.1 Instalar servicio (automático)

```bash
openclaw gateway install
```

Esto crea y habilita el servicio systemd automáticamente.

### 8.2 Verificar estado

```bash
openclaw gateway status
openclaw status  # Vista general
```

### 8.3 Habilitar persistencia (Linux)

Para que el servicio siga corriendo después de logout:

```bash
sudo loginctl enable-linger $USER
```

### 8.4 Aprobar tu cuenta

Envía un mensaje al bot en Telegram, luego:

```bash
openclaw pairing list --provider telegram
openclaw pairing approve --provider telegram <code>
```

### 8.5 Comandos útiles

```bash
openclaw gateway status    # Estado del gateway
openclaw gateway restart   # Reiniciar
openclaw gateway stop      # Detener
openclaw logs --follow     # Ver logs en tiempo real
openclaw doctor            # Diagnóstico de problemas
openclaw health            # Verificar salud
```

---

## Troubleshooting

### `openclaw: command not found`

El directorio de npm global no está en PATH:
```bash
# Diagnosticar
npm prefix -g
echo $PATH

# Arreglar (agregar a ~/.bashrc)
export PATH="$(npm prefix -g)/bin:$PATH"
source ~/.bashrc
```

### No puedo conectar por SSH
- Verifica que Tailscale esté activo: `tailscale status`
- Usa la IP de Tailscale (100.x.x.x), no la pública

### OpenClaw no responde
```bash
openclaw doctor           # Diagnóstico
openclaw gateway status   # Estado del servicio
openclaw logs --follow    # Ver logs
```

### Errores de permisos en npm
```bash
mkdir -p "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
export PATH="$HOME/.npm-global/bin:$PATH"
# Agregar la línea anterior a ~/.bashrc
```

### Acceder al Gateway UI

```bash
# Desde tu máquina local, crear túnel SSH
ssh -L 18789:127.0.0.1:18789 openclaw@TU_IP_TAILSCALE

# Luego abrir en navegador
http://127.0.0.1:18789/
```

---

## Variables de Entorno (Avanzado)

Si necesitas rutas personalizadas:

| Variable | Uso |
|----------|-----|
| `OPENCLAW_HOME` | Directorio base interno |
| `OPENCLAW_STATE_DIR` | Ubicación de estado mutable |
| `OPENCLAW_CONFIG_PATH` | Ubicación del archivo de config |

Ver más: [Environment vars](https://docs.openclaw.ai/help/environment)

---

## Recursos

- **Docs oficiales:** https://docs.openclaw.ai
- **GitHub:** https://github.com/openclaw/openclaw
- **Discord:** https://discord.com/invite/clawd
- **Skills:** https://clawdhub.com

---

*OpenClaw Starter Kit | Actualizado Febrero 2026*
