#!/usr/bin/env pwsh

######## Variables to bypass some things that PowerShell have
###### IsOS Variables first as reference to use in functions and as alternatives because Windows PowerShell (5.*) don't have them anyway [even windows one]
$_IsWindows = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Windows);
$_IsLinux = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::Linux);
$_IsMacOS = [System.Runtime.InteropServices.RuntimeInformation]::IsOSPlatform([System.Runtime.InteropServices.OSPlatform]::OSX);
###### Run Dependencies
$PreScriptPath = Join-Path $PSScriptRoot "alf_cmdletlib_dependencies.ps1"
. $PreScriptPath

######## Alf aliases Configuration

# all-groups
if (!$_IsWindows)
{
    <#
    .SYNOPSIS
    All Linux Groups
    #>
    function all-groups
    {
        [CmdletBinding()]
        param ()

        process {
            #cut -d: -f1 /etc/group | sort

            $groups = Get-Content -Path /etc/group
            $_groups = @()
            ForEach ($group in $groups)
            {
                $_groups = $_groups + ($group.Split(":") | Select-Object -First 1)
            }
            $_groups = $_groups | Sort-Object
            return $_groups
        }
    }
}

# cdp & c
function cdp {
    # cd ~/Projects; clear; pwd
    Set-Location ~/Projects;
    Clear-Host;
    Get-Location;
}

function c (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $Directory
) {
    #cd $1; clear; pwd
    Set-Location $Directory;
    Clear-Host;
    Get-Location;
}

# compare-dir: diff --brief -Nr
function compare-dir {
    diff --brief -Nr $args
}

# count: ls -1 ${1:-.} | wc -l
function count (
    [Parameter(Mandatory=$false, Position=0)]
    [String] $Directory
) {
    #ls -1 ${1:-.} | wc -l
    if([string]::IsNullOrWhiteSpace($Directory))
    {
       $Directory = "."
    }

    $ls = Get-ChildItem $Directory
    return $ls.Length
}

#cm: chmod $1 $2
#cmr: chmod $1 -R $2
function cm (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $NewPermission,
    [Parameter(Mandatory=$true, Position=1)]
    [String] $Directory
) {
    chmod $NewPermission $Directory
}

function cmr (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $NewPermission,
    [Parameter(Mandatory=$true, Position=1)]
    [String] $Directory
) {
    chmod -R $NewPermission $Directory
}

#co: chown $1 $2
#cor: chown $1 -R $2
function co (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $NewPermission,
    [Parameter(Mandatory=$true, Position=1)]
    [String] $Directory
) {
    chown $NewPermission $Directory
}

function cor (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $NewPermission,
    [Parameter(Mandatory=$true, Position=1)]
    [String] $Directory
) {
    chown -R $NewPermission $Directory
}

#d: docker
function d {
    $possible_alf_subalias, $pas_args = $args;

    switch ($possible_alf_subalias)
    {
        "psf" {
            docker ps --format "{{.ID}} {{.Names}}\t{{.Status}}  {{.Ports}}" $pas_args
        }
        "paf" {
            docker ps -a --format="table {{.Names}}\t{{.Status}}\t{{.ID}}" $pas_args
        }
        "p" {
            docker ps -a $pas_args
        }
        "clean" {
            docker system prune -f $pas_args
        }
        "deploy" {
            $1 = $pas_args[0];
            docker stack deploy -c $1.yml $1
        }
        "i" {
            docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $pas_args
        }
        "images" {
            docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}" $pas_args
        }
        "n" {
            docker network $pas_args
        }
        "rmi" {
            $1 = $pas_args[0];
            docker images --format "{{.Repository}}:{{.Tag}}" | Select-String -Pattern $1 | ForEach-Object { docker rmi -f $_ }
        }
        "rmv" {
            $1 = $pas_args[0];
            docker volume ls --format "{{.Name}}" | Select-String -Pattern $1 | ForEach-Object { docker volume rm -f $_ }
        }
        "v" {
            docker volume $pas_args
        }
        "r" {
            docker run -it --rm $pas_args
        }
        "replicas" {
            docker service ls --format='table {{.Name}}\t{{.Mode}}\t{{.Replicas}}' $pas_args
        }
        "s" {
            docker service $pas_args
        }
        "st" {
            docker stack $pas_args
        }
        "size" {
            #docker images --format '{{.Size}}\t{{.Repository}}:{{.Tag}}' | sort -h | column -t
            docker images --format="{{json .}}" |
                ConvertFrom-Json |
                Select-Object Size,@{Name='RealSize'; Expression={$_.Size | Convert-FromHumanReadableBytesBinary}},@{Name = 'Image'; Expression = {"{0}:{1}" -f $_.Repository,$_.Tag}} |
                Sort-Object RealSize |
                Select-Object Size,Image |
                Format-Table
        }
        "stats" {
            docker stats --format "{{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" $pas_args
        }
        Default {
            docker $args
        }
    }
}

