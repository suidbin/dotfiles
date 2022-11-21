
# Idempotent - Script can run multiple times, but will popup a
# window and confirm overwriting.

# Downloads the fira code nerd fonts from github and installs them
$weights = @(
    "Bold", "Light", "Medium", "Regular", "SemiBold"
)

$tag = "v2.2.2"
$nf_url = "https://github.com/ryanoasis/nerd-fonts/raw/"

# see https://github.com/ryanoasis/nerd-fonts/blob/master/install.ps1
Write-Verbose "Creating Font COM Object"
$shellApp = New-Object -ComObject shell.application
$fonts = $shellApp.NameSpace(0x14)

foreach ($weight in $weights) {
    $font_path = "/patched-fonts/FiraCode/$weight/complete/"
    $font_file = "Fira Code $weight Nerd Font Complete Windows Compatible.ttf"
    $dl_uri =  $nf_url + $tag + $font_path + [uri]::EscapeDataString($font_file)

    Write-Verbose "Downloading Nerd Font @ $dl_uri"
    Invoke-WebRequest -Uri $dl_uri -OutFile $font_file

    $downloaded = Get-ChildItem $font_file

    $fonts.CopyHere($downloaded.FullName)

    Remove-Item $downloaded    
}



