#!/bin/bash
# ¡Script turbo para preparar el host Ubuntu y lanzar el clúster OKD! 🚀

set -e

echo "🔍 Verificando entorno WSL..."
echo "📝 Verificando /proc/version..."
cat /proc/version

# Verificar si estamos en WSL2
if grep -q "microsoft" /proc/version; then
    echo "✅ Detectado entorno WSL"
    echo "📝 Configurando entorno para WSL2..."
    
    # Verificar si estamos en WSL2 usando el kernel
    echo "🔍 Verificando versión del kernel..."
    uname -a
    
    if uname -a | grep -q "microsoft-standard-WSL2"; then
        echo "✅ WSL2 detectado"
        
        # Instalar dependencias necesarias
        echo "🔧 Instalando dependencias necesarias..."
        sudo apt-get update
        sudo apt-get install -y wget apt-transport-https gnupg2 software-properties-common

        # Agregar la clave GPG de HashiCorp
        wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null

        # Agregar el repositorio oficial de HashiCorp
        echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

        # Actualizar e instalar Vagrant
        sudo apt-get update
        sudo apt-get install -y vagrant ansible git curl

        # Verificar VirtualBox en Windows
        echo "🔍 Verificando VirtualBox en Windows..."
        if ! command -v VBoxManage &> /dev/null; then
            echo "❌ VirtualBox no encontrado en Windows. Por favor, instala VirtualBox en Windows:"
            echo "   1. Descarga VirtualBox desde https://www.virtualbox.org/wiki/Downloads"
            echo "   2. Instala VirtualBox en Windows (no en WSL)"
            echo "   3. Asegúrate de que VirtualBox esté en el PATH de Windows"
            exit 1
        fi

        # Configurar variables de entorno para Vagrant
        echo "⚙️  Configurando variables de entorno para Vagrant..."
        export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS=1
        export VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH=/mnt/c/Users/$USER
        
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

        # Verificar que podemos acceder a VirtualBox de Windows
        if ! VBoxManage --version &> /dev/null; then
            echo "❌ No se puede acceder a VirtualBox de Windows. Por favor, verifica que:"
            echo "   1. VirtualBox está instalado en Windows"
            echo "   2. Has reiniciado WSL después de instalar VirtualBox"
            echo "   3. Has configurado las variables de entorno en Windows:"
            echo "      [Environment]::SetEnvironmentVariable('VAGRANT_WSL_ENABLE_WINDOWS_ACCESS', '1', 'User')"
            exit 1
        fi

        # Verificar que cmd.exe está disponible
        if ! command -v cmd.exe &> /dev/null; then
            echo "❌ No se puede acceder a cmd.exe. Por favor, verifica que:"
            echo "   1. WSL2 está correctamente configurado"
            echo "   2. Has reiniciado WSL después de la instalación"
            echo "   3. Los enlaces simbólicos se crearon correctamente"
            exit 1
        fi

        echo "✅ Dependencias instaladas. Ejecutando Ansible Playbook..."
        cd "$(dirname "$0")/.."
        ansible-playbook -i "localhost," -c local ansible/playbook.yml

        echo "🎉 ¡Listo! El clúster OKD está en proceso de despliegue."
    else
        echo "❌ Este script requiere WSL2. Por favor, actualiza a WSL2."
        exit 1
    fi
else
    echo "❌ Este script debe ejecutarse en WSL2. Por favor, ejecuta el script desde WSL2."
    exit 1
fi