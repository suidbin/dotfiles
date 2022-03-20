
$pyenv_bin = Join-Path $Env:PYENV_HOME bin
$pyenv_shims = Join-Path $Env:PYENV_HOME shims
Set-Item -Path Env:Path -Value $($pyenv_bin + ';' + $Env:Path)
Set-Item -Path Env:Path -Value $($pyenv_shims + ';' + $Env:Path)

# check for pyenv command
if ($null -eq (Get-Command -ErrorAction Ignore pyenv)) {
    $pyenv_clone_dir = Split-Path $Env:PYENV_HOME

    if (-not (Test-Path $pyenv_clone_dir)) {
        git clone https://github.com/pyenv-win/pyenv-win.git $pyenv_clone_dir
    }
}

# check for global python set by pyenv
if ($(pyenv global) -like "*no global*") {

    $avail = $(pyenv versions --bare) | select -First 1
    if (-not $avail) {
        # update pyenv's list of available pythons from the internet
        pyenv update

        # get versions with no win32 or alpha/beta/release candidates
        $versions = $(pyenv install --list)
        $latest = $versions -match "\d+\.\d+\.\d+$" | Select-Object -Last 1
        pyenv install -q $latest
        $avail = $latest
    }

    pyenv global $avail
}
