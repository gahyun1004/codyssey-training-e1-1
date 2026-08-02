[CmdletBinding()]
param(
    [string]$Distribution = "Ubuntu-24.04",
    [string]$InstallPath = "C:\WSL\codyssey-ubuntu24",
    [string]$RepositoryPath = "codyssey-training/codyssey-training-e1-1"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Protect-SensitiveText {
    param(
        [AllowEmptyString()]
        [string]$Text
    )

    if ($null -eq $Text) {
        return ""
    }

    $protected = $Text
    $protected = [regex]::Replace(
        $protected,
        '(?i)(https?://)[^/@\s]+@',
        '$1***@'
    )
    $protected = [regex]::Replace(
        $protected,
        '(?i)([A-Z]:\\Users\\)[^\\\s]+',
        '$1<USER>'
    )
    $protected = [regex]::Replace(
        $protected,
        '(?i)(\\\\wsl(?:\.localhost)?\\[^\\]+\\home\\)[^\\\s]+',
        '$1<USER>'
    )
    $protected = [regex]::Replace(
        $protected,
        '(?i)(/home/)[^/\s]+',
        '$1<USER>'
    )
    return $protected
}

if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Write-Error "wsl.exe를 찾지 못했습니다. WSL 설치 상태를 확인하세요."
    exit 1
}

$linuxRepository = (wsl.exe --distribution $Distribution -- bash -lc "cd ~/$RepositoryPath && pwd -P" 2>$null | Out-String).Trim()
if (-not $linuxRepository) {
    Write-Error "WSL 저장소를 찾지 못했습니다: ~/$RepositoryPath"
    exit 1
}

$windowsRepository = (wsl.exe --distribution $Distribution -- wslpath -w $linuxRepository 2>$null | Out-String).Trim()
if (-not $windowsRepository) {
    Write-Error "WSL 저장소의 Windows 경로를 확인하지 못했습니다."
    exit 1
}

$logDirectory = Join-Path $windowsRepository "docs\logs"
$logPath = Join-Path $logDirectory "windows-wsl-host.txt"
New-Item -ItemType Directory -Force -Path $logDirectory | Out-Null

$lines = New-Object System.Collections.Generic.List[string]

function Add-CommandResult {
    param(
        [Parameter(Mandatory = $true)]
        [string]$CommandText,

        [Parameter(Mandatory = $true)]
        [scriptblock]$Command
    )

    $lines.Add("`$ $CommandText")
    try {
        $result = & $Command 2>&1 | Out-String
        $lines.Add((Protect-SensitiveText $result.TrimEnd()))
    }
    catch {
        $lines.Add(
            Protect-SensitiveText "[ERROR] $($_.Exception.Message)"
        )
        throw
    }
}

Add-CommandResult "Get-Date -Format o" { Get-Date -Format o }
Add-CommandResult "Get-ComputerInfo | Select WindowsProductName, WindowsVersion, OsBuildNumber" {
    Get-ComputerInfo |
        Select-Object WindowsProductName, WindowsVersion, OsBuildNumber |
        Format-List
}
Add-CommandResult "wsl.exe --version" { wsl.exe --version }
Add-CommandResult "wsl.exe --status" { wsl.exe --status }
Add-CommandResult "wsl.exe --list --verbose" { wsl.exe --list --verbose }
Add-CommandResult "Test-Path '$InstallPath'" {
    Test-Path -LiteralPath $InstallPath
}
Add-CommandResult "Get-ChildItem -Force '$InstallPath'" {
    Get-ChildItem -Force -LiteralPath $InstallPath |
        Select-Object Name, Length, LastWriteTime
}
Add-CommandResult "code --version" {
    if (Get-Command code -ErrorAction SilentlyContinue) {
        code --version
    }
    else {
        "[INFO] VS Code CLI(code)를 찾지 못했습니다."
    }
}
Add-CommandResult "WSL repository path" {
    "Linux : $linuxRepository"
    "Windows: $windowsRepository"
}

$protectedLines = $lines | ForEach-Object {
    Protect-SensitiveText $_
}
$protectedLines | Set-Content -Encoding utf8 $logPath

Write-Host "[PASS] Windows·WSL 호스트 로그를 저장했습니다."
Write-Host "[PASS] $(Protect-SensitiveText $logPath)"
Write-Host "[NEXT] 자동 마스킹 후에도 커밋 전에 로그 전체를 직접 검토하세요."
