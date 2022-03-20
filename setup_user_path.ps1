# -------------------
# Setup user paths
# -------------------
$userpath = [Environment]::GetEnvironmentVariable('Path', 'User')
$update_userenv = $false

# Ask python for the user site-packages, and from there we know where --user
# install scripts will go, so we can add that to the path
$usersite = $(python -c "import site; print(site.getusersitepackages())")
# ex: ~/.local/Python/Python310/Scripts
$userscripts = $usersite | Split-Path | Join-Path -ChildPath "Scripts"
# ~/.local/bin
$local_bin = Join-Path $Env:UserProfile .local | Join-Path -ChildPath bin
# ex: ~/.local/pyenv/pyenv-win/bin
$pyenvshims = Join-Path $Env:PYENV bin
# ex: ~/.local/pyenv/pyenv-win/bin
$pyenvbin = Join-Path $Env:PYENV shims

# Array of entries to add
$pathstoadd = @( $userscripts, $local_bin, $pyenvshims, $pyenvbin )

foreach ($new in $pathstoadd) {
    if (-not $userpath.Contains($new+';')) {
        Write-Host -ForegroundColor DarkRed -NoNewLine "Add to User Path:"
        Write-Host -ForegroundColor DarkGray $new
        $userpath = $new + ";" + $userpath
        $update_userenv = $true
        Set-Item -Path Env:Path -Value $($new + ';' + $Env:Path)
    }
}

# Persist to user registry
if ($update_userenv) {
    [Environment]::SetEnvironmentVariable('Path', $userpath, 'User')
}
