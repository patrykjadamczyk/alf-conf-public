#!/bin/env pwsh

function Test-IsWindows
{
    return [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows);
}