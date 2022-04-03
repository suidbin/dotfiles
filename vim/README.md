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
