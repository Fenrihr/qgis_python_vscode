#!/bin/bash

# Script para configurar entorno VSCode para PyQGIS en Linux usando Conda
# Similar a setup_qgis_vscode_win.py pero para Linux

set -e  # Salir si hay algún error

# Emojis para mensajes
CAT_OK="😺"
CAT_FAIL="😿"
CAT_WORK="🐾"

# Variables
WORKSPACE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_NAME="qgis_env"
ENV_PATH="${WORKSPACE_DIR}/${ENV_NAME}"
QGIS_VERSION="3.44.6"
PYTHON_VERSION="3.12"

# ---------------------------------------------------------
# 1. Detectar instalación de Conda
# ---------------------------------------------------------
detect_conda() {
    echo -e "\n${CAT_WORK} Detectando instalación de Conda..."
    
    if command -v conda &> /dev/null; then
        CONDA_EXE=$(which conda)
        echo -e "${CAT_OK} Conda encontrado en: ${CONDA_EXE}"
        return 0
    else
        echo -e "${CAT_FAIL} No se encontró Conda en el sistema."
        echo "Por favor instala Miniconda o Anaconda:"
        echo "  https://docs.conda.io/en/latest/miniconda.html"
        exit 1
    fi
}

# ---------------------------------------------------------
# 2. Verificar o crear entorno QGIS
# ---------------------------------------------------------
check_or_create_env() {
    echo -e "\n${CAT_WORK} Verificando entorno QGIS..."
    
    if [ -d "${ENV_PATH}" ]; then
        echo -e "${CAT_OK} Entorno encontrado en: ${ENV_PATH}"
        read -p "¿Deseas recrear el entorno? (s/N): " recreate
        if [[ $recreate =~ ^[Ss]$ ]]; then
            echo -e "${CAT_WORK} Eliminando entorno existente..."
            conda remove --prefix "${ENV_PATH}" --all -y
            create_env
        fi
    else
        echo -e "${CAT_WORK} No se encontró entorno QGIS en ${ENV_PATH}"
        read -p "¿Deseas crear un nuevo entorno con QGIS ${QGIS_VERSION}? (S/n): " create
        if [[ ! $create =~ ^[Nn]$ ]]; then
            create_env
        else
            echo -e "${CAT_FAIL} Se necesita un entorno QGIS para continuar."
            exit 1
        fi
    fi
}

create_env() {
    echo -e "\n${CAT_WORK} Creando entorno Conda con QGIS ${QGIS_VERSION}..."
    echo "Esto puede tardar varios minutos..."
    
    conda create --prefix "${ENV_PATH}" \
        qgis="${QGIS_VERSION}" \
        python="${PYTHON_VERSION}" \
        -c conda-forge -y
    
    if [ $? -eq 0 ]; then
        echo -e "${CAT_OK} Entorno creado exitosamente"
    else
        echo -e "${CAT_FAIL} Error al crear el entorno"
        exit 1
    fi
}

# ---------------------------------------------------------
# 3. Crear archivo .env
# ---------------------------------------------------------
create_env_file() {
    ENV_FILE="${WORKSPACE_DIR}/.env"
    
    if [ -f "${ENV_FILE}" ]; then
        echo -e "\n${CAT_WORK} Ya existe archivo .env"
        read -p "¿Deseas sobrescribirlo? (s/N): " overwrite
        if [[ ! $overwrite =~ ^[Ss]$ ]]; then
            echo -e "${CAT_WORK} Se mantiene el archivo .env existente"
            return
        fi
    fi
    
    echo -e "\n${CAT_WORK} Creando archivo .env..."
    
    cat > "${ENV_FILE}" << EOF
# QGIS Environment Variables for Linux
QGIS_PREFIX_PATH=${ENV_PATH}/share/qgis
PYTHONPATH=${ENV_PATH}/share/qgis/python:${ENV_PATH}/share/qgis/python/plugins
PATH=${ENV_PATH}/bin:\${PATH}
LD_LIBRARY_PATH=${ENV_PATH}/lib:\${LD_LIBRARY_PATH}
GDAL_DATA=${ENV_PATH}/share/gdal
GDAL_FILENAME_IS_UTF8=YES
VSI_CACHE=TRUE
VSI_CACHE_SIZE=1000000
QT_QPA_PLATFORM_PLUGIN_PATH=${ENV_PATH}/plugins/platforms
EOF
    
    echo -e "${CAT_OK} Archivo .env creado en: ${ENV_FILE}"
}

# ---------------------------------------------------------
# 4. Crear workspace de VSCode
# ---------------------------------------------------------
create_workspace() {
    WORKSPACE_FILE="${WORKSPACE_DIR}/qgis.code-workspace"
    
    if [ -f "${WORKSPACE_FILE}" ]; then
        echo -e "\n${CAT_WORK} Ya existe archivo qgis.code-workspace"
        read -p "¿Deseas sobrescribirlo? (s/N): " overwrite
        if [[ ! $overwrite =~ ^[Ss]$ ]]; then
            echo -e "${CAT_WORK} Se mantiene el workspace existente"
            return
        fi
    fi
    
    echo -e "\n${CAT_WORK} Creando workspace de VSCode..."
    
    cat > "${WORKSPACE_FILE}" << EOF
{
	"folders": [
		{
			"path": "."
		}
	],
	"settings": {
		"python.defaultInterpreterPath": "${ENV_NAME}/bin/python",
		"python.analysis.extraPaths": [
			"${ENV_NAME}/share/qgis/python",
			"${ENV_NAME}/share/qgis/python/plugins",
			"${ENV_NAME}/share/qgis/python/qgis",
			"${ENV_NAME}/lib/python${PYTHON_VERSION}/site-packages",
			"${ENV_NAME}/include/python${PYTHON_VERSION}",
			"${ENV_NAME}/include/python${PYTHON_VERSION}/qgis"
		],
		"python.envFile": ".env",
		"python.terminal.useEnvFile": true,
		"terminal.integrated.env.linux": {
			"PATH": "${ENV_NAME}/bin:\${env:PATH}",
			"LD_LIBRARY_PATH": "${ENV_NAME}/lib:\${env:LD_LIBRARY_PATH}",
			"GDAL_DATA": "${ENV_NAME}/share/gdal",
			"GDAL_FILENAME_IS_UTF8": "YES",
			"VSI_CACHE": "TRUE",
			"VSI_CACHE_SIZE": "1000000"
		}
	},
	"launch": {
		"version": "0.2.0",
		"configurations": [
			{
				"name": "QGIS Python",
				"type": "debugpy",
				"request": "launch",
				"program": "\${file}",
				"console": "integratedTerminal",
				"envFile": ".env",
				"justMyCode": false,
				"stopOnEntry": false
			}
		]
	}
}
EOF
    
    echo -e "${CAT_OK} Workspace creado en: ${WORKSPACE_FILE}"
}

