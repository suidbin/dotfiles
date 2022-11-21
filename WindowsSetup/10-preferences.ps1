# Idempotent - Script can run multiple times without issue
$theme = "$Env:windir\resources\themes\themeb.theme"
if (Test-Path $theme) {
   Write-Verbose "Selecting theme... $theme"
   & $theme
   Start-Sleep 3
   # Installing / Selecting that theme causes the settings window to come up
   Write-Verbose "Closing settings window..."
   Get-Process -Name SystemSettings | Stop-Process
}

Write-Verbose "Turning on dark mode for apps..."
Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize `
    -Name AppsUseLightTheme -Value 0 -Type Dword -Force

Write-Verbose "Enable: Display hidden and protected files..."
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name Hidden -Type DWord -Value 1
Write-Verbose "Enable: Show file extensions..."
Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Type DWord -Value 0

