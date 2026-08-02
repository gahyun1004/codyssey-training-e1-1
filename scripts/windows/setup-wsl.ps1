[CmdletBinding()]
param(
    [string]$Distribution = "Ubuntu-24.04"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Test-Administrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    Write-Error "관리자 권한 PowerShell 또는 Windows Terminal에서 실행하세요."
    exit 1
}

if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Write-Error "wsl.exe를 찾지 못했습니다. Windows 11의 선택적 기능과 업데이트 상태를 확인하세요."
    exit 1
}

Write-Host "[INFO] Windows 정보"
Get-ComputerInfo |
    Select-Object WindowsProductName, WindowsVersion, OsBuildNumber |
    Format-List

Write-Host "[INFO] WSL 상태"
wsl.exe --version
wsl.exe --status

$installedRaw = @(wsl.exe --list --quiet 2>$null)
$installed = @(
    $installedRaw |
        ForEach-Object { ($_ -replace "`0", "").Trim() } |
        Where-Object { $_ }
)

if ($installed -notcontains $Distribution) {
    Write-Host "[INFO] $Distribution 배포판을 설치합니다."
    Write-Host "[INFO] 설치 후 Windows 재시작과 Ubuntu 최초 사용자 생성이 필요할 수 있습니다."
    wsl.exe --install -d $Distribution
    exit $LASTEXITCODE
}

Write-Host "[INFO] $Distribution 배포판이 이미 설치되어 있습니다."

wsl.exe --set-default-version 2
if ($LASTEXITCODE -ne 0) {
    Write-Error "WSL 기본 버전을 2로 설정하지 못했습니다."
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

Write-Host "[INFO] 최종 WSL 배포판 상태"
wsl.exe --list --verbose

Write-Host "[PASS] WSL2와 Ubuntu 24.04 상태 점검을 완료했습니다."
Write-Host "[NEXT] wsl.exe -d $Distribution 명령으로 Ubuntu를 실행하세요."
