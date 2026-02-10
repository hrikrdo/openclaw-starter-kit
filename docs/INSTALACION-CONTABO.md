# OpenClaw en Contabo - Guía Específica

**Adaptación para VPS de Contabo**

Basado en la guía de [Velvet Shark](https://velvetshark.com/clawdbot-the-self-hosted-ai-that-siri-should-have-been).

---

## 🎯 Por qué Contabo

- Mejor relación precio/rendimiento que Hetzner
- 4 cores + 8GB RAM por ~$7/mes
- Ubicaciones en EU y US
- Ideal para OpenClaw + servicios adicionales (trading, dashboards, etc.)

---

## 📋 Diferencias vs Hetzner

| Aspecto | Hetzner | Contabo |
|---------|---------|---------|
| Acceso inicial | SSH con key | SSH con password |
| RAM mínima recomendada | 4GB | 8GB disponible barato |
| Setup inicial | Más limpio | Requiere limpiar password |

---

## PARTE 1: Configuración Inicial

### 1.1 Primer acceso

Contabo envía credenciales por email:

```bash
ssh root@TU_IP_CONTABO
# Usar password del email
```

### 1.2 Cambiar password de root

```bash
passwd
# Ingresa un password seguro nuevo
```

### 1.3 Actualizar sistema

```bash
apt update && apt upgrade -y
```

### 1.4 Crear usuario clawdbot

```bash
# Crear usuario con password deshabilitado
adduser clawdbot
usermod -aG sudo clawdbot

# Crear directorio SSH
mkdir -p /home/clawdbot/.ssh
```

### 1.5 Agregar tu clave SSH

Desde tu máquina local, obtén tu clave pública:
```bash
cat ~/.ssh/id_ed25519.pub
```

En el servidor Contabo:
```bash
# Pega tu clave pública
echo "TU_CLAVE_PUBLICA_COMPLETA" >> /home/clawdbot/.ssh/authorized_keys
chown -R clawdbot:clawdbot /home/clawdbot/.ssh
chmod 700 /home/clawdbot/.ssh
chmod 600 /home/clawdbot/.ssh/authorized_keys
```

### 1.6 Dar permisos sudo sin password

```bash
echo "clawdbot ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/clawdbot
```

---

## PARTE 2: Instalar Tailscale

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up
# Abre la URL para autenticar
```

Verificar IP:
```bash
tailscale ip -4
# Anota: 100.x.x.x
```

---

## PARTE 3: Asegurar SSH

### 3.1 Configurar SSH solo Tailscale

```bash
TAILSCALE_IP=$(tailscale ip -4)

sudo tee /etc/ssh/sshd_config.d/secure.conf << EOF
ListenAddress $TAILSCALE_IP
ListenAddress 127.0.0.1
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
EOF

sudo systemctl restart sshd
```

### 3.2 Configurar Firewall

```bash
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow in on tailscale0 to any port 22
sudo ufw allow in on tailscale0
sudo ufw --force enable
```

### 3.3 Verificar

```bash
# Debe mostrar solo IP de Tailscale
ss -tlnp | grep ":22"

# Probar conexión por Tailscale (desde tu Mac/PC)
ssh clawdbot@100.x.x.x
```

**⚠️ No cierres la sesión actual hasta verificar acceso por Tailscale.**

---

## PARTE 4: Instalar OpenClaw

### 4.1 Cambiar a usuario clawdbot

```bash
su - clawdbot
```

### 4.2 Instalar Node.js

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install 24
corepack enable pnpm
```

### 4.3 (Opcional) Instalar Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### 4.4 Clonar e instalar OpenClaw

```bash
git clone https://github.com/clawdbot/clawdbot.git
cd clawdbot
pnpm install
pnpm run build
pnpm run ui:install
```

### 4.5 Configurar

```bash
pnpm run clawdbot onboard
```

Responder:
- **Gateway:** local
- **Runtime:** Node
- **Auth:** OAuth o API key
- **Provider:** Telegram

---

## PARTE 5: Aplicar Starter Kit

### 5.1 Obtener el kit

```bash
# Desde GitHub
git clone https://github.com/TU_USUARIO/openclaw-starter-kit.git ~/starter-kit

# O copiar desde otro servidor por Tailscale
scp -r usuario@TU_IP_TAILSCALE:~/openclaw-starter-kit ~/starter-kit
```

### 5.2 Ejecutar setup

```bash
cd ~/starter-kit
chmod +x scripts/setup-workspace.sh
./scripts/setup-workspace.sh
```

### 5.3 Personalizar

```bash
nano ~/.openclaw/workspace/IDENTITY.md
nano ~/.openclaw/workspace/SOUL.md
nano ~/.openclaw/workspace/USER.md
```

---

## PARTE 6: Ejecutar como Servicio

### 6.1 Crear servicio

```bash
# Obtener ruta exacta de node
NODE_PATH=$(which node)
echo "Node path: $NODE_PATH"

sudo tee /etc/systemd/system/clawdbot.service << EOF
[Unit]
Description=OpenClaw Gateway
After=network.target

[Service]
Type=simple
User=clawdbot
WorkingDirectory=/home/clawdbot/clawdbot
ExecStart=$NODE_PATH node_modules/.bin/pnpm run gateway
Restart=always
RestartSec=10
Environment=PATH=$(dirname $NODE_PATH):/usr/bin:/bin

[Install]
WantedBy=multi-user.target
EOF
```

### 6.2 Iniciar

```bash
sudo systemctl daemon-reload
sudo systemctl enable clawdbot
sudo systemctl start clawdbot
sudo systemctl status clawdbot
```

### 6.3 Aprobar usuario

```bash
# Envía mensaje al bot, luego:
cd ~/clawdbot
pnpm run clawdbot pairing list --provider telegram
pnpm run clawdbot pairing approve --provider telegram <code>
```

---

## 🔧 Configuración Adicional Contabo

### Hostname descriptivo

```bash
sudo hostnamectl set-hostname mi-openclaw
```

### Timezone

```bash
sudo timedatectl set-timezone America/Panama  # O tu timezone
```

### Swap (si necesitas más RAM virtual)

```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

---

## 📊 Planes Contabo Recomendados

| Plan | Specs | Uso | Precio |
|------|-------|-----|--------|
| **Cloud VPS S** | 4 cores, 8GB | OpenClaw + extras | ~$7/mes |
| Cloud VPS M | 6 cores, 16GB | Múltiples servicios | ~$12/mes |

Para solo OpenClaw, el **VPS S** es más que suficiente.

---

## 🚨 Troubleshooting Contabo

### "Connection refused" después de asegurar SSH
```bash
# Verificar Tailscale
tailscale status

# Si necesitas acceso de emergencia, usa la consola VNC
# en el panel de Contabo
```

### Servidor lento
```bash
# Verificar uso
htop

# Contabo puede tener "noisy neighbors"
# Contacta soporte si persiste
```

### OpenClaw no inicia
```bash
sudo journalctl -u clawdbot -f
# Revisar errores
```

---

## Recursos

- **Docs OpenClaw:** https://docs.clawd.bot
- **GitHub:** https://github.com/clawdbot/clawdbot
- **Discord:** https://discord.com/invite/clawd
- **Guía Velvet Shark:** https://velvetshark.com/clawdbot-the-self-hosted-ai-that-siri-should-have-been

---

*Guía para Contabo | OpenClaw Starter Kit*
