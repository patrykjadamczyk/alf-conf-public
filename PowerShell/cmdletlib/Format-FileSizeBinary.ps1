#!/bin/env pwsh
# Changed to support petabytes
# Code from: https://github.com/janikvonrotz/PowerShell-PowerUp/blob/master/functions/PowerShell/Format-FileSize.ps1


<#
$Metadata = @{
	Title = "Format File Size Binary"
	Filename = "Format-FileSizeBinary.ps1"
	Description = ""
	Tags = "powershell, function, format, file, size"
	Project = ""
	Author = "Janik von Rotz"
	AuthorContact = "http://janikvonrotz.ch"
	CreateDate = "2013-11-14"
	LastEditDate = "2013-11-14"
	Url = ""
	Version = "1.0.0"
	License = @'
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Switzerland License.
To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ch/ or
send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.
'@
}
#>

function Format-FileSizeBinary{

<#
.SYNOPSIS
    Format FileSizeBinary.
.DESCRIPTION
	Format FileSizeBinary.
.PARAMETER  Size
	Integer to format.
.EXAMPLE
	PS C:\> Format-FileSizeBinary 10000
    9.77 kB
#>

	[CmdletBinding()]
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[long]
		$Size
	)

    #--------------------------------------------------#
    # main
    #--------------------------------------------------#
    If($Size -gt 1PB) {return [string]::Format("{0:0.00} PB", $size / 1PB)}
    ElseIf($Size -gt 1TB) {return [string]::Format("{0:0.00} TB", $size / 1TB)}
    ElseIf($Size -gt 1GB) {return [string]::Format("{0:0.00} GB", $size / 1GB)}
    ElseIf($Size -gt 1MB) {return [string]::Format("{0:0.00} MB", $size / 1MB)}
    ElseIf($Size -gt 1KB) {return [string]::Format("{0:0.00} kB", $size / 1KB)}
    ElseIf($Size -gt 0)   {return [string]::Format("{0:0.00} B", $size)}
    Else{return ""}
}# function end