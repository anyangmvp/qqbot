$ErrorActionPreference = "Stop"

Write-Host "=== QQBot Upgrade Script ===" -ForegroundColor Cyan

function Cleanup-Installation {
    param([string]$AppName)

    $appDir = Join-Path $env:USERPROFILE ".$AppName"
    $configFile = Join-Path $appDir "$AppName.json"
    $extensionDir = Join-Path $appDir "extensions\qqbot"

    Write-Host ""
    Write-Host ">>> Processing $AppName installation..." -ForegroundColor Yellow

    if (Test-Path $extensionDir -PathType Container) {
        Write-Host "Deleting old plugin: $extensionDir"
        try {
            Remove-Item -Path $extensionDir -Recurse -Force
        } catch {
            Write-Host "Warning: Could not delete $extensionDir (permission denied)" -ForegroundColor Yellow
            Write-Host "  Please delete it manually if needed" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Old plugin directory not found, skipping"
    }

    if (Test-Path $configFile -PathType Leaf) {
        Write-Host "Cleaning qqbot fields from config..."

        $scriptDir = $PSScriptRoot
        $jsScript = Join-Path $scriptDir "upgrade-config.cjs"

        try {
            node $jsScript $configFile
        } catch {
            Write-Host "Warning: Node.js error: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "Config file not found: $configFile"
    }
}

$foundInstallation = ""

$clawdbotDir = Join-Path $env:USERPROFILE ".clawdbot"
if (Test-Path $clawdbotDir -PathType Container) {
    Cleanup-Installation -AppName "clawdbot"
    $foundInstallation = "clawdbot"
}

$openclawDir = Join-Path $env:USERPROFILE ".openclaw"
if (Test-Path $openclawDir -PathType Container) {
    Cleanup-Installation -AppName "openclaw"
    $foundInstallation = "openclaw"
}

if ([string]::IsNullOrEmpty($foundInstallation)) {
    Write-Host "clawdbot or openclaw not found" -ForegroundColor Red
    exit 1
}

$cmd = $foundInstallation

Write-Host ""
Write-Host "=== Cleanup Complete ===" -ForegroundColor Green
Write-Host ""
Write-Host "Run these commands to reinstall:" -ForegroundColor Cyan
$qqbotDir = Split-Path -Parent $PSScriptRoot
Write-Host "  cd $qqbotDir"
Write-Host "  $cmd plugins install ."
Write-Host "  $cmd channels add --channel qqbot --token `"AppID:AppSecret`""
Write-Host "  $cmd gateway restart"
