#!/bin/bash

# Colores para mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🚀 Iniciando instalación de boxes de Vagrant...${NC}"

# Crear directorio temporal en Windows
echo -e "${YELLOW}📁 Creando directorio temporal en Windows...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "if not exist C:\temp mkdir C:\temp"

# Crear script de instalación
echo -e "${YELLOW}📝 Creando script de instalación...${NC}"
cat > /mnt/c/temp/install-boxes.bat << 'BATCH'
@echo off
set PATH=%PATH%;C:\Program Files\Oracle\VirtualBox;C:\Program Files\Vagrant\bin;C:\Windows\System32

echo ===== Instalando boxes necesarios =====
echo 1. Instalando box de Ubuntu 20.04...
vagrant box add generic/ubuntu2004 --provider virtualbox

echo.
echo 2. Verificando instalación...
vagrant box list
BATCH

# Ejecutar script
echo -e "${YELLOW}▶️ Ejecutando instalación...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "C:\temp\install-boxes.bat"

# Verificar resultado
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Instalación completada exitosamente${NC}"
else
    echo -e "${RED}❌ La instalación falló${NC}"
fi

# Limpiar archivos temporales
echo -e "${YELLOW}🧹 Limpiando archivos temporales...${NC}"
/mnt/c/Windows/System32/cmd.exe /c "del C:\temp\install-boxes.bat" 