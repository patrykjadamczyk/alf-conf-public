#!/bin/env pwsh

function Convert-FromHumanReadableBytesBinary {
    Param
    (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$size
    )
    Process {
        $realSize = $size -replace " ", ""
        if ($realSize -match "(.*)PB") {
            return ([float]$Matches[1]) * 1PB;
        }
        elseif ($realSize -match "(.*)TB") {
            return ([float]$Matches[1]) * 1TB;
        }
        elseif ($realSize -match "(.*)GB") {
            return ([float]$Matches[1]) * 1GB;
        }
        elseif ($realSize -match "(.*)MB") {
            return ([float]$Matches[1]) * 1MB;
        }
        elseif ($realSize -match "(.*)kB") {
            return ([float]$Matches[1]) * 1KB;
        }
        else {
            return ([float]$Matches[1])
        }
    }
}