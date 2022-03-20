
# we will try to make a temporary symbolic link, if it is not successful then
# run the elevated REG command to enable developer mode

try {
    $tmp = New-Item -Type SymbolicLink -Name tmp -Target $Env:TEMP -ErrorAction Stop
    remove-item $tmp
}
catch [UnauthorizedAccessException]
{
    Write-Host "Attempting to enable developer mode, UAC prompt will appear..."
    # enable developer mode, which enables symlinking without admin creds
    $args = @(
        "add",
        "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock",
        "/t",
        "REG_DWORD",
        "/f",
        "/v",
        "AllowDevelopmentWithoutDevLicense",
        "/d",
        "1"
    )
    start-process -Wait -Verb runas reg -ArgumentList $args
}

# Check for and install git
# winget install Git.Git
# Check for and install powershell
$ps_installed = $(winget list --id Microsoft.Powershell)
if ($ps_installed -like "No installed package*") {
    winget install --id Microsoft.Powershell
}
