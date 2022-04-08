#!/bin/env pwsh

function Test-IsMacOS
{
    return [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX);
}