#!/usr/bin/env pwsh
#### Needed Cmdlets and Variables
$_IsWindows = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows);
$_IsLinux = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux);
$_IsMacOS = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX);
function Test-Command($command) {
    try {
        if (Get-Command $command -ErrorAction Stop) {
            return $true
        }
    } catch {}
    return $false
}
function Test-IsWSL {
    if ($_IsLinux) {
        if (Test-Path /proc/version) {
            $procVersion = Get-Content /proc/version
            if ($procVersion -match "Microsoft")
            {
                return $true
            }
        }
    }
    return $false
}
#### Package Managers
function Get-Status-Windows-WinGet-Package-Manager {
    if ($_IsWindows) {
        if (Test-Command winget) {
            return $true
        }
    }
    return $false
}
function Get-Status-Windows-Choco-Package-Manager {
    if ($_IsWindows) {
        if (Test-Command choco) {
            return $true
        }
    }
    return $false
}
function Get-Status-Windows-Scoop-Package-Manager {
    if ($_IsWindows) {
        if (Test-Command scoop) {
            return $true
        }
    }
    return $false
}
function Get-Status-Linux-Apt-Package-Manager {
    if ($_IsLinux) {
        if (Test-Command apt) {
            return $true
        }
        elseif (Test-Command apt-get)
        {
            return $true
        }
    }
    return $false
}
function Get-Status-Linux-Yum-Package-Manager {
    if ($_IsLinux) {
        if (Test-Command yum) {
            return $true
        }
    }
    return $false
}
function Get-Status-Linux-Dnf-Package-Manager {
    if ($_IsLinux) {
        if (Test-Command dnf) {
            return $true
        }
    }
    return $false
}
function Get-Status-Linux-Pacman-Package-Manager {
    if ($_IsLinux) {
        if (Test-Command pacman) {
            return $true
        }
    }
    return $false
}
function Get-Status-Linux-Apk-Package-Manager {
    if ($_IsLinux) {
        if (Test-Command apk) {
            return $true
        }
    }
    return $false
}
function Get-Status-Linux-Flatpak-Package-Manager {
    if ($_IsLinux) {
        if (Test-Command flatpak) {
            return $true
        }
    }
    return $false
}
function Get-Status-Linux-Snap-Package-Manager {
    if (Test-IsWSL) {
        return $false # WSL don't support snap
    }
    if ($_IsLinux) {
        if (Test-Command snap) {
            return $true
        }
    }
    return $false
}
function Get-Status-Brew-Package-Manager {
    if ($_IsLinux -or $_IsMacOS) {
        if (Test-Command brew) {
            return $true
        }
    }
    return $false
}
function Get-Status-BrewCask-Package-Manager {
    if ($_IsMacOS) {
        if (Test-Command brew) {
            return $true
        }
    }
    return $false
}
function Get-Status-Mac-Mas-Package-Manager {
    if ($_IsMacOS) {
        if (Test-Command mas) {
            return $true
        }
    }
    return $false
}
### Install
function Install-Windows-WinGet-Package($package) {
    if (Get-Status-Windows-WinGet-Package-Manager) {
        winget install --accept-source-agreements --accept-package-agreements $package
        return $true
    }
    return $false
}
function Install-Windows-Choco-Package($package) {
    if (Get-Status-Windows-Choco-Package-Manager) {
        choco install -y $package
        return $true
    }
    return $false
}
function Install-Windows-Scoop-Package($package) {
    if (Get-Status-Windows-Scoop-Package-Manager) {
        scoop install $package
        return $true
    }
    return $false
}
function Install-Linux-Apt-Package($package) {
    if (Get-Status-Linux-Apt-Package-Manager) {
        if (Test-Command apt)
        {
            apt install -y $package
        }
        else
        {
            apt-get install -y $package
        }
        return $true
    }
    return $false
}
function Install-Linux-Yum-Package($package) {
    if (Get-Status-Linux-Yum-Package-Manager) {
        yum install -y $package
        return $true
    }
    return $false
}
function Install-Linux-Dnf-Package($package) {
    if (Get-Status-Linux-Dnf-Package-Manager) {
        dnf install -y $package
        return $true
    }
    return $false
}
function Install-Linux-Pacman-Package($package) {
    if (Get-Status-Linux-Pacman-Package-Manager) {
        pacman -Syu $package
        return $true
    }
    return $false
}
function Install-Linux-Apk-Package($package) {
    if (Get-Status-Linux-Apk-Package-Manager) {
        apk add $package
        return $true
    }
    return $false
}
function Install-Linux-Flatpak-Package($package) {
    if (Get-Status-Linux-Flatpak-Package-Manager) {
        flatpak install -y $package
        return $true
    }
    return $false
}
function Install-Linux-Snap-Package($package) {
    if (Get-Status-Linux-Snap-Package-Manager) {
        snap install $package
        return $true
    }
    return $false
}
function Install-Brew-Package($package) {
    if (Get-Status-Brew-Package-Manager) {
        brew install $package
        return $true
    }
    return $false
}
function Install-Mac-Mas-Package($package) {
    if (Get-Status-Mac-Mas-Package-Manager) {
        mas install $package
        return $true
    }
    return $false
}

