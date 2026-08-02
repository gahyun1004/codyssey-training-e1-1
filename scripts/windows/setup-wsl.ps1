[CmdletBinding()]
param(
    [string]$Distribution = "Ubuntu-24.04",
    [string]$InstallRoot = "C:\WSL"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
}

function Get-InstalledDistributions {
    $raw = @(wsl.exe --list --quiet 2>$null)
    return @(
        $raw |
            ForEach-Object { ($_ -replace "`0", "").Trim() } |
            Where-Object { $_ }
    )
}

if (-not (Test-Administrator)) {
    Write-Error "관리자 권한 PowerShell 또는 Windows Terminal에서 실행하세요."
    exit 1
}

if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Write-Error "wsl.exe를 찾지 못했습니다. Windows 11 업데이트 상태를 확인하세요."
    exit 1
}

$installLocation = Join-Path -Path $InstallRoot -ChildPath $Distribution

Write-Host "[INFO] Windows 정보"
Get-ComputerInfo |
    Select-Object WindowsProductName, WindowsVersion, OsBuildNumber |
    Format-List

Write-Host "[INFO] 요청한 WSL 배포판 설치 위치"
Write-Host "       Distribution : $Distribution"
Write-Host "       Install root : $InstallRoot"
Write-Host "       Final path   : $installLocation"

Write-Host "[INFO] WSL 설치 상태 확인"
wsl.exe --version *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "[INFO] WSL 기능만 먼저 설치합니다."
    wsl.exe --install --no-distribution
    if ($LASTEXITCODE -ne 0) {
        Write-Error "WSL 기본 기능 설치에 실패했습니다."
        exit $LASTEXITCODE
    }

    Write-Warning "Windows를 재시작한 뒤 이 스크립트를 다시 실행하세요."
    exit 0
}

Write-Host "[INFO] WSL 업데이트"
wsl.exe --update
if ($LASTEXITCODE -ne 0) {
    Write-Error "WSL 업데이트에 실패했습니다."
    exit $LASTEXITCODE
}

Write-Host "[INFO] 새 배포판의 기본 WSL 버전을 2로 설정"
wsl.exe --set-default-version 2
if ($LASTEXITCODE -ne 0) {
    Write-Error "WSL 기본 버전을 2로 설정하지 못했습니다."
    exit $LASTEXITCODE
}

$helpText = (wsl.exe --help 2>&1 | Out-String)
if ($helpText -notmatch "--location") {
    Write-Error @"
현재 WSL은 --location 옵션을 지원하지 않습니다.
wsl.exe --update, Windows Update, Microsoft Store WSL 업데이트를 완료한 뒤 다시 실행하세요.
"@
    exit 1
}

$installed = Get-InstalledDistributions
if ($installed -contains $Distribution) {
    Write-Warning "$Distribution 배포판이 이미 설치되어 있습니다."
    Write-Warning "기존 배포판을 자동으로 unregister하거나 이동하지 않습니다."
    Write-Warning "설치 위치 이동은 별도 백업·export·import 절차가 필요합니다."

    wsl.exe --set-version $Distribution 2
    if ($LASTEXITCODE -ne 0) {
        Write-Error "$Distribution 배포판을 WSL2로 설정하지 못했습니다."
        exit $LASTEXITCODE
    }

    wsl.exe --set-default $Distribution
    if ($LASTEXITCODE -ne 0) {
        Write-Error "기본 WSL 배포판을 설정하지 못했습니다."
        exit $LASTEXITCODE
    }

    wsl.exe --list --verbose
    Write-Host "[NEXT] 기존 배포판의 실제 위치를 확인한 뒤 계속 진행하세요."
    exit 0
}

Write-Host "[INFO] 설치 루트 생성: $InstallRoot"
New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null

if (Test-Path -LiteralPath $installLocation) {
    $existingItems = @(
        Get-ChildItem -LiteralPath $installLocation -Force -ErrorAction SilentlyContinue
    )

    if ($existingItems.Count -gt 0) {
        Write-Error "대상 폴더가 비어 있지 않습니다: $installLocation"
        exit 1
    }
} else {
    New-Item -ItemType Directory -Force -Path $installLocation | Out-Null
}

Write-Host "[INFO] $Distribution 배포판을 지정 위치에 설치합니다."
Write-Host "[INFO] $installLocation"

wsl.exe --install `
    --distribution $Distribution `
    --location $installLocation `
    --no-launch

if ($LASTEXITCODE -ne 0) {
    Write-Error "$Distribution 설치에 실패했습니다."
    exit $LASTEXITCODE
}

wsl.exe --set-version $Distribution 2
if ($LASTEXITCODE -ne 0) {
    Write-Error "$Distribution 배포판을 WSL2로 설정하지 못했습니다."
    exit $LASTEXITCODE
}

wsl.exe --set-default $Distribution
if ($LASTEXITCODE -ne 0) {
    Write-Error "기본 WSL 배포판을 설정하지 못했습니다."
    exit $LASTEXITCODE
}

Write-Host "[INFO] 설치 폴더 확인"
if (-not (Test-Path -LiteralPath $installLocation)) {
    Write-Error "설치 폴더가 확인되지 않습니다: $installLocation"
    exit 1
}

Get-ChildItem -LiteralPath $installLocation -Force

Write-Host "[INFO] 최종 WSL 배포판 상태"
wsl.exe --list --verbose

Write-Host "[PASS] Ubuntu 24.04 지정 위치 설치를 완료했습니다."
Write-Host "[PASS] 설치 위치: $installLocation"
Write-Host "[NEXT] wsl.exe -d $Distribution 명령으로 Ubuntu를 실행하고 Linux 사용자를 생성하세요."
