#!/usr/bin/env pwsh
####### Variables to bypass some things that PowerShell have
###### IsOS Variables first as reference to use in functions and as alternatives because Windows PowerShell (5.*) don't have them anyway [even windows one]
$_IsWindows = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows);
# Invoke in WSL
function Invoke-InWSL (
    [Parameter(Mandatory=$true, Position=0)]
    [PSObject] $FunctionBlock,
    [Parameter(Mandatory=$false, Position=1)]
    [string] $WSLDistribution = "Ubuntu",
    [Parameter(Mandatory=$false)]
    [bool] $NoProfile = $true
) {
    if ($_IsWindows) {
        if ($NoProfile) {
            return wsl -d $WSLDistribution -e pwsh -NoProfile -Command "$FunctionBlock"
        } else {
            return wsl -d $WSLDistribution -e pwsh -Command "$FunctionBlock"
        }
    } else {
        Write-Error "This cmdlet supports only Windows."
    }
}
# Use WSL
function Use-WSL (
    [Parameter(Mandatory=$true, Position=0)]
    [PSObject] $FunctionBlock,
    [Parameter(Mandatory=$false, Position=1)]
    [string] $WSLDistribution = "Ubuntu"
) {
    if ($_IsWindows) {
        # Create Temporary File in WSL
        $tmpfile = Invoke-InWSL { New-TemporaryFile | Write-Host } -WSLDistribution $WSLDistribution
        # Make UNC path to WSL Temporary File
        $wslPath = Join-Path "\\Wsl$" $WSLDistribution $tmpfile;

        # Write FunctionBlock to WSL Temporary File
        Set-Content $wslPath @FunctionBlock

        # Invoke WSL Temporary File
        Invoke-InWSL "Invoke-Expression `$(Get-Content $tmpfile);" -WSLDistribution $WSLDistribution -NoProfile $false
        # Remove WSL Temporary File
        Invoke-InWSL "Remove-Item $tmpfile -Force -ErrorAction SilentlyContinue" -WSLDistribution $WSLDistribution
    } else {
        Write-Error "This cmdlet supports only Windows."
    }
}