#dc: docker-compose
function dc {
    $possible_alf_subalias, $pas_args = $args;

    switch ($possible_alf_subalias)
    {
        "ud" {
            docker-compose up -d $pas_args
        }
        "ub" {
            docker-compose up -d --build $pas_args
        }
        "ur" {
            docker-compose up -d --force-recreate $pas_args
        }
        "ubr" {
            docker-compose up -d --build --force-recreate $pas_args
        }
        "u" {
            docker-compose up $pas_args
        }
        "eb" {
            $1 = $pas_args[0];
            docker-compose exec $1 /bin/bash
        }
        "e" {
            $1 = $pas_args[0];
            $rest = $pas_args[1..($pas_args.Length-1)];
            docker-compose exec $1 $rest
        }
        "rb" {
            $1 = $pas_args[0];
            docker-compose run --rm $1 /bin/bash $pas_args
        }
        "r" {
            $1 = $pas_args[0];
            $rest = $pas_args[1..($pas_args.Length-1)];
            docker-compose run --rm $1 $rest
        }
        "d" {
            docker-compose down $pas_args
        }
        "sael" {
            $1 = $pas_args[0];
            docker-compose exec $1 cat /var/log/apache2/error.log
        }
        "stael" {
            $1 = $pas_args[0];
            docker-compose exec $1 tail -f /var/log/apache2/error.log
        }
        "lf" {
            docker-compose logs -f $pas_args
        }
        Default {
            docker-compose $args
        }
    }
}

# dclf: dc logs -f
function dclf {
    docker-compose logs -f $args
}

# dfh: df -H
function dfh {
    #df -H

    # This is PowerShell way made to work exactly like df -H

    return [System.IO.DriveInfo]::getdrives() |
        Select-Object @{Name='Filesystem'; Expression={$_.Name}},@{Name='Size'; Expression={Format-FileSize $_.TotalSize}},@{Name='Used'; Expression={Format-FileSize ($_.TotalSize - $_.AvailableFreeSpace)}},@{Name='Avail'; Expression={Format-FileSize $_.AvailableFreeSpace}},@{Name='Use%'; Expression={"{0:N2}%" -f ((($_.TotalSize - $_.AvailableFreeSpace)/$_.TotalSize)*100)}},@{Name='Mounted on'; Expression={$_.RootDirectory}} |
        Format-Table
}

# dfhd: df -H | grep -v -e "/dev/loop" -e "tmpfs" -e "udev"
function dfhd {
    #df -H | grep -v -e "/dev/loop" -e "tmpfs" -e "udev"

    # This is PowerShell way made to work exactly like df -H | grep -v -e "/dev/loop" -e "tmpfs" -e "udev"
    return [System.IO.DriveInfo]::getdrives() |
        Where-Object { $_.DriveFormat -NotMatch "tmpfs"} |
        Where-Object { $_.DriveFormat -NotMatch "udev"} |
        Select-Object @{Name='Filesystem'; Expression={$_.Name}},@{Name='Size'; Expression={Format-FileSize $_.TotalSize}},@{Name='Used'; Expression={Format-FileSize ($_.TotalSize - $_.AvailableFreeSpace)}},@{Name='Avail'; Expression={Format-FileSize $_.AvailableFreeSpace}},@{Name='Use%'; Expression={"{0:N2}%" -f ((($_.TotalSize - $_.AvailableFreeSpace)/$_.TotalSize)*100)}},@{Name='Mounted on'; Expression={$_.RootDirectory}} |
        Where-Object { $_.Filesystem -NotMatch "/dev/loop"} |
        Format-Table
}

# duh: du -ach
function duh {
    #du -ach
    $total_size=0
    Get-ChildItem $args |
        ForEach-Object {
            $filename = $_.FullName
            Get-ChildItem -File -Recurse $_.FullName |
                Measure-Object -Property length -Sum |
                ForEach-Object {
                    $total_size = $total_size + $_.Sum;
                    return $_
                } |
                Select-Object -Property @{Name="Name";Expression={$filename}},
                    @{Name="Size";Expression={Format-FileSize $_.Sum}}
        } | Format-Table
    Write-Host ("Total Size: {0}" -f (Format-FileSize $total_size))
}

# dps: d ps
function dps {
    docker ps
}

# dpsa: d ps -a
function dpsa {
    docker ps -a
}

