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
##### Add needed libraries
$__LibAdmin = Join-Path $PSScriptRoot "Use-Administrator-Privilleges.ps1"
. $__LibAdmin
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
function Get-Status-Linux-Nala-Package-Manager {
    if ($_IsLinux) {
        if (Test-Command nala) {
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
function Get-Status-Linux-Pacstall-Package-Manager {
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
function Get-Status-Nix-Package-Manager {
    if ($_IsMacOS -or $_IsLinux) {
        if (Test-Command nix-env -and Test-Command nix-channel) {
            return $true
        }
    }
    return $false
}
### Install Package
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
function Install-Linux-Nala-Package($package) {
    if (Get-Status-Linux-Nala-Package-Manager) {
        nala install -y $package
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
function Install-Linux-Pacstall-Package($package) {
    if (Get-Status-Linux-Pacstall-Package-Manager) {
        pacstall -I $package
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
function Install-Mac-BrewCask-Package($package) {
    if (Get-Status-BrewCask-Package-Manager) {
        brew install --cask $package
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
function Install-Nix-Package($package) {
    if (Get-Status-Nix-Package-Manager) {
        nix-env -iA $package
        return $true
    }
    return $false
}
### Update Package Database
# WinGet don't have equivalent command
# Choco don't have equivalent command
# Scoop don't have equivalent command
function Update-Linux-Apt-Package-Database() {
    if (Get-Status-Linux-Apt-Package-Manager) {
        if (Test-Command apt)
        {
            apt update -y
        }
        else
        {
            apt-get update -y
        }
        return $true
    }
    return $false
}
function Update-Linux-Nala-Package-Database() {
    if (Get-Status-Linux-Nala-Package-Manager) {
        nala update -y
        return $true
    }
    return $false
}
# Yum don't have direct equivalent command
# Dnf don't have direct equivalent command
function Update-Linux-Pacman-Package-Database() {
    if (Get-Status-Linux-Pacman-Package-Manager) {
        pacman -Syy
        return $true
    }
    return $false
}
function Update-Linux-Apk-Package-Database() {
    if (Get-Status-Linux-Apk-Package-Manager) {
        apk update
        return $true
    }
    return $false
}
# Flatpak don't have equivalent command
# Snap don't have equivalent command
function Update-Brew-Package-Database() {
    if (Get-Status-Brew-Package-Manager) {
        brew update
        return $true
    }
    return $false
}
# Mas don't have equivalent command
function Update-Nix-Package-Database() {
    if (Get-Status-Nix-Package-Manager) {
        nix-channel --update
        return $true
    }
    return $false
}
### Update Package
function Update-Windows-WinGet-Package($package) {
    if (Get-Status-Windows-WinGet-Package-Manager) {
        winget upgrade --accept-source-agreements --accept-package-agreements $package
        return $true
    }
    return $false
}
function Update-Windows-Choco-Package($package) {
    if (Get-Status-Windows-Choco-Package-Manager) {
        choco upgrade -y $package
        return $true
    }
    return $false
}
function Update-Windows-Scoop-Package($package) {
    if (Get-Status-Windows-Scoop-Package-Manager) {
        scoop update $package
        return $true
    }
    return $false
}
function Update-Linux-Apt-Package($package) {
    if (Get-Status-Linux-Apt-Package-Manager) {
        if (Test-Command apt)
        {
            apt upgrade -y $package
        }
        else
        {
            apt-get upgrade -y $package
        }
        return $true
    }
    return $false
}
function Update-Linux-Nala-Package($package) {
    if (Get-Status-Linux-Nala-Package-Manager) {
        nala upgrade -y $package
        return $true
    }
    return $false
}
function Update-Linux-Yum-Package($package) {
    if (Get-Status-Linux-Yum-Package-Manager) {
        yum upgrade -y $package
        return $true
    }
    return $false
}
function Update-Linux-Dnf-Package($package) {
    if (Get-Status-Linux-Dnf-Package-Manager) {
        dnf upgrade -y $package
        return $true
    }
    return $false
}
function Update-Linux-Pacman-Package($package) {
    if (Get-Status-Linux-Pacman-Package-Manager) {
        pacman -Syu $package
        return $true
    }
    return $false
}
function Update-Linux-Pacstall-Package($package) {
    if (Get-Status-Linux-Pacstall-Package-Manager) {
        pacstall -Up $package
        return $true
    }
    return $false
}
function Update-Linux-Apk-Package($package) {
    if (Get-Status-Linux-Apk-Package-Manager) {
        apk upgrade $package
        return $true
    }
    return $false
}
function Update-Linux-Flatpak-Package($package) {
    if (Get-Status-Linux-Flatpak-Package-Manager) {
        flatpak update -y $package
        return $true
    }
    return $false
}
function Update-Linux-Snap-Package($package) {
    if (Get-Status-Linux-Snap-Package-Manager) {
        snap refresh $package
        return $true
    }
    return $false
}
function Update-Brew-Package($package) {
    if (Get-Status-Brew-Package-Manager) {
        brew upgrade $package
        return $true
    }
    return $false
}
function Update-Mac-BrewCask-Package($package) {
    if (Get-Status-BrewCask-Package-Manager) {
        brew upgrade --cask $package
        return $true
    }
    return $false
}
function Update-Mac-Mas-Package($package) {
    if (Get-Status-Mac-Mas-Package-Manager) {
        mas upgrade $package
        return $true
    }
    return $false
}
function Update-Nix-Package($package) {
    if (Get-Status-Nix-Package-Manager) {
        nix-env -uA $package
        return $true
    }
    return $false
}
### Remove Package
function Remove-Windows-WinGet-Package($package) {
    if (Get-Status-Windows-WinGet-Package-Manager) {
        winget uninstall --accept-source-agreements $package
        return $true
    }
    return $false
}
function Remove-Windows-Choco-Package($package) {
    if (Get-Status-Windows-Choco-Package-Manager) {
        choco uninstall -y $package
        return $true
    }
    return $false
}
function Remove-Windows-Scoop-Package($package) {
    if (Get-Status-Windows-Scoop-Package-Manager) {
        scoop uninstall $package
        return $true
    }
    return $false
}
function Remove-Linux-Apt-Package($package) {
    if (Get-Status-Linux-Apt-Package-Manager) {
        if (Test-Command apt)
        {
            apt remove -y $package
        }
        else
        {
            apt-get remove -y $package
        }
        return $true
    }
    return $false
}
function Remove-Linux-Nala-Package($package) {
    if (Get-Status-Linux-Nala-Package-Manager) {
        nala remove -y $package
        return $true
    }
    return $false
}
function Remove-Linux-Yum-Package($package) {
    if (Get-Status-Linux-Yum-Package-Manager) {
        yum remove -y $package
        return $true
    }
    return $false
}
function Remove-Linux-Dnf-Package($package) {
    if (Get-Status-Linux-Dnf-Package-Manager) {
        dnf remove -y $package
        return $true
    }
    return $false
}
function Remove-Linux-Pacman-Package($package) {
    if (Get-Status-Linux-Pacman-Package-Manager) {
        pacman -R $package
        return $true
    }
    return $false
}
function Remove-Linux-Pacstall-Package($package) {
    if (Get-Status-Linux-Pacstall-Package-Manager) {
        pacstall -R $package
        return $true
    }
    return $false
}
function Remove-Linux-Apk-Package($package) {
    if (Get-Status-Linux-Apk-Package-Manager) {
        apk del $package
        return $true
    }
    return $false
}
function Remove-Linux-Flatpak-Package($package) {
    if (Get-Status-Linux-Flatpak-Package-Manager) {
        flatpak uninstall -y $package
        return $true
    }
    return $false
}
function Remove-Linux-Snap-Package($package) {
    if (Get-Status-Linux-Snap-Package-Manager) {
        snap remove $package
        return $true
    }
    return $false
}
function Remove-Brew-Package($package) {
    if (Get-Status-Brew-Package-Manager) {
        brew uninstall $package
        return $true
    }
    return $false
}
function Remove-Mac-BrewCask-Package($package) {
    if (Get-Status-BrewCask-Package-Manager) {
        brew uninstall --cask $package
        return $true
    }
    return $false
}
function Remove-Mac-Mas-Package($package) {
    if (Get-Status-Mac-Mas-Package-Manager) {
        mas uninstall $package
        return $true
    }
    return $false
}
function Remove-Nix-Package($package) {
    if (Get-Status-Nix-Package-Manager) {
        nix-env --uninstall $package
        return $true
    }
    return $false
}
### Update All Packages
function Update-All-Windows-WinGet-Packages() {
    if (Get-Status-Windows-WinGet-Package-Manager) {
        winget upgrade --all
        return $true
    }
    return $false
}
function Update-All-Windows-Choco-Packages() {
    if (Get-Status-Windows-Choco-Package-Manager) {
        choco upgrade -y all
        return $true
    }
    return $false
}
function Update-All-Windows-Scoop-Packages() {
    if (Get-Status-Windows-Scoop-Package-Manager) {
        scoop update --all
        return $true
    }
    return $false
}
function Update-All-Linux-Apt-Packages() {
    if (Get-Status-Linux-Apt-Package-Manager) {
        if (Test-Command apt)
        {
            apt upgrade -y
            apt autoremove -y
        }
        else
        {
            apt-get upgrade -y
            apt-get autoremove -y;
        }
        return $true
    }
    return $false
}
function Update-All-Linux-Nala-Packages() {
    if (Get-Status-Linux-Nala-Package-Manager) {
        nala upgrade -y
        nala autoremove -y
        return $true
    }
    return $false
}
function Update-All-Linux-Yum-Packages() {
    if (Get-Status-Linux-Yum-Package-Manager) {
        yum upgrade -y
        return $true
    }
    return $false
}
function Update-All-Linux-Dnf-Packages() {
    if (Get-Status-Linux-Dnf-Package-Manager) {
        dnf upgrade -y
        return $true
    }
    return $false
}
function Update-All-Linux-Pacman-Packages() {
    if (Get-Status-Linux-Pacman-Package-Manager) {
        pacman -Syu
        return $true
    }
    return $false
}
function Update-All-Linux-Pacstall-Packages() {
    if (Get-Status-Linux-Pacstall-Package-Manager) {
        pacstall -Up
        return $true
    }
    return $false
}
function Update-All-Linux-Apk-Packages() {
    if (Get-Status-Linux-Apk-Package-Manager) {
        apk upgrade
        return $true
    }
    return $false
}
function Update-All-Linux-Flatpak-Packages() {
    if (Get-Status-Linux-Flatpak-Package-Manager) {
        flatpak update -y
        return $true
    }
    return $false
}
function Update-All-Linux-Snap-Packages() {
    if (Get-Status-Linux-Snap-Package-Manager) {
        snap refresh
        return $true
    }
    return $false
}
function Update-All-Brew-Packages() {
    if (Get-Status-Brew-Package-Manager) {
        brew update
        brew upgrade
        return $true
    }
    return $false
}
function Update-All-Mac-BrewCask-Packages() {
    if (Get-Status-BrewCask-Package-Manager) {
        brew update --cask
        brew upgrade --cask
        return $true
    }
    return $false
}
function Update-All-Mac-Mas-Packages() {
    if (Get-Status-Mac-Mas-Package-Manager) {
        mas upgrade
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
function Install-Nix-Package-Repository($repositoryName) {
    if (Get-Status-Nix-Package-Manager -eq $false) {
        return $false
    }
    switch ($repositoryName)
    {
        "nixos-unstable" {
            nix-channel --add https://nixos.org/channels/nixpkgs-unstable
            nix-channel --update
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
    [Switch] $LinuxNala,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxYum,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxDnf,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxPacman,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxPacstall,
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
    [Switch] $MacMas,
    [Parameter(Mandatory=$false)]
    [Switch] $Nix
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
    if ($LinuxNala) {
        if (Install-Linux-Nala-Package $package) {
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
    if ($LinuxPacstall) {
        if (Install-Linux-Pacstall-Package $package) {
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
        if (Install-Mac-BrewCask-Package $package) {
            return $true
        }
    }
    if ($MacMas) {
        if (Install-Mac-Mas-Package $package) {
            return $true
        }
    }
    if ($Nix) {
        if (Install-Nix-Package $package) {
            return $true
        }
    }
    return $false
}

function Update-System-Package-Database(
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxApt,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxNala,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxPacman,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxApk,
    [Parameter(Mandatory=$false)]
    [Switch] $Brew,
    [Parameter(Mandatory=$false)]
    [Switch] $BrewCask,
    [Parameter(Mandatory=$false)]
    [Switch] $Nix
) {
    $return = $true;
    if ($LinuxNala) {
        if (Update-Linux-Nala-Package-Database) {
            $return = $return -and $true
        } else {
            $return = $return -and $false
        }
    }
    if ($LinuxApt) {
        if (Update-Linux-Apt-Package-Database) {
            $return = $return -and $true
        } else {
            $return = $return -and $false
        }
    }
    if ($LinuxPacman) {
        if (Update-Linux-Pacman-Package-Database) {
            $return = $return -and $true
        } else {
            $return = $return -and $false
        }
    }
    if ($LinuxApk) {
        if (Update-Linux-Apk-Package-Database) {
            $return = $return -and $true
        } else {
            $return = $return -and $false
        }
    }
    if ($Brew) {
        if (Update-Brew-Package-Database) {
            $return = $return -and $true
        } else {
            $return = $return -and $false
        }
    }
    if ($Nix) {
        if (Update-Nix-Package-Database) {
            $return = $return -and $true
        } else {
            $return = $return -and $false
        }
    }
    return $return
}

function Update-System-Package(
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
    [Switch] $LinuxNala,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxYum,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxDnf,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxPacman,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxPacstall,
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
    [Switch] $MacMas,
    [Parameter(Mandatory=$false)]
    [Switch] $Nix
) {
    if ($WindowsWinGet) {
        if (Update-Windows-WinGet-Package $package) {
            return $true
        }
    }
    if ($WindowsChoco) {
        if (Update-Windows-Choco-Package $package) {
            return $true
        }
    }
    if ($WindowsScoop) {
        if (Update-Windows-Scoop-Package $package) {
            return $true
        }
    }
    if ($LinuxNala) {
        if (Update-Linux-Nala-Package $package) {
            return $true
        }
    }
    if ($LinuxApt) {
        if (Update-Linux-Apt-Package $package) {
            return $true
        }
    }
    if ($LinuxYum) {
        if (Update-Linux-Yum-Package $package) {
            return $true
        }
    }
    if ($LinuxDnf) {
        if (Update-Linux-Dnf-Package $package) {
            return $true
        }
    }
    if ($LinuxPacman) {
        if (Update-Linux-Pacman-Package $package) {
            return $true
        }
    }
    if ($LinuxPacstall) {
        if (Update-Linux-Pacstall-Package $package) {
            return $true
        }
    }
    if ($LinuxApk) {
        if (Update-Linux-Apk-Package $package) {
            return $true
        }
    }
    if ($LinuxFlatpak) {
        if (Update-Linux-Flatpak-Package $package) {
            return $true
        }
    }
    if ($LinuxSnap) {
        if (Update-Linux-Snap-Package $package) {
            return $true
        }
    }
    if ($Brew) {
        if (Update-Brew-Package $package) {
            return $true
        }
    }
    if ($BrewCask) {
        if (Update-Mac-BrewCask-Package $package) {
            return $true
        }
    }
    if ($MacMas) {
        if (Update-Mac-Mas-Package $package) {
            return $true
        }
    }
    if ($Nix) {
        if (Update-Nix-Package $package) {
            return $true
        }
    }
    return $false
}

function Remove-System-Package(
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
    [Switch] $LinuxNala,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxYum,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxDnf,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxPacman,
    [Parameter(Mandatory=$false)]
    [Switch] $LinuxPacstall,
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
    [Switch] $MacMas,
    [Parameter(Mandatory=$false)]
    [Switch] $Nix
) {
    if ($WindowsWinGet) {
        if (Remove-Windows-WinGet-Package $package) {
            return $true
        }
    }
    if ($WindowsChoco) {
        if (Remove-Windows-Choco-Package $package) {
            return $true
        }
    }
    if ($WindowsScoop) {
        if (Remove-Windows-Scoop-Package $package) {
            return $true
        }
    }
    if ($LinuxNala) {
        if (Remove-Linux-Nala-Package $package) {
            return $true
        }
    }
    if ($LinuxApt) {
        if (Remove-Linux-Apt-Package $package) {
            return $true
        }
    }
    if ($LinuxYum) {
        if (Remove-Linux-Yum-Package $package) {
            return $true
        }
    }
    if ($LinuxDnf) {
        if (Remove-Linux-Dnf-Package $package) {
            return $true
        }
    }
    if ($LinuxPacman) {
        if (Remove-Linux-Pacman-Package $package) {
            return $true
        }
    }
    if ($LinuxPacstall) {
        if (Remove-Linux-Pacstall-Package $package) {
            return $true
        }
    }
    if ($LinuxApk) {
        if (Remove-Linux-Apk-Package $package) {
            return $true
        }
    }
    if ($LinuxFlatpak) {
        if (Remove-Linux-Flatpak-Package $package) {
            return $true
        }
    }
    if ($LinuxSnap) {
        if (Remove-Linux-Snap-Package $package) {
            return $true
        }
    }
    if ($Brew) {
        if (Remove-Brew-Package $package) {
            return $true
        }
    }
    if ($BrewCask) {
        if (Remove-Mac-BrewCask-Package $package) {
            return $true
        }
    }
    if ($MacMas) {
        if (Remove-Mac-Mas-Package $package) {
            return $true
        }
    }
    if ($Nix) {
        if (Remove-Nix-Package $package) {
            return $true
        }
    }
    return $false
}

function Update-All-System-Packages() {
    Update-All-Windows-WinGet-Packages
    Update-All-Windows-Choco-Packages
    Update-All-Windows-Scoop-Packages

    Use-Administrator-Privilleges {
        if (Get-Status-Linux-Nala-Package-Manager)
        {
            Update-All-Linux-Nala-Packages
        }
        else
        {
            Update-All-Linux-Apt-Packages
        }
        Update-All-Linux-Yum-Packages
        Update-All-Linux-Dnf-Packages
        Update-All-Linux-Pacman-Packages
        Update-All-Linux-Pacstall-Packages
        Update-All-Linux-Apk-Packages
        Update-All-Linux-Flatpak-Packages
        Update-All-Linux-Snap-Packages
    }

    Update-All-Brew-Packages

    Update-All-Mac-BrewCask-Packages
    Update-All-Mac-Mas-Packages

    return $true
}