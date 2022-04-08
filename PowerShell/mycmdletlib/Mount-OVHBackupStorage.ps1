#!/bin/env pwsh

function Mount-OVHBackupStorage
{
<#
.SYNOPSIS
    Mount-OVHBackupStorage
.DESCRIPTION
	Attach OVH Backup Storage to /mnt/backup [Linux only]
.PARAMETER  HostName
	Hostname from OVH backup storage panel
.PARAMETER  ServiceName
	ServiceName from OVH backup storage panel
.EXAMPLE
	PS C:\> Mount-OVHBackupStorage ftpback-xxx0-000.ovh.net ns0000000.ip-000-000-000.eu
#>

	[CmdletBinding()]
	param(
		[Parameter(Position=0, Mandatory=$true)]
		[string]
		$HostName,
		[Parameter(Position=1, Mandatory=$true)]
		[string]
		$ServiceName
	)
    process {
		$isLinux = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux);
		if (!$isLinux) {
			Write-Host "This cmdlet is available only on Linux".
			return;
		}
		mkdir /mnt/backup
		mount -t nfs "${HostName}:/export/ftpbackup/${ServiceName}" /mnt/backup
    }
}