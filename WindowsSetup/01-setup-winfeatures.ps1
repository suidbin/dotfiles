# Not idempotent - Run once on initial system setup

Write-Verbose "Enabling Windows Defender Application Guard..."
Enable-WindowsOptionalFeature -Online -NoRestart -All -FeatureName Windows-Defender-ApplicationGuard
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
# Sandbox: Containers-DisposableClientVM
# Microsoft-Hyper-V-All
# HypervisorPlatform