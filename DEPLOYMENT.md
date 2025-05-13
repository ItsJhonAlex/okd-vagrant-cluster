# Guía de Despliegue del Clúster OKD 🚀

## 📋 Índice
1. [Requisitos Previos](#requisitos-previos)
2. [Preparación del Entorno](#preparación-del-entorno)
3. [Estructura del Proyecto](#estructura-del-proyecto)
4. [Proceso de Despliegue](#proceso-de-despliegue)
5. [Verificación del Clúster](#verificación-del-clúster)
6. [Monitoreo y Logging](#monitoreo-y-logging)
7. [Troubleshooting](#troubleshooting)

## 🛠️ Requisitos Previos

### Hardware Mínimo
- CPU: 4 cores
- RAM: 16GB
- Almacenamiento: 50GB SSD

### Software Requerido
- Windows 10/11 con WSL2
- Ubuntu 20.04 o superior en WSL2
- VirtualBox 6.1 o superior (instalado en Windows)
- Python 3.8 o superior
- Ansible 2.9 o superior
- Git

## 🔧 Preparación del Entorno

1. **Habilitar WSL2 en Windows:**
   ```powershell
   wsl --install
   wsl --set-default-version 2
   ```

2. **Instalar Ubuntu desde Microsoft Store**

3. **Instalar dependencias en WSL2:**
   ```bash
   sudo apt update
   sudo apt install -y python3-pip libvirt-daemon-system qemu-kvm
   ```

4. **Instalar Ansible:**
   ```bash
   sudo pip3 install ansible
   ```

## 📁 Estructura del Proyecto

```
okd-vagrant-cluster/
├── ansible/
│   ├── playbook.yml           # Playbook principal
│   └── roles/
│       ├── prepare-host/      # Preparación del host
│       ├── deploy-okd/        # Despliegue de OKD
│       └── monitoring-logging/ # Monitoreo y logging
├── scripts/
│   └── setup.sh              # Script para WSL2
└── Vagrantfile              # Configuración de VMs
```

## 🚀 Proceso de Despliegue

1. **Clonar el Repositorio:**
   ```bash
   git clone https://github.com/tuusuario/okd-vagrant-cluster.git
   cd okd-vagrant-cluster
   ```

2. **Ejecutar el Script de Configuración:**
   ```bash
   bash scripts/setup.sh
   ```

## ✅ Verificación del Clúster

```bash
# Acceder al clúster
vagrant ssh okd-master
oc login -u system:admin

# Verificar nodos
oc get nodes

# Verificar componentes
oc get pods --all-namespaces
```

## 📊 Monitoreo y Logging

### Prometheus
- Accesible en: `http://192.168.56.10:9090`
- Métricas recolectadas:
  - Uso de CPU
  - Uso de memoria
  - Estado de pods
  - Estado de nodos

### ELK Stack
- Elasticsearch: `http://192.168.56.10:9200`
- Kibana: `http://192.168.56.10:5601`
- Logstash: Puerto 5044

## 🔍 Troubleshooting

1. **Error de Virtualización**
   ```bash
   # Verificar virtualización
   systemctl status libvirtd
   ```

2. **Problemas de Red**
   ```bash
   # Verificar conectividad
   ping 192.168.56.10
   ```

3. **Problemas con OKD**
   ```bash
   # Verificar logs
   oc logs -n kube-system
   ```

4. **Problemas con WSL2**
   - Verificar que estás usando WSL2: `wsl --list --verbose`
   - Actualizar WSL2: `wsl --update`
   - Verificar acceso a Windows: `cmd.exe /c echo "Test"`

## 🔄 Mantenimiento

### Actualizaciones
1. Detener el clúster
2. Actualizar el código
3. Reconstruir el clúster

### Backup
- Realizar backup de configuraciones
- Exportar recursos importantes

## 📚 Recursos Adicionales

- [Documentación OKD](https://docs.okd.io/)
- [Guía de Vagrant](https://www.vagrantup.com/docs)
- [Documentación de Ansible](https://docs.ansible.com/)
- [WSL2](https://docs.microsoft.com/en-us/windows/wsl/)

## 🎯 Próximos Pasos

1. Implementar CI/CD
2. Agregar más nodos workers
3. Configurar alta disponibilidad
4. Implementar backup automático