# ---------------------------------------------------------
# 5. Crear configuración de VSCode
# ---------------------------------------------------------
create_vscode_settings() {
    VSCODE_DIR="${WORKSPACE_DIR}/.vscode"
    SETTINGS_FILE="${VSCODE_DIR}/settings.json"
    
    echo -e "\n${CAT_WORK} Creando configuración de VSCode..."
    
    # Crear directorio .vscode si no existe
    mkdir -p "${VSCODE_DIR}"
    
    if [ -f "${SETTINGS_FILE}" ]; then
        echo -e "${CAT_WORK} Ya existe archivo .vscode/settings.json"
        read -p "¿Deseas sobrescribirlo? (s/N): " overwrite
        if [[ ! $overwrite =~ ^[Ss]$ ]]; then
            echo -e "${CAT_WORK} Se mantiene el archivo settings.json existente"
            return
        fi
    fi
    
    cat > "${SETTINGS_FILE}" << EOF
{
    "python-envs.pythonProjects": [
        {
            "path": "",
            "envManager": "ms-python.python:conda",
            "packageManager": "ms-python.python:conda"
        }
    ]
}
EOF
    
    echo -e "${CAT_OK} Archivo settings.json creado en: ${SETTINGS_FILE}"
}

# ---------------------------------------------------------
# 6. Actualizar .gitignore
# ---------------------------------------------------------
update_gitignore() {
    GITIGNORE="${WORKSPACE_DIR}/.gitignore"
    
    echo -e "\n${CAT_WORK} Actualizando .gitignore..."
    
    # Crear .gitignore si no existe
    touch "${GITIGNORE}"
    
    # Elementos a ignorar
    IGNORE_ITEMS=(".env" "${ENV_NAME}/" "*.pyc" "__pycache__/" "*.code-workspace")
    
    for item in "${IGNORE_ITEMS[@]}"; do
        if ! grep -q "^${item}$" "${GITIGNORE}" 2>/dev/null; then
            echo "${item}" >> "${GITIGNORE}"
            echo -e "  ${CAT_OK} Agregado: ${item}"
        fi
    done
    
    echo -e "${CAT_OK} .gitignore actualizado"
}

# ---------------------------------------------------------
# 6. Verificación opcional
# ---------------------------------------------------------
verify_installation() {
    echo -e "\n${CAT_WORK} Verificando instalación de QGIS..."
    
    # Activar entorno y verificar
    source "$(conda info --base)/etc/profile.d/conda.sh"
    conda activate "${ENV_PATH}"
    
    python3 << 'PYEOF'
import sys
try:
    from qgis.core import Qgis
    print(f"😺 QGIS importado correctamente")
    print(f"   Versión: {Qgis.QGIS_VERSION}")
    sys.exit(0)
except ImportError as e:
    print(f"😿 Error al importar QGIS: {e}")
    sys.exit(1)
except Exception as e:
    print(f"😿 Error inesperado: {e}")
    sys.exit(1)
PYEOF
    
    VERIFY_RESULT=$?
    conda deactivate
    
    return $VERIFY_RESULT
}

# ---------------------------------------------------------
# 7. Mostrar instrucciones finales
# ---------------------------------------------------------
show_instructions() {
    echo -e "\n${CAT_OK} ${CAT_OK} ${CAT_OK} Configuración completada ${CAT_OK} ${CAT_OK} ${CAT_OK}\n"
    echo "Para comenzar a trabajar:"
    echo ""
    echo "1. Abre VSCode con el workspace:"
    echo "   code qgis.code-workspace"
    echo ""
    echo "2. O activa el entorno manualmente:"
    echo "   conda activate ${ENV_PATH}"
    echo ""
    echo "3. Prueba la instalación:"
    echo "   python test_qgis.py"
    echo ""
    echo "4. En VSCode, selecciona el intérprete de Python:"
    echo "   ${ENV_PATH}/bin/python"
    echo ""
}

# ---------------------------------------------------------
# MAIN
# ---------------------------------------------------------
main() {
    echo "=========================================="
    echo "  Configuración de QGIS + VSCode (Linux)"
    echo "=========================================="
    
    detect_conda
    check_or_create_env
    create_env_file
    create_workspace
    create_vscode_settings
    update_gitignore
    
    # Preguntar si verificar
    read -p "¿Deseas verificar la instalación de QGIS? (S/n): " verify
    if [[ ! $verify =~ ^[Nn]$ ]]; then
        verify_installation
    fi
    
    show_instructions
}

# Ejecutar script
main "$@"
