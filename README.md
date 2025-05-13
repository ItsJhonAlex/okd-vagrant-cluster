# OKD Vagrant Cluster 🚀

Este repositorio automatiza el despliegue de un clúster OKD (la versión open source de OpenShift) usando Vagrant y Ansible. ¡Ideal para entornos de desarrollo, pruebas y aprendizaje! 🧙‍♂️

## 🛠️ Requisitos

- **Windows 10/11** con WSL2 habilitado.
- **VirtualBox** (última versión estable).
- **Vagrant** (última versión estable).
- **Ansible** (instalado en WSL2).
- **Git** (instalado en Windows).

## 🚀 Instalación

1. **Clona el repositorio:**
   ```bash
   git clone https://github.com/tuusuario/okd-vagrant-cluster.git
   cd okd-vagrant-cluster
   ```

2. **Ejecuta el script de configuración:**
   ```bash
   bash scripts/setup.sh
   ```

3. **¡Listo!** El clúster OKD se desplegará automáticamente. 🎉

## 🧩 Estructura del Proyecto

```
okd-vagrant-cluster/
├── README.md
├── ROADMAP.md
├── Vagrantfile
├── ansible/
│   ├── playbook.yml
│   ├── roles/
│   │   ├── prepare-host/
│   │   └── deploy-okd/
├── scripts/
│   └── setup.sh
```

## 🎯 Uso

- **Iniciar el clúster:**
  ```bash
  vagrant up
  ```

- **Detener el clúster:**
  ```bash
  vagrant halt
  ```

- **Destruir el clúster:**
  ```bash
  vagrant destroy
  ```

## 🧙‍♂️ Roles de Ansible

- **prepare-host:** Prepara el host Ubuntu para el despliegue.
- **deploy-okd:** Despliega el clúster OKD en las VMs.

## 🐛 Troubleshooting

- **Problemas con VirtualBox:** Asegúrate de que la virtualización esté habilitada en tu BIOS/UEFI.
- **Problemas con WSL2:** Ejecuta `wsl --update` para actualizar WSL2 a la última versión.

## 📚 Documentación

- [OKD](https://www.okd.io/)
- [Vagrant](https://www.vagrantup.com/docs)
- [Ansible](https://docs.ansible.com/)







