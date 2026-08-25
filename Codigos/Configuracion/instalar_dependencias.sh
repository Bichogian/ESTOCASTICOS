#!/usr/bin/env bash

set -euo pipefail

# Instalador del entorno de Python para MIA103 / Estocasticos en macOS/Linux.
#
# Ejecutar desde la raiz del repositorio:
#   ./Codigos/Configuracion/instalar_dependencias.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
VENV_DIR="$REPO_DIR/.venv"
VENV_PYTHON="$VENV_DIR/bin/python"
REQUIREMENTS_FILE="$REPO_DIR/requirements.txt"
KERNEL_NAME="mia103-estocasticos"
KERNEL_DISPLAY_NAME="MIA103 Estocasticos (.venv)"

echo ""
echo "=== Preparacion del entorno de Estocasticos ==="
echo "Repositorio: $REPO_DIR"

if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
  echo "No se encontro requirements.txt en: $REQUIREMENTS_FILE" >&2
  exit 1
fi

if [[ ! -x "$VENV_PYTHON" ]]; then
  echo ""
  echo "[1/3] Creando el entorno virtual .venv..."

  if command -v python3 >/dev/null 2>&1; then
    SYSTEM_PYTHON="python3"
  elif command -v python >/dev/null 2>&1; then
    SYSTEM_PYTHON="python"
  else
    echo "Python no esta instalado o no esta disponible en PATH." >&2
    exit 1
  fi

  "$SYSTEM_PYTHON" -m venv "$VENV_DIR"
else
  echo ""
  echo "[1/3] El entorno .venv ya existe; se reutilizara."
fi

echo ""
echo "[2/3] Actualizando pip..."
"$VENV_PYTHON" -m pip install --upgrade pip

echo ""
echo "[3/3] Instalando las dependencias de requirements.txt..."
"$VENV_PYTHON" -m pip install -r "$REQUIREMENTS_FILE"

echo ""
echo "Registrando kernel de Jupyter..."
"$VENV_PYTHON" -m ipykernel install --user --name "$KERNEL_NAME" --display-name "$KERNEL_DISPLAY_NAME"

echo ""
echo "=== Instalacion terminada correctamente ==="
echo ""
echo "Para abrir JupyterLab ejecuta:"
echo "  \"$VENV_PYTHON\" -m jupyter lab"
echo ""
echo "En Jupyter, elegi el kernel:"
echo "  $KERNEL_DISPLAY_NAME"
echo ""
