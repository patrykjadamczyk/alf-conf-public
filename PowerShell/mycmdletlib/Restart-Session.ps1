#!/usr/bin/env pwsh
# Restart Session
function Restart-Session {
    Get-Process -Id $PID | Select-Object -ExpandProperty Path | ForEach-Object { Invoke-Command { & "$_" } -NoNewScope }
}