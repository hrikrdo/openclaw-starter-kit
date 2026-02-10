# OpenClaw Starter Kit - Guía de Instalación Completa

**OpenClaw + Estructura de Trabajo + Conocimiento Base**

Basado en la guía de [Velvet Shark](https://velvetshark.com/clawdbot-the-self-hosted-ai-that-siri-should-have-been).

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
9. [Ejecutar](#parte-8-ejecutar)
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

### 2.3 Crear usuario clawdbot

```bash
# Crear usuario
adduser clawdbot
usermod -aG sudo clawdbot

# Configurar SSH para el usuario
mkdir -p /home/clawdbot/.ssh
cp ~/.ssh/authorized_keys /home/clawdbot/.ssh/
chown -R clawdbot:clawdbot /home/clawdbot/.ssh
chmod 700 /home/clawdbot/.ssh
chmod 600 /home/clawdbot/.ssh/authorized_keys
```

### 2.4 Cambiar al usuario clawdbot

```bash
su - clawdbot
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

### 5.1 Instalar Node.js

```bash
# Instalar nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc

# Instalar Node 24
nvm install 24

# Habilitar pnpm
corepack enable pnpm
```

### 5.2 (Opcional) Instalar Homebrew

Necesario para algunos skills:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### 5.3 Clonar e instalar OpenClaw

```bash
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot
pnpm install
pnpm run build
pnpm run ui:install
```

### 5.4 Configurar OpenClaw

```bash
pnpm run clawdbot onboard
```

El wizard te preguntará:
- **Gateway:** local
- **Runtime:** Node (requerido para WhatsApp)
- **Auth:** OAuth (si tienes Claude Pro) o API key
- **Provider:** Telegram (recomendado)

### 5.5 Crear bot de Telegram

1. Abre Telegram y busca **@BotFather**
2. Envía `/newbot`
3. Sigue las instrucciones
4. Copia el **token** que te da

---

## PARTE 6: Aplicar Starter Kit

### 6.1 Obtener el Starter Kit

```bash
# Desde GitHub (ajusta la URL a tu repo)
git clone https://github.com/TU_USUARIO/openclaw-starter-kit.git ~/starter-kit

# O descargar ZIP
wget https://github.com/TU_USUARIO/openclaw-starter-kit/archive/main.zip
unzip main.zip && mv openclaw-starter-kit-main ~/starter-kit
```

### 6.2 Ejecutar setup

```bash
cd ~/starter-kit
chmod +x scripts/setup-workspace.sh
./scripts/setup-workspace.sh
```

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

## PARTE 8: Ejecutar

### 8.1 Verificar instalación

```bash
cd ~/clawdbot
pnpm run clawdbot daemon status
pnpm run clawdbot health
```

### 8.2 Aprobar tu cuenta

Envía un mensaje al bot en Telegram, luego:

```bash
pnpm run clawdbot pairing list --provider telegram
pnpm run clawdbot pairing approve --provider telegram <code>
```

### 8.3 Configurar como servicio

```bash
sudo tee /etc/systemd/system/clawdbot.service << 'EOF'
[Unit]
Description=OpenClaw Gateway
After=network.target

[Service]
Type=simple
User=clawdbot
WorkingDirectory=/home/clawdbot/clawdbot
ExecStart=/home/clawdbot/.nvm/versions/node/v24.0.0/bin/node node_modules/.bin/pnpm run gateway
Restart=always
RestartSec=10
Environment=PATH=/home/clawdbot/.nvm/versions/node/v24.0.0/bin:/usr/bin:/bin

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable clawdbot
sudo systemctl start clawdbot
```

### 8.4 Configurar limpieza automática

```bash
mkdir -p ~/logs
crontab -e
```

Agregar:
```
0 3 * * * /home/clawdbot/scripts/cleanup-temp.sh >> /home/clawdbot/logs/cleanup.log 2>&1
```

---

## Troubleshooting

### No puedo conectar por SSH
- Verifica que Tailscale esté activo: `tailscale status`
- Usa la IP de Tailscale (100.x.x.x), no la pública

### OpenClaw no responde
```bash
sudo systemctl status clawdbot
sudo journalctl -u clawdbot -f
```

### Ver logs
```bash
tail -f ~/.openclaw/logs/gateway.log
```

### Acceder al Gateway UI de forma segura
```bash
# Desde tu máquina local, crear túnel SSH
ssh -L 18789:127.0.0.1:18789 clawdbot@TU_IP_TAILSCALE

# Luego abrir en navegador
http://127.0.0.1:18789/
```

---

## Recursos

- **Docs oficiales:** https://docs.clawd.bot
- **GitHub:** https://github.com/clawdbot/clawdbot
- **Discord:** https://discord.com/invite/clawd
- **Skills:** https://clawdhub.com/skills
- **Guía original:** https://velvetshark.com/clawdbot-the-self-hosted-ai-that-siri-should-have-been

---

*OpenClaw Starter Kit | Basado en guía de Velvet Shark*
