#!/bin/env pwsh

function Test-Is64Bit
{
    return [IntPtr]::Size -eq 8;
}