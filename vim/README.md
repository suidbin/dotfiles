# Vim Customizations / Notes

## Plugins / packs

This config is setup to use Vim 8+ native pack system and git submodules to
manage retrieving/loading plugins.

Off the `$XDG_CONFIG_HOME/vim/pack` directory, plugins / packs are organized
roughly as follows:

 * `plugins` - These are general vim plugins to be auto (`start` directory)
               or manually loaded (`opt` directory)
 * `colors` -  Where to put colorschemes/theming packs/plugins

### Adding a new one

    cd $XDG_CONFIG_HOME/vim/pack
    git submodule add <git_repo_link> plugins/start/<plugin_name>

### Loading an optional one

If the plugin is in an `opt` directory instead of a `start` directory, it will
not get auto loaded by Vim, and must be loaded manually instead, using the
`packadd` command.  For Example:

    :packadd tmuxline
    :helptags ALL

Issuing the `helptags ALL` command after loading a plugin will update the help
system with any documentation for that vim plugin.

