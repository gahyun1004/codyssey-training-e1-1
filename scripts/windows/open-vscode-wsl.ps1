[CmdletBinding()]
param(
    [string]$Distribution = "Ubuntu-24.04",
    [string]$RepositoryPath = "codyssey-training/codyssey-training-e1-1"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Write-Error "wsl.exe를 찾지 못했습니다. WSL을 먼저 설치하세요."
    exit 1
}

if (-not (Get-Command code -ErrorAction SilentlyContinue)) {
    Write-Error "VS Code CLI(code)를 찾지 못했습니다. Windows용 VS Code 설치와 PATH 설정을 확인하세요."
    exit 1
}

$installedRaw = @(wsl.exe --list --quiet 2>$null)
$installed = @(
    $installedRaw |
        ForEach-Object { ($_ -replace "`0", "").Trim() } |
        Where-Object { $_ }
)

if ($installed -notcontains $Distribution) {
    Write-Error "WSL 배포판을 찾지 못했습니다: $Distribution"
    exit 1
}

$remoteCommandTemplate = @'
set -Eeuo pipefail
repo="$HOME/__REPOSITORY_PATH__"
test -d "$repo/.git"
cd "$repo"
printf '[INFO] WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-unknown}"
printf '[INFO] Repository=%s\n' "$PWD"
exec code .
'@

$remoteCommand = $remoteCommandTemplate.Replace(
    "__REPOSITORY_PATH__",
    $RepositoryPath
)

Write-Host "[INFO] Distribution: $Distribution"
Write-Host "[INFO] Linux repository: ~/$RepositoryPath"

wsl.exe --distribution $Distribution -- bash -lc $remoteCommand

if ($LASTEXITCODE -ne 0) {
    Write-Error "WSL 저장소에서 VS Code를 실행하지 못했습니다."
    exit $LASTEXITCODE
}
