# Requires Powershell 6+ because of Join-Path taking multiple tokens
#Requires -Version 6

# This file is a sort of analog to shell/profile.  On Windows, we'll just set
# the variables in the User's environment and it is persisted to the registry

# Implementation Note: SetEnvironmentVariable is currently very slow, which is
# why I go through the trouble of checking whether it is set or not first
#
# See: https://superuser.com/questions/565771/

$envs = @{
    # Setup default directory environment variables that are more inline with
    # what is used on linux so that I can find them both in the same-ish spot
    # and in the same way
    XDG_CONFIG_HOME = Join-Path $Env:UserProfile .config
    XDG_CACHE_HOME = Join-Path $Env:UserProfile .cache
    XDG_DATA_HOME = Join-Path $Env:UserProfile .local share
    XDG_STATE_HOME = Join-Path $Env:UserProfile .local state

    # Configure pipenv to create virtual env's inside of the project directory
    PIPENV_VENV_IN_PROJECT=1

    # Custom Python startup file for interactive interpreter
    PYTHONSTARTUP = Join-Path $Env:UserProfile .config python startup.py

    # I prefer my user site-packages to more closely match the location seen on
    # linux: ~/.local, instead of %APPDATA%/Roaming/Python/Python310
    PYTHONUSERBASE = Join-Path $Env:UserProfile .local Python

    # This helps the python prompt-toolkit on windows terminal know that we
    # have true color enabled
    PROMPT_TOOLKIT_COLOR_DEPTH = "DEPTH_24_BIT"

    # We'll use pyenv to manage local python installations in ~/.local/pyenv
    PYENV =      Join-Path $Env:UserProfile .local pyenv pyenv-win
    PYENV_ROOT = Join-Path $Env:UserProfile .local pyenv pyenv-win
    PYENV_HOME = Join-Path $Env:UserProfile .local pyenv pyenv-win
}

if ($null -ne (Get-Command -ErrorAction Ignore nvim)) {
    $envs['VISUAL'] = "nvim.exe"
}

# Now set all environment variables if they don't exist or are set differently
$envs.GetEnumerator() | Where-Object {
    $_.value -ne $(Get-Item -ErrorAction Ignore -Path Env:$($_.key)).value } |
        ForEach-Object {
            Write-Host -ForegroundColor DarkRed -NoNewLine "Env:"$_.key
            Write-Host -NoNewLine -->
            Write-Host -ForegroundColor DarkGray $_.value
            [Environment]::SetEnvironmentVariable($_.key, $_.value, 'User')
            Set-Item -Path Env:$($_.key) -Value $_.value
        }
