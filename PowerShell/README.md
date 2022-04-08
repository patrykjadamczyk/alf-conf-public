# Welcome to my PowerShell Collection of aliases,functions and other things
## How to use ?
Just load Index.ps1
```powershell
. ./Index.ps1
```
## Tested on
### PowerShell
**PowerShell Version**: PowerShell Core 7.2.2
### Operating Systems
- Windows 10
- Ubuntu 18.04 LTS on Windows 10 (Windows Subsystem for Linux)
- Linux Mint 20
## Highlights of this collection
### `mycmdletlib/Package-Manager.ps1`
This is my small library for making easy package management.
Its goal is to have easy arguments and have easy option to install packages in all OSes.
This small library was made mainly for my small AutoConfigurator Project that I'm working on.
AutoConfigurator project is set of PowerShell scripts for trying to automate full configuration process of machines.
### `alf/alf_conf.ps1`
This is my port of my alf configuration. Alf generates aliases for bash. I tried to recreate most of my aliases.
Some I didn't recreate because I didn't need them, or they were a bit complicated to make in PowerShell mainly if I wanted to make them super cross-platform.
## Notes about Warnings
### Why I'm getting `Warning! Check-SSLCertificate is added only once as type. Changes of it after reloading of profile file will not apply to same session!` warning on load of this collection ?
This is note for me and to anyone who would want to change something in this function.
If you develop new function in powershell you can override it without problems and your changes to its code will apply.
But for C# code which is used in Check-SSLCertificate can be loaded only once.
So if you want to test your changes to it's code you have to get new instance of powershell and load it there for testing.