# Not idempotent - Run once on initial system setup
# Enable Windows Subsystems
Enable-WindowsOptionalFeature -Online -NoRestart -All -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -NoRestart -All -FeatureName VirtualMachinePlatform

# Default to WSL 2
wsl --set-default-version 2
#wsl --install -d "Ubuntu-20.04"
#winget install Canonical.Ubuntu.2204
#start the installer
#ubuntu2204
# requires interaction / setup

## Required reboot
