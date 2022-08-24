#!/usr/bin/env pwsh

Write-Host -ForegroundColor Green "Loading PowerShell Profile File..."
$__maxBaseSteps = 6;
Write-Progress -Id 1 -Activity "Loading PowerShell Profile File" -Status "1. Initialization" -PercentComplete ((1/$__maxBaseSteps)*100) -CurrentOperation "Loading ..."

######## Variables to bypass some things that PowerShell have
###### IsOS Variables first as reference to use in functions and as alternatives because Windows PowerShell (5.*) don't have them anyway [even windows one]
$_IsWindows = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows);
$_IsLinux = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux);
$_IsMacOS = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX);
###### Base Variables
$_IsServer = $false;
$_ServerConfig = @{
    OVH_Server = $false
};
###### Alf Config
Write-Progress -Id 1 -Activity "Loading PowerShell Profile File" -Status "2. Alf Aliases" -PercentComplete ((2/$__maxBaseSteps)*100) -CurrentOperation "Loading ..."
$__AlfConfig = Join-Path $PSScriptRoot "alf" "alf_conf.ps1"
. $__AlfConfig
###### Cmdlet Library
Write-Progress -Id 1 -Activity "Loading PowerShell Profile File" -Status "3. Cmdlet Library" -PercentComplete ((3/$__maxBaseSteps)*100) -CurrentOperation "Loading ..."
$__maxSteps = 17;
# HumanReadableBytes
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Convert-FromHumanReadableBytes" -PercentComplete ((1/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script1 = Join-Path $PSScriptRoot "cmdletlib" "Convert-FromHumanReadableBytes.ps1"
. $__Script1
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Convert-FromHumanReadableBytesBinary" -PercentComplete ((2/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script2 = Join-Path $PSScriptRoot "cmdletlib" "Convert-FromHumanReadableBytesBinary.ps1"
. $__Script2
# Format FileSize
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Format-FileSize" -PercentComplete ((3/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script3 = Join-Path $PSScriptRoot "cmdletlib" "Format-FileSize.ps1"
. $__Script3
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Format-FileSizeBinary" -PercentComplete ((4/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script4 = Join-Path $PSScriptRoot "cmdletlib" "Format-FileSizeBinary.ps1"
. $__Script4
# Get-Disk
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Get-Disk" -PercentComplete ((5/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script5 = Join-Path $PSScriptRoot "cmdletlib" "Get-Disk.ps1"
. $__Script5
# jdhitsolutions/PSScriptTools
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Get-WhoIs" -PercentComplete ((6/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script6 = Join-Path $PSScriptRoot "cmdletlib" "Get-WhoIs.ps1"
. $__Script6
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-IsElevated" -PercentComplete ((7/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script7 = Join-Path $PSScriptRoot "cmdletlib" "Test-IsElevated.ps1"
. $__Script7
# Test Platform
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-Is64Bit" -PercentComplete ((8/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script8 = Join-Path $PSScriptRoot "cmdletlib" "Test-Is64Bit.ps1"
. $__Script8
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-IsLinux" -PercentComplete ((9/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script9 = Join-Path $PSScriptRoot "cmdletlib" "Test-IsLinux.ps1"
. $__Script9
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-IsMacOS" -PercentComplete ((10/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script10 = Join-Path $PSScriptRoot "cmdletlib" "Test-IsMacOS.ps1"
. $__Script10
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-IsWindows" -PercentComplete ((11/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script11 = Join-Path $PSScriptRoot "cmdletlib" "Test-IsWindows.ps1"
. $__Script11
# GzCore
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-WinUserIsInRole" -PercentComplete ((12/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script12 = Join-Path $PSScriptRoot "cmdletlib" "Test-WinUserIsInRole.ps1"
. $__Script12
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-UnixUserIsInRole" -PercentComplete ((13/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script13 = Join-Path $PSScriptRoot "cmdletlib" "Test-UnixUserIsInRole.ps1"
. $__Script13
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-IsUserAdministrator" -PercentComplete ((14/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script14 = Join-Path $PSScriptRoot "cmdletlib" "Test-IsUserAdministrator.ps1"
. $__Script14
# Check-SSLCertificate
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Check-SSLCertificate" -PercentComplete ((15/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script15 = Join-Path $PSScriptRoot "cmdletlib" "Check-SSLCertificate.ps1"
. $__Script15
# Test-Command
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-Command" -PercentComplete ((16/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script16 = Join-Path $PSScriptRoot "cmdletlib" "Test-Command.ps1"
. $__Script16
# Test-IsWSL
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Status "Test-IsWSL" -PercentComplete ((17/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__Script17 = Join-Path $PSScriptRoot "cmdletlib" "Test-IsWSL.ps1"
. $__Script17
Write-Progress -ParentId 1 -Id 2 -Activity "Loading Cmdlet Library" -Completed

###### My Cmdlet Library
Write-Progress -Id 1 -Activity "Loading PowerShell Profile File" -Status "4. My Cmdlet Library" -PercentComplete ((4/$__maxBaseSteps)*100) -CurrentOperation "Loading ..."
$__maxSteps = 2;
$__step = 0;
if ($_IsServer -and $_ServerConfig["OVH_Server"]) {
    $__maxSteps += 1;
    $__steps += 1;
    Write-Progress -ParentId 1 -Id 2 -Activity "Loading My Cmdlet Library" -Status "Mount-OVHBackupStorage" -PercentComplete (($__step/$__maxSteps)*100) -CurrentOperation "Loading ..."
    $__OVHBackupStorageScript = Join-Path $PSScriptRoot "mycmdletlib" "Mount-OVHBackupStorage.ps1"
    . $__OVHBackupStorageScript
}
$__steps += 1;
Write-Progress -ParentId 1 -Id 2 -Activity "Loading My Cmdlet Library" -Status "Use-Administrator-Privilleges" -PercentComplete (($__step/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__UseAdministratorPrivilleges = Join-Path $PSScriptRoot "mycmdletlib" "Use-Administrator-Privilleges.ps1"
. $__UseAdministratorPrivilleges
$__steps += 1;
Write-Progress -ParentId 1 -Id 2 -Activity "Loading My Cmdlet Library" -Status "Use-WSL" -PercentComplete (($__step/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__UseWSL = Join-Path $PSScriptRoot "mycmdletlib" "Use-WSL.ps1"
. $__UseWSL
Write-Progress -ParentId 1 -Id 2 -Activity "Loading My Cmdlet Library" -Status "Package-Manager" -PercentComplete (($__step/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__PackageManager = Join-Path $PSScriptRoot "mycmdletlib" "Package-Manager.ps1"
. $__PackageManager
$__steps += 1;
Write-Progress -ParentId 1 -Id 2 -Activity "Loading My Cmdlet Library" -Status "Restart-Session" -PercentComplete (($__step/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__RestartSession = Join-Path $PSScriptRoot "mycmdletlib" "Restart-Session.ps1"
. $__RestartSession
$__steps += 1;
Write-Progress -ParentId 1 -Id 2 -Activity "Loading My Cmdlet Library" -Status "Run-DockerShellImage" -PercentComplete (($__step/$__maxSteps)*100) -CurrentOperation "Loading ..."
$__RunDockerShellImage = Join-Path $PSScriptRoot "mycmdletlib" "Run-DockerShellImage.ps1"
. $__RunDockerShellImage

###### Profile Scripts
Write-Progress -Id 1 -Activity "Loading PowerShell Profile File" -Status "5. Profile Scripts" -PercentComplete ((5/$__maxBaseSteps)*100) -CurrentOperation "Loading ..."
$__ScriptF = Join-Path $PSScriptRoot "profile_scripts" "Index.ps1"
. $__ScriptF

###### Finishing
Write-Progress -Id 1 -Activity "Loading PowerShell Profile File" -Status "6. Finishing" -PercentComplete ((6/$__maxBaseSteps)*100) -CurrentOperation "Loading ..."
Write-Progress -Id 1 -Activity "Loading PowerShell Profile File" -Completed