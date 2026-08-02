[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$failures = New-Object System.Collections.Generic.List[string]

Get-ChildItem -Path (Join-Path $repositoryRoot "scripts") -Recurse -Filter "*.ps1" |
    Sort-Object FullName |
    ForEach-Object {
        $tokens = $null
        $parseErrors = $null
        [System.Management.Automation.Language.Parser]::ParseFile(
            $_.FullName,
            [ref]$tokens,
            [ref]$parseErrors
        ) | Out-Null

        $relative = [System.IO.Path]::GetRelativePath(
            $repositoryRoot,
            $_.FullName
        )

        if ($parseErrors.Count -gt 0) {
            foreach ($parseError in $parseErrors) {
                $failures.Add(
                    "${relative}:$($parseError.Extent.StartLineNumber): $($parseError.Message)"
                )
            }
        }
        else {
            Write-Host "[PASS] PowerShell syntax: $relative"
        }
    }

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Error $failure
    }
    exit 1
}

Write-Host "[PASS] All PowerShell scripts parsed successfully."
