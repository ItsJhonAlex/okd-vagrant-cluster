# Script para configurar y desplegar el clúster OKD desde Windows
Write-Host "[*] Iniciando configuracion del cluster OKD..." -ForegroundColor Cyan

# Verificar si VirtualBox está instalado
Write-Host "[*] Verificando VirtualBox..." -ForegroundColor Yellow
$virtualBoxPath = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
if (-not (Test-Path $virtualBoxPath)) {
    Write-Host "[!] VirtualBox no esta instalado. Por favor, instala VirtualBox desde https://www.virtualbox.org/wiki/Downloads" -ForegroundColor Red
    exit 1
} else {
    # Agregar VirtualBox al PATH temporalmente
    $env:Path += ";C:\Program Files\Oracle\VirtualBox"
    Write-Host "[+] VirtualBox encontrado en: $virtualBoxPath" -ForegroundColor Green
}

# Verificar si Vagrant está instalado
Write-Host "[*] Verificando Vagrant..." -ForegroundColor Yellow
if (-not (Get-Command "vagrant" -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Vagrant no esta instalado. Instalando Vagrant..." -ForegroundColor Yellow
    
    # Descargar e instalar Vagrant
    $vagrantUrl = "https://releases.hashicorp.com/vagrant/2.4.5/vagrant_2.4.5_windows_amd64.msi"
    $vagrantInstaller = "$env:TEMP\vagrant.msi"
    
    Write-Host "[*] Descargando Vagrant..." -ForegroundColor Yellow
    Invoke-WebRequest -Uri $vagrantUrl -OutFile $vagrantInstaller
    
    Write-Host "[*] Instalando Vagrant..." -ForegroundColor Yellow
    Start-Process msiexec.exe -ArgumentList "/i $vagrantInstaller /qn" -Wait
    
    # Limpiar el instalador
    Remove-Item $vagrantInstaller
}

# Verificar si Ansible está instalado
Write-Host "[*] Verificando Ansible..." -ForegroundColor Yellow
if (-not (Get-Command "ansible" -ErrorAction SilentlyContinue)) {
    Write-Host "[!] Ansible no esta instalado. Instalando Ansible..." -ForegroundColor Yellow
    
    # Instalar Ansible usando pip
    python -m pip install --user ansible
}

# Configurar variables de entorno
Write-Host "[*] Configurando variables de entorno..." -ForegroundColor Yellow
[Environment]::SetEnvironmentVariable("VAGRANT_WSL_ENABLE_WINDOWS_ACCESS", "1", "User")
[Environment]::SetEnvironmentVariable("VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH", $env:USERPROFILE, "User")

# Agregar VirtualBox al PATH permanentemente
Write-Host "[*] Agregando VirtualBox al PATH del sistema..." -ForegroundColor Yellow
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not $currentPath.Contains("C:\Program Files\Oracle\VirtualBox")) {
    [Environment]::SetEnvironmentVariable("Path", $currentPath + ";C:\Program Files\Oracle\VirtualBox", "User")
}

# Ejecutar el playbook de Ansible
Write-Host "[*] Ejecutando Ansible Playbook..." -ForegroundColor Cyan
Set-Location $PSScriptRoot\..
ansible-playbook -i "localhost," -c local ansible/playbook.yml

Write-Host "[+] Proceso completado!" -ForegroundColor Green 