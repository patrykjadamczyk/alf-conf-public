#!/bin/env pwsh

function Convert-FromHumanReadableBytes {
    Param
    (
        [Parameter(
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$size
    )
    Process {
        $PB = [Math]::Pow(10, 15);
        $TB = [Math]::Pow(10, 12);
        $GB = [Math]::Pow(10, 9);
        $MB = [Math]::Pow(10, 6);
        $KB = [Math]::Pow(10, 3);

        $realSize = $size -replace " ", ""
        if ($realSize -match "(.*)PB") {
            return ([float]$Matches[1]) * $PB;
        }
        elseif ($realSize -match "(.*)TB") {
            return ([float]$Matches[1]) * $TB;
        }
        elseif ($realSize -match "(.*)GB") {
            return ([float]$Matches[1]) * $GB;
        }
        elseif ($realSize -match "(.*)MB") {
            return ([float]$Matches[1]) * $MB;
        }
        elseif ($realSize -match "(.*)kB") {
            return ([float]$Matches[1]) * $KB;
        }
        else {
            return ([float]$Matches[1])
        }
    }
}