#g: git
function g {
    $possible_alf_subalias, $pas_args = $args;

    switch ($possible_alf_subalias)
    {
        "s" {
            git status $pas_args
        }
        "l" {
            git log --all --graph --date=relative --pretty=format:'%h %Cgreen%ad%Creset %Cblue%an%Creset%n        %s%n       %C(auto)%d%Creset' $pas_args
        }
        "ll" {
            git log --graph --oneline --decorate --all $pas_args
        }
        "tail" {
            $1 = $pas_args[0];
            if ([string]::IsNullOrWhiteSpace($1)) {
                $1 = "-5"
            } else {
                $1 = "-{0}" -f $1
            }
            git log $1 --all --date=relative --pretty=format:'%h %Cgreen%ad%Creset %x09%Cblue%s%Creset' $pas_args
        }
        "c" {
            git add . --all
            if ($? -ne 0)
            {
                git commit -am $pas_args
            }
        }
        "p" {
            git push $pas_args
        }
        "m" {
            git merge $pas_args
        }
        "b" {
            git branch $pas_args
        }
        "d" {
            git diff $pas_args
        }
        "co" {
            git checkout $pas_args
        }
        "cp" {
            git cherry-pick $pas_args
        }
        "pl" {
            git pull $pas_args
        }
        "ls" {
            git ls-tree --full-name --name-only -r HEAD $pas_args
        }
        "chmod" {
            git update-index --chmod $pas_args
        }
        "compare" {
            $1 = $pas_args[0];
            git diff --stat --color $1..HEAD
        }
        "datelog" {
            git log --pretty=format:'%h %ad%x09%an%x09%s' --date=short $pas_args
        }
        "discard" {
            git checkout -- .
            git clean -fd $pas_args
        }
        "history" {
            git log -p $pas_args
        }
        "optimize" {
            git repack -ad

            if ($? -ne 0)
            {
                start-sleep -seconds 5
                git gc $pas_args
            }
        }
        "remote-delete" {
            git push origin --delete $pas_args
        }
        "rebuild" {
            git commit --allow-empty -m "trigger rebuild"
            git push $pas_args
        }
        "rename" {
            git branch -m $pas_args
        }
        "resolve-ours" {
            git checkout --ours .
            git add -u
            git commit -m 'resolve conflicts with --ours' $pas_args
        }
        "resolve-theirs" {
            git checkout --theirs .
            git add -u
            git commit -m 'resolve conflicts with --theirs' $pas_args
        }
        "rollback" {
            $1 = $pas_args[0];
            git revert --no-commit $1..HEAD
        }
        "shallow-clone" {
            git clone --depth 1 $pas_args
        }
        "upstream" {
            git checkout master
            if ($? -ne 0)
            {
                git fetch upstream
                if ($? -ne 0)
                {
                    git merge upstream/master $pas_args
                }
            }
        }
        "age" {
            # for d in ./*/; do echo -e "\n\e[34m$d\e[0m" ; git -C $d log -1 --all --date=relative --pretty=format:'%Cgreen%ad%Creset %x09%s%n' ; done;

            return Get-ChildItem -Directory ./ |
                ForEach-Object {
                    $name = $_.Name;
                    Write-Host -ForegroundColor Blue "./$name"
                    git -C $_.FullName log -1 --all --date=relative --pretty=format:'%Cgreen%ad%Creset %x09%s%n'
                }
        }
        Default {
            git $args
        }
    }
}

# gg: g p
function gg {
    git push $args
}

# ggt: gg && gg --tag
function ggt {
    git push
    if ($? -ne 0)
    {
        git push --tag $args
    }
}

# gpl: g pl
function gpl {
    git pull $args
}

# killport: [[ $(lsof -ti:$1) ]] && kill -9 $(lsof -ti:$1)
function killport (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $Port
) {
    if ($_isWindows) {
        return Get-Process -Id (Get-NetTCPConnection -LocalPort "$Port").OwningProcess | Stop-Process
    } else {
        $_Port = ":{0}" -f $Port
        return lsof "-ti$_Port" |
            ForEach-Object {
                Stop-Process -Id $_
            }
    }
}

# l: ls -lah
function l {
    Get-ChildItem -Force $args
}

# le: exa -lah
function le {
    exa -lah
}

# env: env (PowerShell exec)
function env {
    return Get-ChildItem Env:
}

# nv: env |grep -i
function nv (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $Pattern
) {
    return Get-ChildItem Env: | Where-Object { $_.Name | Select-String -Pattern $Pattern }
}

# psf: ps -ef |grep
function psf (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $Pattern
) {
    return Get-Process | Where-Object { $_.ProcessName | Select-String -Pattern $Pattern }
}

