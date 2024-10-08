{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  programs = with pkgs; [
    jq
    ripgrep
    fd # find
    just # command runner
    openpomodoro-cli
  ];
  languageServers = with pkgs; [
    nil # nix
    typescript-language-server
    csharp-ls
    lua-language-server
  ];
  formatters = with pkgs; [
    csharpier
    nixfmt-rfc-style
  ];
  sdks = with pkgs; [
    dotnetCorePackages.sdk_8_0_4xx
  ];
in
{

  home.username = "nonni";
  home.homeDirectory = "/home/nonni";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = programs ++ sdks ++ languageServers ++ formatters;

  # home.packages = with pkgs; [
  #   #language servers
  #   #vscode-langservers-extracted
  #   nil
  #   typescript-language-server
  #   csharp-ls
  #   jq
  #   ripgrep
  #   fd
  #   dotnetCorePackages.sdk_8_0_4xx
  #   csharpier
  #   just
  #   lua-language-server
  #   # nixfmt-classic
  #   nixfmt-rfc-style
  # ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  # home.sessionPath = [
  #   "$HOME/bin/zig-0.14"
  # ];

  # this is a bit not very nix
  xdg.configFile."nvim".source = ../nvimnonni;
  #xdg.configFile."tmux".source = ../tmux;

  programs.home-manager.enable = true;
  # https://nixos.wiki/wiki/Fish
  programs.fish.enable = true;
  programs.tmux = {
    baseIndex = 1;
    terminal = "screen-256color";
    enable = true;
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    historyLimit = 5000;
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.yank
      tmuxPlugins.gruvbox
    ];
    extraConfig = ''
      bind Space copy-mode
      # Use v to trigger selection    
      bind -T copy-mode-vi v  if -F "#{selection_present}" { send -X clear-selection } { send -X begin-selection }

      # Use y to yank current selection
      bind -T copy-mode-vi y send-keys -X copy-selection

      unbind '"'
      unbind %
      bind | split-window -h
      bind / split-window -h
      bind - split-window -v

      # make pane numbering consistent with windows
      setw -g pane-base-index 1

      set -g renumber-windows on 

      set -g pane-border-status "top"

      set -g status-right-length 60
      set -g status-right "#[fg=#(pomodoro tmux-color)] #(pomodoro status -f '%%t %!r 🍅') #[fg=yellow]#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}#{=21:pane_title} %H:%M %d-%b-%y "
    '';

    #color stuff
    #     extraConfig = ''
    # set-option -g status-interval 1
    #
    # # default statusbar colors
    # set-option -g status-style fg=yellow,bg=black
    #
    # # default window title colors
    # set-window-option -g window-status-style fg=brightblue,bg=default #base0 and default
    # #set-window-option -g window-status-style dim
    #
    # # active window title colors
    # set-window-option -g window-status-current-style fg=brightred,bg=default #orange and default
    # #set-window-option -g window-status-current-style bright
    #
    # # pane border
    # set-option -g pane-border-style fg=black #base02
    # set-option -g pane-active-border-style fg=white #base01
    #
    # # message text
    # set-option -g message-style fg=yellow,bg=default #orange and base01
    #
    # # pane number display
    # set-option -g display-panes-active-colour brightred #orange
    # set-option -g display-panes-colour blue #blue
    #
    # # clock
    # set-window-option -g clock-mode-colour green #green
    #
    # # bell
    # set-window-option -g window-status-bell-style fg=black,bg=red #base02, red
    #     '';
  };

  programs.gitui.enable = true;

  programs.fzf.enable = true;
  # todo make flake, see what solvi is doing github.com/solvimarm
  programs.neovim = {
    enable = true;
    # extraLuaConfig =  lib.fileContents ../nvimcurrlazy/init.lua ;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      csharpls-extended-lsp-nvim
      nvim-lspconfig
      vim-dispatch
      gruvbox-material-nvim
      neo-tree-nvim
      which-key-nvim
      conform-nvim
      lualine-nvim
      (nvim-treesitter.withPlugins (
        plugins: with plugins; [
          nix
          python
          c-sharp
          javascript
          java
          ocaml
          html
          regex
          css
          toml
          lua
          sql
          yaml
          fish
          dot
          dockerfile
          http
          gleam
        ]
      ))
    ];
  };
}
