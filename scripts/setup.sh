#!/bin/bash
# ¡Script turbo para preparar el host Ubuntu y lanzar el clúster OKD! 🚀

set -e

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Iniciando configuración del entorno OKD...${NC}"

echo "🔍 Verificando entorno WSL..."
echo "📝 Verificando /proc/version..."
cat /proc/version

# Verificar si estamos en WSL2
if ! grep -q "microsoft-standard-WSL2" /proc/version; then
    echo -e "${RED}❌ Este script debe ejecutarse en WSL2${NC}"
    exit 1
fi

echo -e "${GREEN}✅ WSL2 detectado correctamente${NC}"

# Verificar si VirtualBox está instalado en Windows
if ! /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe --version &>/dev/null; then
    echo -e "${RED}❌ VirtualBox no está instalado en Windows${NC}"
    echo -e "${YELLOW}📦 Por favor, instala VirtualBox desde: https://www.virtualbox.org/wiki/Downloads${NC}"
    exit 1
fi

# Configurar integración WSL2-Windows
echo -e "${GREEN}🔧 Configurando integración WSL2-Windows...${NC}"

# Crear directorio temporal en Windows
echo -e "${YELLOW}📁 Creando directorio temporal en Windows...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "if not exist C:\temp mkdir C:\temp"

# Crear script de configuración de Vagrant
echo -e "${YELLOW}📝 Creando script de configuración de Vagrant...${NC}"
cat > /mnt/c/temp/setup-vagrant.bat << 'BATCH'
@echo off
set PATH=%PATH%;C:\Program Files\Oracle\VirtualBox;C:\Program Files\Vagrant\bin;C:\Windows\System32

echo ===== Verificando componentes =====
echo 1. Verificando cmd.exe...
where cmd.exe
echo.

echo 2. Verificando Vagrant...
where vagrant
echo.

echo 3. Verificando VirtualBox...
where VBoxManage
echo.

echo ===== Instalando boxes necesarios =====
echo 1. Instalando box de Ubuntu 20.04...
vagrant box add generic/ubuntu2004 --provider virtualbox

echo.
echo 2. Verificando instalación...
vagrant box list
BATCH

# Ejecutar script de configuración
echo -e "${YELLOW}▶️ Ejecutando configuración de Vagrant...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "C:\temp\setup-vagrant.bat"

# Verificar Python y pip
echo -e "${GREEN}🔍 Verificando Python y pip...${NC}"
if ! command -v python3 &>/dev/null; then
    echo -e "${YELLOW}📦 Instalando Python3...${NC}"
    sudo apt update
    sudo apt install -y python3 python3-pip
fi

# Instalar Ansible
echo -e "${GREEN}📦 Instalando Ansible...${NC}"
sudo apt update
sudo apt install -y ansible

# Crear script wrapper para Vagrant
echo -e "${YELLOW}📝 Creando script wrapper para Vagrant...${NC}"
cat > /mnt/c/temp/run-vagrant.bat << 'BATCH'
@echo off
set PATH=%PATH%;C:\Program Files\Oracle\VirtualBox;C:\Program Files\Vagrant\bin;C:\Windows\System32
cd /d %~dp0
vagrant %*
BATCH

# Crear script shell para ejecutar Vagrant
cat > /mnt/c/temp/run-vagrant.sh << 'EOF'
#!/bin/bash
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH=/mnt/c/Users/$USER
/mnt/c/Windows/System32/cmd.exe /c "C:\temp\run-vagrant.bat" "$@"
EOF

chmod +x /mnt/c/temp/run-vagrant.sh

# Agregar alias para Vagrant
echo 'alias vagrant="/mnt/c/temp/run-vagrant.sh"' >> ~/.bashrc
source ~/.bashrc

# Verificar instalación
echo -e "${GREEN}✅ Verificando instalación...${NC}"
if command -v vagrant &>/dev/null; then
    echo -e "${GREEN}✅ Vagrant está configurado correctamente${NC}"
else
    echo -e "${RED}❌ Error en la configuración de Vagrant${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Configuración completada!${NC}"
echo -e "${YELLOW}📝 Recuerda reiniciar tu terminal o ejecutar: source ~/.bashrc${NC}"

# Verificar acceso a Windows
echo "🔍 Verificando acceso a Windows..."
if ! command -v cmd.exe &> /dev/null; then
    echo "❌ No se puede acceder a cmd.exe. Configurando acceso a Windows..."
    
    # Crear enlaces simbólicos para acceder a Windows
    if [ ! -f /usr/local/bin/cmd.exe ]; then
        echo "📝 Creando enlace simbólico para cmd.exe..."
        sudo ln -sf /mnt/c/Windows/System32/cmd.exe /usr/local/bin/cmd.exe
    fi
    
    if [ ! -f /usr/local/bin/powershell.exe ]; then
        echo "📝 Creando enlace simbólico para powershell.exe..."
        sudo ln -sf /mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe /usr/local/bin/powershell.exe
    fi
fi

echo "✅ Dependencias instaladas. Ejecutando Ansible Playbook..."
cd "$(dirname "$0")/.."
ansible-playbook -i "localhost," -c local ansible/playbook.yml

echo "🎉 ¡Listo! El clúster OKD está en proceso de despliegue."