#!/usr/bin/env pwsh
####### Variables to bypass some things that PowerShell have
###### IsOS Variables first as reference to use in functions and as alternatives because Windows PowerShell (5.*) don't have them anyway [even windows one]
$_IsWindows = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows);
# Run cmdlets that are dependencies of this cmdlet
$__LibAdmin = Join-Path $PSScriptRoot ".." "cmdletlib" "Test-IsUserAdministrator.ps1"
. $__LibAdmin
# Sudo function
function Invoke-Sudo {
    if ($_IsWindows) {
        $command, $rargs = $args;
        Start-Process $command -Wait -Verb RunAs -Args $rargs
    } else {
        sudo @args
    }
}
# Invoke File as Script
function Invoke-FileAsScript(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateScript({
        If(Test-Path $_){$true}else{throw "Invalid path given: $_"}
    })]
    [string]$Path
) {
    # & [System.Management.Automation.ScriptBlock]::Create(Get-Content -Path $tmpfile -Raw)
    $AnyFile = Get-Content -Path $Path -Raw
    $ScriptBlock = [System.Management.Automation.ScriptBlock]::Create($AnyFile)
    & $ScriptBlock
}
# Invoke Elevated PowerShell Session
function Invoke-PSElevatedSession {
    $tmpfile = New-TemporaryFile
    Set-Content $tmpfile $args
    Get-Process -Id $PID |
        Select-Object -ExpandProperty Path |
        ForEach-Object {
            Invoke-Command {
                Write-Host "Script to run: "
                Get-Content $tmpfile
                $prompt = Read-Host -Prompt "Are you sure you want to run this script as administrator? [Yy/Nn]"
                if ($prompt -eq "Y" -or $prompt -eq "y") {
                    if($_IsWindows) {
                        Start-Process -Wait -Verb RunAs $_ -Args "-Command `"Set-Location '$PWD'; Invoke-FileAsScript $tmpfile; Read-Host -Prompt 'Press any key to continue...'`""
                    } else {
                        sudo $_ -Command "Set-Location '$PWD'; Invoke-FileAsScript $tmpfile;"
                    }
                }
                Remove-Item $tmpfile -Force -ErrorAction SilentlyContinue
            } -NoNewScope
        }
}
# Use Administrator Privilleges
function Use-Administrator-Privilleges (
    [Parameter(Mandatory=$true, Position=0)]
    [PSObject] $FunctionBlock
) {
    if (Test-UserIsAdministrator) {
        Write-Verbose "Already running with Administrator Privilleges"
        Invoke-Command -ScriptBlock $FunctionBlock;
    } else {
        Get-Process -Id $PID |
            Select-Object -ExpandProperty Path |
            ForEach-Object {
                Invoke-Command {
                    Invoke-PSElevatedSession $FunctionBlock
                } -NoNewScope
            }
    }
}