# Helpers
function Install-Linux-Pacman-Package-Repository($repositoryName) {
    if (Get-Status-Linux-Pacman-Package-Manager -eq $false) {
        return $false
    }
    switch ($repositoryName)
    {
        "apache2-tools" {
            # This is example for apache bench and other tools to add repos for arch

            # If Testing repo enabled in system
            '[ownstuff-testing]' >> /etc/pacman.conf
            'Server = https://ftp.f3l.de/~martchus/$repo/os/$arch' >> /etc/pacman.conf
            'Server = https://martchus.no-ip.biz/repo/arch/$repo/os/$arch' >> /etc/pacman.conf
            Write-Host >> /etc/pacman.conf

            # General
            '[ownstuff]' >> /etc/pacman.conf
            'Server = https://ftp.f3l.de/~martchus/$repo/os/$arch' >> /etc/pacman.conf
            'Server = https://martchus.no-ip.biz/repo/arch/$repo/os/$arch' >> /etc/pacman.conf

            # GPG Keys
            pacman-key --recv-keys B9E36A7275FC61B464B67907E06FE8F53CDC6A4C # import key
            pacman-key --finger    B9E36A7275FC61B464B67907E06FE8F53CDC6A4C # verify fingerprint
            pacman-key --lsign-key B9E36A7275FC61B464B67907E06FE8F53CDC6A4C # sign imported key locally
            pacman-key --delete    B9E36A7275FC61B464B67907E06FE8F53CDC6A4C # if not wanted anymore: delete key again
        }
        Default {
            return $false
        }
    }
}

# Main Function
function Install-System-Package(
    [Parameter(Mandatory=$true, Position=0)]
    [String] $package,
    [Parameter(Mandatory=$false)]
    [Switch] $WindowsWinGet,
    [Parameter(Mandatory=$false)]
    [Switch] $WindowsChoco,
    [Parameter(Mandatory=$false)]
    [Switch] $WindowsScoop,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxApt,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxYum,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxDnf,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxPacman,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxApk,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxFlatpak,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxSnap,
    [Parameter(Mandatory=$false)]
    [Switch] $Brew,
    [Parameter(Mandatory=$false)]
    [Switch] $BrewCask,
    [Parameter(Mandatory=$false)]
    [Switch] $MacMas
) {
    if ($WindowsWinGet) {
        if (Install-Windows-WinGet-Package $package) {
            return $true
        }
    }
    if ($WindowsChoco) {
        if (Install-Windows-Choco-Package $package) {
            return $true
        }
    }
    if ($WindowsScoop) {
        if (Install-Windows-Scoop-Package $package) {
            return $true
        }
    }
    if ($LinuxApt) {
        if (Install-Linux-Apt-Package $package) {
            return $true
        }
    }
    if ($LinuxYum) {
        if (Install-Linux-Yum-Package $package) {
            return $true
        }
    }
    if ($LinuxDnf) {
        if (Install-Linux-Dnf-Package $package) {
            return $true
        }
    }
    if ($LinuxPacman) {
        if (Install-Linux-Pacman-Package $package) {
            return $true
        }
    }
    if ($LinuxApk) {
        if (Install-Linux-Apk-Package $package) {
            return $true
        }
    }
    if ($LinuxFlatpak) {
        if (Install-Linux-Flatpak-Package $package) {
            return $true
        }
    }
    if ($LinuxSnap) {
        if (Install-Linux-Snap-Package $package) {
            return $true
        }
    }
    if ($Brew) {
        if (Install-Brew-Package $package) {
            return $true
        }
    }
    if ($BrewCask) {
        if (Get-Status-BrewCask-Package-Manager)
        {
            if (Install-Brew-Package $package) {
                return $true
            }
        }
    }
    if ($MacMas) {
        if (Install-Mac-Mas-Package $package) {
            return $true
        }
    }
    return $false
}