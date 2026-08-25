# Instalador del entorno de Python para MIA103 / Estocasticos.
#
# Ejecutar desde PowerShell, parado en la raiz del repositorio:
#   powershell -ExecutionPolicy Bypass -File .\Codigos\Configuracion\instalar_dependencias.ps1
#
# En macOS/Linux con PowerShell instalado:
#   pwsh ./Codigos/Configuracion/instalar_dependencias.ps1

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoDir = (Resolve-Path (Join-Path $scriptDir "..\..")).Path
$venvDir = Join-Path $repoDir ".venv"
$venvPythonWindows = Join-Path $venvDir "Scripts\python.exe"
$venvPythonUnix = Join-Path $venvDir "bin/python"
$requirementsFile = Join-Path $repoDir "requirements.txt"
$kernelName = "mia103-estocasticos"
$kernelDisplayName = "MIA103 Estocasticos (.venv)"

function Get-VenvPython {
    if (Test-Path -LiteralPath $venvPythonWindows) {
        return $venvPythonWindows
    }

    if (Test-Path -LiteralPath $venvPythonUnix) {
        return $venvPythonUnix
    }

    return $null
}

function Get-SystemPython {
    $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
    if ($pythonCommand) {
        return $pythonCommand.Source
    }

    $python3Command = Get-Command python3 -ErrorAction SilentlyContinue
    if ($python3Command) {
        return $python3Command.Source
    }

    return $null
}

Write-Host ""
Write-Host "=== Preparacion del entorno de Estocasticos ===" -ForegroundColor Cyan
Write-Host "Repositorio: $repoDir"

if (-not (Test-Path -LiteralPath $requirementsFile)) {
    throw "No se encontro requirements.txt en: $requirementsFile"
}

if (-not (Get-VenvPython)) {
    Write-Host ""
    Write-Host "[1/3] Creando el entorno virtual .venv..." -ForegroundColor Yellow

    $pythonCommand = Get-SystemPython
    if (-not $pythonCommand) {
        throw "Python no esta instalado o no esta disponible en PATH. Instala Python 3 y vuelve a ejecutar este script."
    }

    & $pythonCommand -m venv $venvDir
} else {
    Write-Host ""
    Write-Host "[1/3] El entorno .venv ya existe; se reutilizara." -ForegroundColor Green
}

$venvPython = Get-VenvPython
if (-not $venvPython) {
    throw "No se encontro el Python del entorno virtual despues de crear .venv."
}

Write-Host ""
Write-Host "[2/3] Actualizando pip..." -ForegroundColor Yellow
& $venvPython -m pip install --upgrade pip

Write-Host ""
Write-Host "[3/3] Instalando las dependencias de requirements.txt..." -ForegroundColor Yellow
& $venvPython -m pip install -r $requirementsFile

Write-Host ""
Write-Host "Registrando kernel de Jupyter..." -ForegroundColor Yellow
& $venvPython -m ipykernel install --user --name $kernelName --display-name $kernelDisplayName

Write-Host ""
Write-Host "=== Instalacion terminada correctamente ===" -ForegroundColor Green
Write-Host ""
Write-Host "Para abrir JupyterLab ejecuta:"
Write-Host "  $venvPython -m jupyter lab" -ForegroundColor Cyan
Write-Host ""
Write-Host "En Jupyter, elegi el kernel:"
Write-Host "  $kernelDisplayName" -ForegroundColor Cyan
Write-Host ""
