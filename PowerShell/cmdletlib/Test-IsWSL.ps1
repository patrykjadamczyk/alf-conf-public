#!/bin/env pwsh

function Test-IsWSL {
    if ([System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux)) {
        if (Test-Path /proc/version) {
            $procVersion = Get-Content /proc/version
            if ($procVersion -match "Microsoft")
            {
                return $true
            }
        }
    }
    return $false
}