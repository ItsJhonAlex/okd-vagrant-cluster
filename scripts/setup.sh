#!/bin/bash
# ¡Script turbo para preparar el host Ubuntu y lanzar el clúster OKD! 🚀

set -e

echo "🔧 Instalando dependencias necesarias..."
sudo apt-get update

# Instalar dependencias necesarias
sudo apt-get install -y wget apt-transport-https gnupg2

# Agregar la clave GPG de HashiCorp
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg >/dev/null

# Agregar el repositorio oficial de HashiCorp
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Actualizar e instalar Vagrant
sudo apt-get update
sudo apt-get install -y vagrant virtualbox ansible git curl

echo "✅ Dependencias instaladas. Ejecutando Ansible Playbook..."
cd "$(dirname "$0")/.."
ansible-playbook -i "localhost," -c local ansible/playbook.yml

echo "🎉 ¡Listo! El clúster OKD está en proceso de despliegue."