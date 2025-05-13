#!/bin/bash

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Iniciando prueba simple de Vagrant...${NC}"

# Crear directorio temporal en Windows si no existe
echo -e "${YELLOW}📁 Creando directorio temporal en Windows...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "if not exist C:\temp mkdir C:\temp"

# Crear archivo batch de prueba
echo -e "${YELLOW}📝 Creando archivo batch de prueba...${NC}"
cat > /mnt/c/temp/test-vagrant.bat << 'BATCH'
@echo off
echo ===== Información del Sistema =====
echo Directorio actual: %CD%
echo PATH: %PATH%
echo.

echo ===== Verificando cmd.exe =====
where cmd.exe
echo.

echo ===== Verificando Vagrant =====
where vagrant
echo.

echo ===== Versión de Vagrant =====
vagrant --version
echo.

echo ===== Verificando VirtualBox =====
where VBoxManage
echo.

echo ===== Versión de VirtualBox =====
VBoxManage --version
BATCH

# Ejecutar el batch
echo -e "${YELLOW}▶️ Ejecutando prueba...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "C:\temp\test-vagrant.bat"

# Verificar resultado
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Prueba completada exitosamente${NC}"
else
    echo -e "${RED}❌ La prueba falló${NC}"
fi
