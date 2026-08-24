# Instalador del entorno de Python para MIA103 / Estocasticos.
#
# Ejecutar desde PowerShell, parado en la raiz del repositorio:
#   powershell -ExecutionPolicy Bypass -File .\Codigos\Configuracion\instalar_dependencias.ps1

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoDir = (Resolve-Path (Join-Path $scriptDir "..\..")).Path
$venvDir = Join-Path $repoDir ".venv"
$venvPython = Join-Path $venvDir "Scripts\python.exe"
$requirementsFile = Join-Path $repoDir "requirements.txt"

Write-Host ""
Write-Host "=== Preparacion del entorno de Estocasticos ===" -ForegroundColor Cyan
Write-Host "Repositorio: $repoDir"

if (-not (Test-Path -LiteralPath $requirementsFile)) {
    throw "No se encontro requirements.txt en: $requirementsFile"
}

if (-not (Test-Path -LiteralPath $venvPython)) {
    Write-Host ""
    Write-Host "[1/3] Creando el entorno virtual .venv..." -ForegroundColor Yellow

    $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
    if (-not $pythonCommand) {
        throw "Python no esta instalado o no esta disponible en PATH. Instala Python y vuelve a ejecutar este script."
    }

    & $pythonCommand.Source -m venv $venvDir
} else {
    Write-Host ""
    Write-Host "[1/3] El entorno .venv ya existe; se reutilizara." -ForegroundColor Green
}

Write-Host ""
Write-Host "[2/3] Actualizando pip..." -ForegroundColor Yellow
& $venvPython -m pip install --upgrade pip

Write-Host ""
Write-Host "[3/3] Instalando las dependencias de requirements.txt..." -ForegroundColor Yellow
& $venvPython -m pip install -r $requirementsFile

Write-Host ""
Write-Host "=== Instalacion terminada correctamente ===" -ForegroundColor Green
Write-Host ""
Write-Host "Para abrir JupyterLab ejecuta:"
Write-Host "  .\.venv\Scripts\python.exe -m jupyter lab" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para activar el entorno virtual en PowerShell ejecuta:"
Write-Host "  .\.venv\Scripts\Activate.ps1" -ForegroundColor Cyan
Write-Host ""
