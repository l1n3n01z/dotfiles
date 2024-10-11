# Dotfile Repo

#
This used to be a mishmash of config files. I am currently mostly using nix and home-manager to manage my config now.

For language servers I download them as nix packages.
For nvim I use the default home-manager neovim stuff, so plugins are just packages.
Then I use home-manager to copy ./nvim to ~/.config/nvim

In general, using nix, I don't need sdkman or nvm or any of that stuff. 
If I need specific versions of npm in a project, I will just setup a nix shell to provide the correct environment

Current terminal setup:
After wsltty started crashing again due to use of undocumented APIs I switched to windows terminal to host wsl2.
There don't seem to be any issues with it so far
(Actually I'm currently running the preview, as it has awesome support for sixel)

##Installation in the beginning of the year 2022

Windows terminal is excellent, it has support for true color and all sorts of niceness
~~Install neovim dev (document ppa:unstable), seems to be nightly builds
tmux, need to set utf-8 in .tmux.conf
Currently using stow for dotfiles, WIP. Works fine so far.~~

For regular WSL2 copying from neovim, need to install win32yank in host. 
Use scoop install win32yank

See init.vim for setup of clipboard
Note, explicitly setting g:clipboard cuts .5 seconds of nvim startup time
For copying from tmux, I may need to configure tmux-yank

