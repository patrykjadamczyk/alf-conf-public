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

function Format-FileSize{
	[CmdletBinding()]
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[long]
		$Size
	)
    process {
        $PB = [Math]::Pow(10,15);
        $TB = [Math]::Pow(10,12);
        $GB = [Math]::Pow(10,9);
        $MB = [Math]::Pow(10,6);
        $KB = [Math]::Pow(10,3);

        If($Size -gt $PB) {return [string]::Format("{0:0.00} PB", $size / $PB)}
        ElseIf($Size -gt $TB) {return [string]::Format("{0:0.00} TB", $size / $TB)}
        ElseIf($Size -gt $GB) {return [string]::Format("{0:0.00} GB", $size / $GB)}
        ElseIf($Size -gt $MB) {return [string]::Format("{0:0.00} MB", $size / $MB)}
        ElseIf($Size -gt $KB) {return [string]::Format("{0:0.00} kB", $size / $KB)}
        ElseIf($Size -gt 0)   {return [string]::Format("{0:0.00} B", $size)}
        Else{return ""}
    }
}