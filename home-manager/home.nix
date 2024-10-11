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
    smug
    autoconf-archive
    starship
    azure-cli
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
  sixelSource = pkgs.fetchFromGitHub {
    owner = "csdvrx";
    repo = "sixel-testsuite";
    rev = "6f18f18";
    sha256 = "sha256-wRv+SkA7+y7/UiO4oaunuUkLmi1UTKgasfERguJdgx4=";
  };
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

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # todo change to flake
  home.file = {
    "sixel-testsuite".source =
      pkgs.runCommand "sixel-test-runnable"
        {
          src = sixelSource;
        }
        ''
          mkdir $out
          cp -a $src/* $out
          chmod u+x $out/*.sh
        '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # home.sessionPath = [
  #   "$HOME/bin/zig-0.14"
  # ];

  # this is a bit that's not very nix-like
  xdg.configFile."nvim".source = ../nvimnonni;

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/Fish
  # defaults fine for now
  programs.fish.enable = true;

  # programs.tmux.package = pkgs.tmux.overrideAttrs (_: rec {
  #   # version = "2.9a";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "tmux";
  #     repo = "tmux";
  #     rev = "89adec0ca5f3cf7510b3854967b33b399871da7e";
  #     sha256 = "sha256-yhBXZKhl+YsQSzt7NEBf/0gDT0cxbwSN5OoilxhVu2w=";
  #   };
  # });
  programs.tmux = {
    enable = true;
    baseIndex = 1; # also does panes
    terminal = "tmux-256color";
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    historyLimit = 10000;
    plugins = with pkgs; [
      tmuxPlugins.resurrect
      tmuxPlugins.yank
      # tmuxPlugins.gruvbox
    ];
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
      set -ag terminal-overrides ",xterm-256color:RGB"
      # set -as terminal-features 'contour:sixel'
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

      set -g renumber-windows on 

      set -g pane-border-status "top"
      set-option -g status-interval 1
      set-option -g status "on"

      # set -g status-right-length 60
      # set -g status-right "#[fg=#(pomodoro tmux-color)] #(pomodoro status -f '%%t %!r 🍅') #[fg=yellow]#{?window_bigger,[#{window_offset_x}#,#{window_offset_y}] ,}#{=21:pane_title} %H:%M %d-%b-%y "

      ## COLORSCHEME: gruvbox dark (medium)
      # default statusbar color
      set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

      # default window title colors
      # set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1
      set-window-option -g window-status-style bg=yellow,fg=colour237 # bg=yellow, fg=bg1

      # default window with an activity alert
      set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

      # active window title colors
      set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

      # pane border
      set-option -g pane-active-border-style fg=colour250 #fg2
      set-option -g pane-border-style fg=colour237 #bg1

      # message infos
      set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

      # writing commands inactive
      set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

      # pane number display
      set-option -g display-panes-active-colour colour250 #fg2
      set-option -g display-panes-colour colour237 #bg1

      # clock
      set-window-option -g clock-mode-colour blue #blue

      # bell
      set-window-option -g window-status-bell-style bg=red,fg=colour235 # bg=red, fg=bg

      ## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
      set-option -g status-justify "left"
      set-option -g status-left-style none
      set-option -g status-left-length "80"
      set-option -g status-right-style none
      set-option -g status-right-length "80"
      set-window-option -g window-status-separator ""

      set-option -g status-left "#[bg=colour241,fg=colour248] #S #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]"
      set-option -g status-right "#[bg=colour237,fg=colour239 nobold, nounderscore, noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #h "

      # set-window-option -g window-status-current-format "#[bg=colour214,fg=colour237,nobold,noitalics,nounderscore]#[bg=colour214,fg=colour239] #I #[bg=colour214,fg=colour239,bold] #W#{?window_zoomed_flag,*Z,} #[bg=colour237,fg=colour214,nobold,noitalics,nounderscore]"
      set-window-option -g window-status-current-format "#[bg=colour237,fg=yellow,nobold,noitalics,nounderscore] #I#[bg=yellow,fg=colour237, bold] #W#{?window_zoomed_flag,*Z,} #[bg=colour237,fg=yellow,nobold,noitalics,nounderscore]"
      set-window-option -g window-status-format "#[bg=colour237,fg=colour223] #I#[bg=colour239,fg=colour237,noitalics]#[bg=colour239,fg=colour223] #W #[bg=colour237,fg=colour239,noitalics]"
    '';
    #color stuff
    #     extraConfig = ''
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
      indent-blankline-nvim
      mini-indentscope
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
