#!/bin/env pwsh
# https://github.com/jdhitsolutions/PSScriptTools/blob/95a19093df732e7a984ebfadd05052f9afd01071/functions/Test-IsElevated.ps1
#test if running elevated

Function Test-IsElevated {
    [cmdletbinding()]
    [OutputType("Boolean")]
    Param()

    Write-Verbose "Starting $($MyInvocation.mycommand)"
    if ($ISWindows -OR $PSEdition -eq 'Desktop') {
        Write-Verbose "Windows detected"
        $user = [Security.Principal.WindowsIdentity]::GetCurrent();
        (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
    }
    else {
        Write-Verbose "Non-Windows detected"
        #Assuming the same non-Windows code works until someone gives me feedback
        if ( (id -u) -eq 0) {$True} else {$False}
    }
    Write-Verbose "Ending $($MyInvocation.mycommand)"
}