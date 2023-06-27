# Not idempotent - Run once on initial system setup

Write-Verbose "Enabling Windows Defender Application Guard..."
Enable-WindowsOptionalFeature -Online -NoRestart -All -FeatureName Windows-Defender-ApplicationGuard
Write-Verbose "Enabling Windows Hyper-V..."
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

Add-LocalGroupMember -Group "Hyper-V Administrators" -Member $env:username

# Sandbox: Containers-DisposableClientVM
# Microsoft-Hyper-V-All
# HypervisorPlatform
