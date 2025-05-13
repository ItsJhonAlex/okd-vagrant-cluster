#!/bin/bash

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Iniciando prueba completa de Vagrant...${NC}"

# Verificar entorno WSL2
echo -e "${YELLOW}🔍 Verificando entorno WSL2...${NC}"
if ! grep -q "microsoft-standard-WSL2" /proc/version; then
    echo -e "${RED}❌ Este script debe ejecutarse en WSL2${NC}"
    exit 1
fi
echo -e "${GREEN}✅ WSL2 detectado correctamente${NC}"

# Crear directorio temporal en Windows
echo -e "${YELLOW}📁 Creando directorio temporal en Windows...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "if not exist C:\temp mkdir C:\temp"

# Crear script de configuración de entorno
echo -e "${YELLOW}📝 Creando script de configuración...${NC}"
cat > /mnt/c/temp/setup-env.bat << 'BATCH'
@echo off
echo ===== Configurando entorno =====
set PATH=%PATH%;C:\Program Files\Oracle\VirtualBox;C:\Program Files\Vagrant\bin;C:\Windows\System32
echo PATH actualizado: %PATH%
echo.

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

echo ===== Versiones =====
echo Vagrant:
vagrant --version
echo.

echo VirtualBox:
VBoxManage --version
echo.

echo ===== Variables de entorno =====
echo VAGRANT_WSL_ENABLE_WINDOWS_ACCESS: %VAGRANT_WSL_ENABLE_WINDOWS_ACCESS%
echo VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH: %VAGRANT_WSL_WINDOWS_ACCESS_USER_HOME_PATH%
BATCH

# Crear script de prueba de Vagrant
echo -e "${YELLOW}📝 Creando script de prueba de Vagrant...${NC}"
cat > /mnt/c/temp/test-vagrant.bat << 'BATCH'
@echo off
echo ===== Probando Vagrant =====
echo 1. Verificando estado de Vagrant...
vagrant status
echo.

echo 2. Verificando versiones de boxes disponibles...
vagrant box list
echo.

echo 3. Verificando plugins de Vagrant...
vagrant plugin list
BATCH

# Ejecutar scripts
echo -e "${YELLOW}▶️ Ejecutando configuración...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "C:\temp\setup-env.bat"

echo -e "${YELLOW}▶️ Ejecutando prueba de Vagrant...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "C:\temp\test-vagrant.bat"

# Verificar resultado
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Prueba completada exitosamente${NC}"
else
    echo -e "${RED}❌ La prueba falló${NC}"
fi

# Limpiar archivos temporales
echo -e "${YELLOW}🧹 Limpiando archivos temporales...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "del C:\temp\setup-env.bat C:\temp\test-vagrant.bat"
