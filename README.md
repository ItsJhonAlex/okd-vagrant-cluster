# OKD Vagrant Cluster 🚀

Este repositorio automatiza el despliegue de un clúster OKD (la versión open source de OpenShift) usando Vagrant y Ansible. ¡Ideal para entornos de desarrollo, pruebas y aprendizaje! 🧙‍♂️

## 🛠️ Requisitos

### WSL2 (Ubuntu)
- **Windows 10/11** con WSL2 habilitado
- **Ubuntu 20.04 o superior** en WSL2
- **VirtualBox 7.1+** (instalado en Windows)
- **Vagrant 2.4+** (instalado en Windows)
- **Python 3.8+**
- **Ansible**
- **Git**

## 🚀 Instalación

1. **Habilitar WSL2 en Windows:**
   ```powershell
   wsl --install
   wsl --set-default-version 2
   ```

2. **Instalar Ubuntu desde Microsoft Store**

3. **Instalar VirtualBox y Vagrant en Windows:**
   - Descargar e instalar [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
   - Descargar e instalar [Vagrant](https://www.vagrantup.com/downloads)
   - Asegurarse de que ambos estén en el PATH del sistema

4. **Clona el repositorio en WSL2:**
   ```bash
   git clone https://github.com/tuusuario/okd-vagrant-cluster.git
   cd okd-vagrant-cluster
   ```

5. **Ejecuta el script de configuración:**
   ```bash
   chmod +x scripts/setup.sh
   ./scripts/setup.sh
   ```

   El script realizará:
   - Verificación del entorno WSL2
   - Configuración de la integración WSL2-Windows
   - Instalación y verificación de Vagrant y VirtualBox
   - Instalación del box de Ubuntu 20.04
   - Configuración de scripts wrapper para Vagrant
   - Instalación de Ansible y ejecución del playbook

## 🧩 Estructura del Proyecto

```
okd-vagrant-cluster/
├── README.md
├── ROADMAP.md
├── DEPLOYMENT.md
├── Vagrantfile
├── ansible/
│   ├── playbook.yml
│   ├── roles/
│   │   ├── prepare-host/
│   │   ├── deploy-okd/
│   │   └── monitoring-logging/
└── scripts/
    ├── setup.sh              # Script principal de configuración
    └── test/                 # Scripts de prueba
        ├── simple-test-vagrant.sh
        ├── test-vagrant.sh
        └── install-boxes.sh
```

## 🎯 Uso

```bash
# Iniciar el clúster
vagrant up

# Detener el clúster
vagrant halt

# Destruir el clúster
vagrant destroy
```

## 🧙‍♂️ Roles de Ansible

- **prepare-host:** Prepara el host para el despliegue
- **deploy-okd:** Despliega el clúster OKD en las VMs
- **monitoring-logging:** Configura Prometheus y ELK Stack

## 🐛 Troubleshooting

### WSL2
- **Problemas con WSL2:** 
  - Ejecuta `wsl --update` para actualizar WSL2
  - Verifica que estés usando WSL2 con `wsl --list --verbose`
  - Verifica el acceso a Windows con `cmd.exe /c echo "Test"`

### Vagrant
- **Problemas con Vagrant:**
  - Verifica la instalación con `vagrant --version`
  - Comprueba los boxes instalados con `vagrant box list`
  - Revisa los plugins con `vagrant plugin list`

### VirtualBox
- **Problemas con VirtualBox:** 
  - Asegúrate de que VirtualBox esté instalado en Windows (no en WSL2)
  - Verifica que la virtualización esté habilitada en tu BIOS/UEFI
  - Asegúrate de que VirtualBox esté en el PATH de Windows

## 📚 Documentación

- [OKD](https://www.okd.io/)
- [Vagrant](https://www.vagrantup.com/docs)
- [Ansible](https://docs.ansible.com/)
- [WSL2](https://docs.microsoft.com/en-us/windows/wsl/)







