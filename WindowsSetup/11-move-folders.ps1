# Idempotent - Script can run multiple times without issue
## Change the Downloads/Videos/Music Directories/Libraries
## My Music --> OneDrive\Music
## My Videos --> OneDrive\Videos
## Downloads --> d:\downloads

$userFolders = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
$shellFolders = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"

# Examining existing shell folders:
#   Get-ItemProperty -Path  $userFolders -Name "My Music"

# Downloads
$downloads = new-item -Type Directory -Force d:\downloads
Write-Verbose "Updating ""Downloads"" --> $downloads"
Set-ItemProperty -Path  $userFolders `
    -Name "{374DE290-123F-4565-9164-39C4925E467B}" -Value $downloads
Set-ItemProperty -Path  $shellFolders `
    -Name "{374DE290-123F-4565-9164-39C4925E467B}" -Value $downloads
#after doing the GUI Move of Downloads, this guid popped up in User Shell Folders
# They are mentioned in this article:
#  https://www.winhelponline.com/blog/windows-10-shell-folders-paths-defaults-restore/
# And it take precedence over Local Downloads.
Set-ItemProperty -Path  $userFolders `
    -Name "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}" -Value $downloads

# Music - Move to Onedrive
$music = "$Env:OneDrive\Music"
if (Test-Path $music) {
    Write-Verbose "Updating ""My Music"" --> $music"
    Set-ItemProperty -Path $userFolders -Name "My Music" -Value $music
    Set-ItemProperty -Path $shellFolders -Name "My Music" -Value $music
    Set-ItemProperty -Path $userFolders `
        -Name "{A0C69A99-21C8-4671-8703-7934162FCF1D}" -Value $music
}

# Videos - Move to Onedrive
$video = "$Env:OneDrive\Videos"
if (Test-Path $video) {
    Write-Verbose "Updating ""My Videos"" --> $video"
    Set-ItemProperty -Path $userFolders -Name "My Video" -Value $video
    Set-ItemProperty -Path $shellFolders -Name "My Video" -Value $video
    Set-ItemProperty -Path $userFolders `
        -Name "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}" -Value $video
}

Write-Verbose "Restarting explorer for new shell folder settings..."
taskkill /f /im explorer.exe ; Start-Sleep 1 ; start explorer.exe