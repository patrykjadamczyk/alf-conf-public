#!/bin/env pwsh

function Get-Disk {
    return [System.IO.DriveInfo]::getdrives()
}