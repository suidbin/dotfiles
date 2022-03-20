$ErrorActionPreference = "Stop"

$CONFIG = "install-win.conf.yaml"
$DOTBOT_DIR = "dotbot"

$DOTBOT_BIN = "bin/dotbot"
$BASEDIR = $PSScriptRoot

Push-Location $BASEDIR
& .\setup_env_win.ps1
& .\setup_python.ps1
& .\setup_user_path.ps1

git -C $DOTBOT_DIR submodule sync --quiet --recursive
git submodule update --init --recursive $DOTBOT_DIR

&python $(Join-Path $BASEDIR $DOTBOT_DIR $DOTBOT_BIN) -d $BASEDIR -c $CONFIG $Args
Pop-Location