#!/bin/bash
# ¡Script turbo para preparar el host Ubuntu y lanzar el clúster OKD! 🚀

set -e

echo "🔍 Verificando entorno WSL..."
if [ -f /proc/version ] && grep -q Microsoft /proc/version; then
    echo "⚠️  Detectado entorno WSL"
    echo "📝 Configurando entorno para WSL2..."
    
    # Verificar si estamos en WSL2
    if [ "$(uname -r | grep -o 'microsoft')" = "microsoft" ]; then
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
        
        # Verificar que podemos acceder a VirtualBox de Windows
        if ! VBoxManage --version &> /dev/null; then
            echo "❌ No se puede acceder a VirtualBox de Windows. Por favor, verifica que:"
            echo "   1. VirtualBox está instalado en Windows"
            echo "   2. Has reiniciado WSL después de instalar VirtualBox"
            echo "   3. Has configurado las variables de entorno en Windows:"
            echo "      [Environment]::SetEnvironmentVariable('VAGRANT_WSL_ENABLE_WINDOWS_ACCESS', '1', 'User')"
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