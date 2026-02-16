# OpenClaw en Contabo - Guía Específica

**Adaptación para VPS de Contabo**

> Actualizado: Febrero 2026 | Basado en [docs.openclaw.ai](https://docs.openclaw.ai)

---

## 🎯 Por qué Contabo

- Mejor relación precio/rendimiento
- 4 cores + 8GB RAM por ~$7/mes
- Ubicaciones en EU y US
- Ideal para OpenClaw + servicios adicionales

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

### 1.4 Crear usuario openclaw

```bash
# Crear usuario
adduser openclaw
usermod -aG sudo openclaw

# Crear directorio SSH
mkdir -p /home/openclaw/.ssh
```

### 1.5 Agregar tu clave SSH

Desde tu máquina local, obtén tu clave pública:
```bash
cat ~/.ssh/id_ed25519.pub
```

En el servidor Contabo:
```bash
# Pega tu clave pública
echo "TU_CLAVE_PUBLICA_COMPLETA" >> /home/openclaw/.ssh/authorized_keys
chown -R openclaw:openclaw /home/openclaw/.ssh
chmod 700 /home/openclaw/.ssh
chmod 600 /home/openclaw/.ssh/authorized_keys
```

### 1.6 Dar permisos sudo sin password

```bash
echo "openclaw ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/openclaw
```

> **⚠️ Sobre los Permisos**
> 
> Esto permite al agente administrar completamente el VPS (instalar software, gestionar servicios, configurar sistema). Es seguro porque el acceso SSH está limitado a Tailscale.
> 
> Ver explicación completa en `INSTALACION-COMPLETA.md`.

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
ssh openclaw@100.x.x.x
```

**⚠️ No cierres la sesión actual hasta verificar acceso por Tailscale.**

---

## PARTE 4: Instalar OpenClaw

### 4.1 Cambiar a usuario openclaw

```bash
su - openclaw
```

### 4.2 Instalar Node.js 22+

```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```

Verificar:
```bash
node -v  # Debe ser v22.x.x o superior
```

### 4.3 Instalar OpenClaw

```bash
npm install -g openclaw
```

### 4.4 Verificar y diagnosticar

```bash
openclaw --version
openclaw doctor
```

### 4.5 Configurar

```bash
openclaw setup
```

Responder:
- **Auth:** OAuth (Claude Pro) o API key
- **Channel:** Telegram (recomendado)

---

## PARTE 5: Aplicar Starter Kit

### 5.1 Obtener el kit

```bash
git clone https://github.com/hrikrdo/openclaw-starter-kit.git ~/starter-kit
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

### 6.1 Instalar servicio (automático)

```bash
openclaw gateway install
```

### 6.2 Habilitar persistencia

```bash
sudo loginctl enable-linger $USER
```

### 6.3 Verificar

```bash
openclaw gateway status
openclaw status
```

### 6.4 Aprobar usuario

```bash
# Envía mensaje al bot, luego:
openclaw pairing list --provider telegram
openclaw pairing approve --provider telegram <code>
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

### `openclaw: command not found`

```bash
# Verificar PATH
npm prefix -g
echo $PATH

# Arreglar
export PATH="$(npm prefix -g)/bin:$PATH"
# Agregar a ~/.bashrc
```

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
openclaw doctor
openclaw gateway status
openclaw logs --follow
```

---

## Comandos Rápidos

```bash
# Estado
openclaw status
openclaw gateway status

# Reiniciar
openclaw gateway restart

# Logs
openclaw logs --follow

# Diagnóstico
openclaw doctor
openclaw health

# Canales
openclaw channels status
```

---

## Recursos

- **Docs OpenClaw:** https://docs.openclaw.ai
- **GitHub:** https://github.com/openclaw/openclaw
- **Discord:** https://discord.com/invite/clawd

---

*Guía para Contabo | OpenClaw Starter Kit | Febrero 2026*
