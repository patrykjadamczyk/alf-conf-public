#!/bin/env pwsh

function Test-UserIsAdministrator() {

    [CmdletBinding()]
    Param()

    PROCESS {
        if (Test-IsWindows)
        {
            $gzCurrentUserIsAdministrator = Test-WinUserIsInRole -BuiltInRole "Administrator"
        }
        elseif (Test-IsMacOS)
        {
            $gzCurrentUserIsAdministrator = Test-UnixUserIsInRole -Group "Root"
        }
        elseif (Test-IsLinux)
        {
            $gzCurrentUserIsAdministrator = Test-UnixUserIsInRole -Group "Root"
        }
        else
        {
            $plat = [Environment]::OsVersion.Platform
            Write-Warning "$plat Not Supported"
            $gzCurrentUserIsAdministrator = $false
        }

        return $gzCurrentUserIsAdministrator
    }
}