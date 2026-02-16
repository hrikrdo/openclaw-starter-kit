# 🔐 Seguridad para Equipos Pequeños (2-5 personas)

Guía de configuración de seguridad para equipos con confianza alta.

---

## 📋 Modelo de Seguridad

```
┌─────────────────────────────────────────────────────────────┐
│                    INTERNET PÚBLICO                         │
│                                                             │
│   ❌ Todos los puertos CERRADOS                             │
│   ❌ SSH no accesible públicamente                          │
│   ❌ Dashboard no accesible públicamente                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ Solo acceso vía Tailscale
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              RED PRIVADA TAILSCALE                          │
│              (Solo dispositivos autorizados)                │
│                                                             │
│   👤 Admin (tú)                                             │
│      ├── SSH ✅                                             │
│      ├── Dashboard ✅                                       │
│      └── Telegram ✅                                        │
│                                                             │
│   👥 Miembros del equipo (2-5 personas)                    │
│      ├── SSH ✅ (opcional, según rol)                       │
│      ├── Dashboard ✅                                       │
│      └── Telegram ✅                                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
                           │
                           │ Interacción con el agente
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                      TELEGRAM                               │
│                                                             │
│   📱 Grupo del equipo                                       │
│      └── Todos interactúan con OpenClaw                    │
│      └── Contexto compartido (confianza alta)              │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## ✅ Checklist de Seguridad

### Servidor (VPS)

```
Configuración inicial:
- [ ] Usuario no-root creado (clawdbot)
- [ ] SSH keys configuradas (no passwords)
- [ ] Root login deshabilitado
- [ ] Password authentication deshabilitado

Red:
- [ ] Tailscale instalado y conectado
- [ ] SSH escucha SOLO en IP de Tailscale
- [ ] UFW activo con política "deny incoming"
- [ ] Puerto 22 público NO responde

Verificación:
- [ ] `nc -zv IP_PUBLICA 22` → Connection refused ✅
- [ ] `ss -tlnp | grep :22` → Solo 100.x.x.x ✅
```

### Tailscale

```
Configuración:
- [ ] Cuenta Tailscale creada
- [ ] VPS conectado a la red
- [ ] Dispositivos del equipo invitados

Miembros:
- [ ] Admin tiene acceso completo
- [ ] Miembros tienen Tailscale instalado
- [ ] Cada miembro autenticado en la red
```

### OpenClaw

```
Configuración:
- [ ] Bot de Telegram creado
- [ ] Token seguro (no compartido públicamente)
- [ ] Usuarios aprobados individualmente

Acceso:
- [ ] Cada miembro aprobado con `pairing approve`
- [ ] Grupo de Telegram creado para el equipo
- [ ] Secrets en ~/.openclaw/secrets/ (no en repos)
```

---

## 🔧 Configuración Paso a Paso

### 1. Configurar Tailscale para el Equipo

#### Admin: Invitar miembros

1. Ve a https://login.tailscale.com/admin/users
2. Click "Invite users"
3. Ingresa el email de cada miembro
4. Selecciona rol "Member"

#### Miembros: Unirse a la red

```bash
# Instalar Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Conectar (abrirá navegador para auth)
sudo tailscale up

# Verificar conexión
tailscale status
```

### 2. Verificar Acceso del Equipo

```bash
# Cada miembro debería poder:

# 1. Ver el VPS en su red
tailscale status | grep openclaw

# 2. Hacer ping al VPS
ping 100.x.x.x  # IP Tailscale del VPS

# 3. Acceder al dashboard (si está corriendo)
curl http://100.x.x.x:3001

# 4. SSH (si tienen key autorizada)
ssh clawdbot@100.x.x.x
```

### 3. Configurar Acceso a Telegram

#### Crear grupo del equipo

1. Crear grupo en Telegram
2. Agregar el bot de OpenClaw
3. Agregar a los miembros del equipo

#### Aprobar usuarios

```bash
# Ver solicitudes pendientes
openclaw pairing list --provider telegram

# Aprobar cada usuario
openclaw pairing approve --provider telegram CODIGO_USUARIO1
openclaw pairing approve --provider telegram CODIGO_USUARIO2
# ... repetir para cada miembro
```

### 4. Configurar SSH para Miembros (Opcional)

Si los miembros necesitan acceso SSH:

```bash
# En el VPS, agregar la clave pública de cada miembro
echo "ssh-ed25519 AAAA... miembro1@email.com" >> ~/.ssh/authorized_keys
echo "ssh-ed25519 AAAA... miembro2@email.com" >> ~/.ssh/authorized_keys
```

---

## 🚨 Comandos de Verificación

### Verificar seguridad del servidor

```bash
# 1. Puerto SSH público cerrado
nc -zv TU_IP_PUBLICA 22
# Esperado: Connection refused

# 2. SSH solo en Tailscale
ss -tlnp | grep ":22"
# Esperado: Solo 100.x.x.x:22

# 3. Firewall activo
sudo ufw status
# Esperado: Status: active, default deny incoming

# 4. Root login deshabilitado
grep "PermitRootLogin" /etc/ssh/sshd_config.d/*.conf
# Esperado: PermitRootLogin no

# 5. Password auth deshabilitado
grep "PasswordAuthentication" /etc/ssh/sshd_config.d/*.conf
# Esperado: PasswordAuthentication no
```

### Verificar Tailscale

```bash
# Ver dispositivos conectados
tailscale status

# Ver tu IP en la red
tailscale ip -4

# Verificar conectividad con otro dispositivo
tailscale ping nombre-dispositivo
```

---

## 👥 Gestión del Equipo

### Agregar nuevo miembro

```
1. Invitar en Tailscale (admin panel)
2. Miembro instala Tailscale y se autentica
3. Agregar al grupo de Telegram
4. Aprobar en OpenClaw: `pairing approve`
5. (Opcional) Agregar SSH key al servidor
```

### Remover miembro

```
1. Remover de Tailscale (admin panel)
2. Remover del grupo de Telegram
3. (Si tenía SSH) Remover key de ~/.ssh/authorized_keys
4. (Opcional) Revocar en OpenClaw si existe el comando
```

### Rotar credenciales (recomendado periódicamente)

```
1. Regenerar token del bot de Telegram
2. Actualizar en configuración de OpenClaw
3. Re-aprobar usuarios si es necesario
```

---

## ⚠️ Consideraciones para Equipos

### Contexto Compartido

En equipos pequeños con confianza alta:
- ✅ Todos ven el mismo historial
- ✅ La memoria es compartida
- ✅ Un miembro puede continuar donde otro dejó

**Implicación:** No usar para información sensible que no deba ver todo el equipo.

### Límites de Uso

- OpenClaw usa la API de Claude (tiene rate limits)
- Equipos grandes pueden alcanzar límites
- Monitorear uso con `/status`

### Backup de Configuración

```bash
# Respaldar configuración periódicamente
tar -czvf openclaw-backup-$(date +%Y%m%d).tar.gz \
  ~/.openclaw/config.yaml \
  ~/.openclaw/workspace/*.md \
  ~/.openclaw/secrets/
```

---

## 📝 Resumen

| Componente | Configuración |
|------------|---------------|
| **VPS** | SSH solo por Tailscale, UFW activo |
| **Tailscale** | Todos los miembros en la misma red |
| **Telegram** | Grupo compartido, usuarios aprobados |
| **Dashboard** | Accesible vía IP Tailscale |
| **Contexto** | Compartido entre todos (confianza alta) |

---

*Guía de seguridad para equipos | OpenClaw Starter Kit*
