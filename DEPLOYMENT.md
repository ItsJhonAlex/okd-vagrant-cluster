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
- VirtualBox 6.1 o superior
- Vagrant 2.2 o superior
- Ansible 2.9 o superior
- Git

## 🔧 Preparación del Entorno

1. **Habilitar WSL2 en Windows:**
   ```powershell
   wsl --install
   wsl --set-default-version 2
   ```

2. **Instalar dependencias en WSL2:**
   ```bash
   sudo apt update
   sudo apt install -y python3-pip libvirt-daemon-system qemu-kvm
   ```

3. **Instalar Ansible:**
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
│   └── setup.sh              # Script de configuración inicial
└── Vagrantfile              # Configuración de VMs
```

## 🚀 Proceso de Despliegue

### 1. Clonar el Repositorio
```bash
git clone https://github.com/tuusuario/okd-vagrant-cluster.git
cd okd-vagrant-cluster
```

### 2. Ejecutar el Script de Configuración
```bash
bash scripts/setup.sh
```

### 3. Verificar la Configuración
El script realizará las siguientes verificaciones:
- Conexión SSH a los nodos
- Ping entre nodos
- Puertos HTTP/HTTPS
- Servicios systemd

### 4. Despliegue Automático
El proceso de despliegue incluye:
1. Creación de VMs con Vagrant
2. Configuración de red
3. Instalación de OKD
4. Configuración de recursos
5. Configuración de almacenamiento

## ✅ Verificación del Clúster

### 1. Acceder al Clúster
```bash
vagrant ssh okd-master
oc login -u system:admin
```

### 2. Verificar Nodos
```bash
oc get nodes
```

### 3. Verificar Componentes
```bash
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

### Problemas Comunes

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

### Comandos Útiles

```bash
# Reiniciar el clúster
vagrant reload

# Limpiar y reconstruir
vagrant destroy -f
vagrant up

# Ver logs de Vagrant
vagrant status
vagrant ssh-config
```

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

## 🎯 Próximos Pasos

1. Implementar CI/CD
2. Agregar más nodos workers
3. Configurar alta disponibilidad
4. Implementar backup automático