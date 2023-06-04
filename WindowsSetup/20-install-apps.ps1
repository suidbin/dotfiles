$options = [System.StringSplitOptions]::RemoveEmptyEntries
$installed = $(winget list -s winget).split(' ', $options)

function Install-WingetPackage {

    param (
        [string] $PackageId,
        $Options = ""
    )
    Write-Host -NoNewLine "Checking for package: "
    Write-Host -ForegroundColor Cyan -NoNewLine "$PackageId"
    Write-Host -NoNewLine "...."
    if ($installed -contains $PackageId) {
        Write-Host -ForegroundColor Green "Installed!"
        Return
    }

    Write-Host -ForegroundColor Red "Not Installed"
    & winget install --id $PackageId $Options
}

$packages = @{
    "Git.Git" = ""
    "Microsoft.VisualStudioCode" = @(
        "--override",
        "'/SILENT /mergetasks=""!runcode,addcontextmenufiles,addcontextmenufolders""'"
    )
#    "7zip.7zip" = ""
    "Google.Drive" = ""
#    "Quicken.Quicken" = ""
#    "Adobe.Acrobat.Reader.64-bit" = ""
#    "Microsoft.Nuget" = ""
#    "Hashicorp.Vagrant" = ""
#    " "
    "Valve.Steam" = ""
    "Neovim.Neovim" = ""
    "Hashicorp.Vagrant" = ""
}

$packages.GetEnumerator() | ForEach-Object {
    Install-WingetPackage $_.Name $_.Value
}

# update path in current session so you have access to code
$Env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
  ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
