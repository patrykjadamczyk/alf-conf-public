#!/usr/bin/env pwsh
# Run Docker Shell Image
function Run-DockerShellImage (
    [Parameter(Mandatory=$false, Position=0)]
    [string] $Distribution = "ubuntu",
    [Parameter(Mandatory=$false, Position=1)]
    [string] $Shell = "bash"
) {
    if ($Distribution -eq "ubuntu") {
        docker pull "ubuntu:latest";
        docker run -it --rm -v "$PWD`:/pwd" "ubuntu:latest" $Shell
    } elseif ($Distribution -eq "debian") {
        docker pull "debian:latest";
        docker run -it --rm -v "$PWD`:/pwd" "debian:latest" $Shell
    } elseif ($Distribution -eq "arch") {
        docker pull "archlinux:latest";
        docker run -it --rm -v "$PWD`:/pwd" "archlinux:latest" $Shell
    } elseif ($Distribution -eq "brew" -or $Distribution -eq "macos") {
        docker pull "homebrew/brew:latest";
        docker run -it --rm -v "$PWD`:/pwd" "homebrew/brew:latest" $Shell
    } elseif ($Distribution -eq "alpine") {
        docker pull "alpine:latest";
        docker run -it --rm -v "$PWD`:/pwd" "alpine:latest" $Shell
    } elseif ($Distribution -eq "centos" -or $Distribution -eq "centos7") {
        docker pull "centos:7";
        docker run -it --rm -v "$PWD`:/pwd" "centos:7" $Shell
    } elseif ($Distribution -eq "centos8") {
        docker pull "centos:8";
        docker run -it --rm -v "$PWD`:/pwd" "centos:8" $Shell
    } elseif ($Distribution -eq "fedora") {
        docker pull "fedora:latest";
        docker run -it --rm -v "$PWD`:/pwd" "fedora:latest" $Shell
    } elseif ($Distribution -eq "superlinter") {
        docker pull github/super-linter:latest;
        docker run -e RUN_LOCAL=true -v "${PWD}:/tmp/lint" github/super-linter
    } else {
        docker pull $Distribution;
        docker run -it --rm -v "$PWD`:/pwd" $Distribution $Shell
    }
}
