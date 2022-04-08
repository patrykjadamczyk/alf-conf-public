#!/usr/bin/env pwsh
# Watch Log File (bash: tail -n 10 -f $LogFile)
function wlf (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $LogFile
) {
    Get-Content -Tail 10 -Wait $LogFile
}