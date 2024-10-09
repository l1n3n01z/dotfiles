# Dotfile Repo


Trying to manage dotfiles accross different locations and operating systems. Vim as a superb C++ editor on Windows is a top priority, along with colorschemes and sensible terminal setup.

##Installation

###Windows

What follows is a loose collection of thoughts. Work in progress.
All of this is outdated. Just use WSL2 and windows terminal

~~Windows is not well supported. Babun is a very nice environment, but it's a 32 bit environment so it doesn't support YouCompleteMe. BashOnWindows is pretty nice as well, being more or less a Linux, but the color/italics etc support is attrocious.  Ansi escape sequences are automagically converted in the console, meaning that far better consoles like ConEmu don't get any ANSI escape sequences to work with. Also, being a linux makes it not very well suited to building for Windows. 

For me, good syntax coloring is pretty high on the list of things that make C++ coding easier and more pleasant for me.

Things that support good coloring schemes:
Windows Vim in ConEmu can support 256 colors + a changed system palette, bold and italics. Unfortunately there doesn't seem to be anyway to change the 256 color palette. Though to be honest, it's not that well supported in most Linux terminals either.

GVim supports true color for vim, i.e. if the colorscheme sets a specific rgb color, that exact color will be displayed in GVim. One solution that might be viable would be to run GVim inside of ConEmu, and use ConEmu as a poor man's tmux.

There are a couple of plugins that have a compiled component. color_coded needs to be compiled with GCC. YouCompleteMe can be compiled with msvc but needs CMake etc. Some of Shougo's plugins need compilation as well. 

Note: According to the documentation YCM requires a 64 bit environment for running. So unfortunately that rules out using babun as a linux-like environment. I've settled on using MSYS2.

Start by installing MSYS2 according to the instructions: [MSYS2](https://msys2.github.io/)
Get the development tools. Accept defaults, i.e. install all pacakages, because why not.~~
```
pacman -S --noconfirm base-devel 
pacman -S clang
```

##Inspiration
 - [Mike Hartington's Dotfiles](https://github.com/mhartington/dotfiles)

##Todo
 Checkout [The ultimate Vim configuration on Github](https://github.com/amix/vimrc)

##Gotchas
To install c_sharp TreeSitter parser I needed to install clang (clang 10 apparently, default clang)

##Installation in the beginning of the year 2022
Windows terminal is excellent, it has support for true color and all sorts of niceness
Install neovim dev (document ppa:unstable), seems to be nightly builds
tmux, need to set utf-8 in .tmux.conf
Currently using stow for dotfiles, WIP. Works fine so far.

For regular WSL2 copying from neovim, need to install win32yank in host. Use scoop install win32yank
See init.vim for setup of clipboard
Note, explicitly setting g:clipboard cuts .5 seconds of nvim startup time
For copying from tmux, I may need to configure tmux-yank

