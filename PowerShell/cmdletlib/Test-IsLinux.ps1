#!/bin/env pwsh

function Test-IsLinux
{
    return [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux);
}