# py: python3
function py {
    python3 $args
}

# repeat: for i in `seq $1`; do ${@:2} ; done
function repeat (
    [Parameter(Mandatory=$true, Position=0)]
    [Int32] $RepeatNumber,
    [Parameter(Mandatory=$true, Position=1)]
    [PSObject] $RepeatBlock
) {
    (1..$RepeatNumber) | ForEach-Object $RepeatBlock
}

# Remove default alias r = Invoke-History
Remove-Alias -Name r -ErrorAction SilentlyContinue
# Add alias in place of r. ih as Invoke-History
New-Alias -Name ih -Value Invoke-History -ErrorAction SilentlyContinue

# r: clear; ${@:1}
function r (
    [Parameter(Mandatory=$false, Position=0)]
    [PSObject] $FunctionBlock
) {
    Clear-Host;
    if ($FunctionBlock)
    {
        Invoke-Command -ScriptBlock $FunctionBlock;
    }
}

# title: echo -ne "\033]0;${@:1}\007"
function title (
    [Parameter(Mandatory=$true, Position=0)]
    [String] $Title
) {
    $host.ui.RawUI.WindowTitle = $Title
}

# update: sudo apt update; sudo apt upgrade -y; sudo apt autoremove; brew update; brew upgrade; sudo snap refresh
function update {
    if ($_isLinux) {
        sudo apt update;
        sudo apt upgrade -y;
        sudo apt autoremove -y;
        brew update;
        brew upgrade;
        sudo snap refresh
    } elseif ($_IsMacOS) {
        brew update;
        brew upgrade;
    } elseif ($_IsWindows) {
        sudo choco upgrade all -y;
        scoop update -a
    } else {
        Write-Host -ForegroundColor Red "System is unsupported"
    }
}

# superlinter: sudo docker pull github/super-linter:latest; sudo docker run -e RUN_LOCAL=true -v $PWD:/tmp/lint github/super-linter
function superlinter {
    docker pull github/super-linter:latest;
    docker run -e RUN_LOCAL=true -v "${PWD}:/tmp/lint" github/super-linter
}

# ver: lsb_release -drc
function ver {
    neofetch
}

# p: pwbs
function p {
    pwbs $args
}

# y: yarn
function y {
    yarn $args
}

# n: npm
function n {
    npm $args
}

# v: nvim
function v {
    nvim $args
}

# loop_infinite: while true; do ${@:1}; sleep 1; done
function loop_infinite (
    [Parameter(Mandatory=$true, Position=0)]
    [PSObject] $RepeatBlock
) {
    while ($true)
    {
        Invoke-Command -ScriptBlock $RepeatBlock;
    }
}

# which_package: dpkg -S ${@:1}
if ($_IsLinux) {
    function which_package {
        dpkg -S $args
    }
}

# w: echo "starting watcher";
#   dfh: for ((i=1; i>0; i+=1)); do r dfh; echo "Rendered $i time"; sleep 1; done
#   odc-ps: for ((i=1; i>0; i+=1)); do r odc ps; echo "Rendered $i time"; sleep 1;done
#   dc-ps: for ((i=1; i>0; i+=1)); do r dc ps; echo "Rendered $i time"; sleep 1; done
#   ls: for((i=1; i>0; i+=1)); do r ls -lah; echo "Rendered $i time"; sleep 1; done
function w {
    $possible_alf_subalias, $pas_args = $args;

    Write-Host "Starting Watcher";
    switch ($possible_alf_subalias)
    {
        "dfh" {
            for ($i = 1; $i -gt 0; $i++) {
                Clear-Host;
                dfh $pas_args;
                Write-Host "Rendered $i time";
                Start-Sleep 1;
            }
        }
        "odc-ps" {
            # Might not work
            for ($i = 1; $i -gt 0; $i++) {
                Clear-Host;
                op dc ps $pas_args;
                Write-Host "Rendered $i time";
                Start-Sleep 1;
            }
        }
        "dc-ps" {
            for ($i = 1; $i -gt 0; $i++) {
                Clear-Host;
                dc ps $pas_args;
                Write-Host "Rendered $i time";
                Start-Sleep 1;
            }
        }
        "ls" {
            for ($i = 1; $i -gt 0; $i++) {
                Clear-Host;
                l $pas_args;
                Write-Host "Rendered $i time";
                Start-Sleep 1;
            }
        }
        Default {
            for ($i = 1; $i -gt 0; $i++) {
                Clear-Host;
                Invoke-Command -ScriptBlock $args;
                Write-Host "Rendered $i time";
                Start-Sleep 1;
            }
        }
    }
}