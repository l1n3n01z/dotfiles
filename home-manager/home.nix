{
  config,
  pkgs,
  tmux-custom,
  bugwarrior,
  # lib,
  inputs,
  ...
}:
let
  programs = with pkgs; [
    process-compose
    zig_0_15
    postgresql
    firefox
    pandoc
    opencode
    # gh
    # gh-dash
    lsd
    kubectl
    cook-cli
    hyperfine
    tree-sitter
    powershell
    page
    jq
    ripgrep
    fd # find
    just # command runner
    openpomodoro-cli
    smug # tmux session things
    autoconf-archive # do we need this?
    starship # prompt
    azure-cli
    devenv # nix dev envs
    sqlcmd # needed for sql stuff, maybe move to vim extraPackages
    urlencode
    dig # network tool
    tig # view branches
    unzip
    p7zip
    blesh # bash line editor
    imagemagick
    erlang_27
    rebar3 # erlang package thing, sometimes needed for gleam
    gleam
    nodejs # eugh
    inotify-tools # watch files change
    tree
    elixir
    bugwarrior
    omnisharp-roslyn
    # dotnetCorePackages.aspnetcore_8_0-bin
    # dotnet-runtime
    # inputs.nvim
  ];
  #it's probably best to leave this gimmick to flakes, and just keep dotnet 8 as my main
  # dotnetSdk = (
  #   pkgs.dotnetCorePackages.combinePackages [
  #     pkgs.dotnetCorePackages.dotnet_9.sdk
  #     pkgs.dotnetCorePackages.sdk_8_0_3xx
  #   ]
  # );
  # pkgs.dotnetCorePackages.dotnet_9.sdk;
  # dotnetSdk = pkgs.dotnetCorePackages.sdk_8_0_3xx;
  dotnetSdk = pkgs.dotnetCorePackages.sdk_8_0-bin;
  python = pkgs.python312.withPackages (
    p: with p; [
      recipe-scrapers
      numpy
      scipy
      librosa
      scikit-learn
    ]
  );
  # sdks = with pkgs; [
  sdks = [
    dotnetSdk
    python
  ];
  sixelSource = pkgs.fetchFromGitHub {
    owner = "csdvrx";
    repo = "sixel-testsuite";
    rev = "6f18f18";
    sha256 = "sha256-wRv+SkA7+y7/UiO4oaunuUkLmi1UTKgasfERguJdgx4=";
  };
  # all grammars
  # with 18 grammars, startup time is 6 ms for nvim-treesitter
  # with all grammars,startup time is 8 ms for nvim-treesitter
  # It is probably worth it just to have all grammars and pay those 2 ms
  # Todo add fsharp
  vimStartupPlugins = with pkgs.vimPlugins; [
    # (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
    nvim-treesitter.withAllGrammars
  ];
  # note, these plugins are optional so do not add to the startup time. Mostly.
  vimOptionalPlugins =
    with pkgs.vimPlugins;
    map
      (pl: {
        plugin = pl;
        optional = true;
      })
      [
        ##color
        gruvbox-material-nvim
        ##completion
        blink-cmp
        vim-fugitive
        # nvim-cmp
        # cmp-nvim-lsp
        # cmp-buffer
        # cmp-path
        # own-care-nvim
        ##lsp and formatting
        nvim-lspconfig
        csharpls-extended-lsp-nvim
        Ionide-vim
        conform-nvim
        ##ui
        neo-tree-nvim
        which-key-nvim
        indent-blankline-nvim
        mini-indentscope
        lualine-nvim
        ##dap
        nvim-dap
        nvim-dap-ui
        nvim-nio # dependency for ui
        nvim-dap-virtual-text
        ##sql
        vim-dadbod-completion
        vim-dadbod-ui
        vim-dadbod
        ##dbee needed
        nvim-dbee
        vim-dispatch

        ##mini. All the mini.
        mini-nvim
      ];
in
# fromGitHub =
#   ref: repo:
#   pkgs.vimUtils.buildVimPlugin {
#     pname = "${lib.strings.sanitizeDerivationName repo}";
#     version = ref;
#     src = builtins.fetchGit {
#       url = "https://github.com/${repo}.git";
#       ref = ref;
#     };
#   };
{
  # nixpkgs.overlays = [
  #   nvim.overlays.default
  # ];
  # nixpkgs = {
  #   overlays = [
  #     (final: prev: {
  #       vimPlugins = prev.vimPlugins // {
  #         own-care-nvim = prev.vimUtils.buildVimPlugin {
  #           name = "care";
  #           src = inputs.care-nvim;
  #         };
  #       };
  #     })
  #   ];
  # };
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

  # home.packages = programs ++ dotnetP ++ nix ++ js ++ lua;
  home.packages = programs ++ sdks;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  # todo change to flake
  # todo, fix 24 bit
  # todo, fix hashbang
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
    # silly hack
    ".local/bin/omnisharp".source = "${pkgs.omnisharp-roslyn}/bin/OmniSharp";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    # NVIM_APPNAME = "nvimnonni";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    XDG_BIN_HOME = "${config.home.homeDirectory}/.local/bin";
    RIPGREP_CONFIG_PATH = "${config.home.homeDirectory}/.config/ripgreprc";
    DOTNET_ROOT = "${pkgs.dotnetCorePackages.sdk_8_0-bin}/share/dotnet";
  };

  home.sessionPath = [
    # "${config.home.homeDirectory}/bin/zig-0.14"
    "${config.home.homeDirectory}/.local/bin"
  ];

  # this is a bit that's not very nix-like
  # xdg.configFile."nvim".source = ../nvimnonni;

  programs = {
    home-manager.enable = true;
    # bash.enable = true;
  };

  # TODO, make it easy to use multiple identities
  # https://seansantry.com/development/2022/12/14/split-git-nix/
  # https://pickard.cc/posts/git-identity-home-manager/
  programs.git.enable = true;
  programs.git = {
    userName = "Nonni";
    userEmail = "Jon.Thoroddsen@origo.is";
    # signing = {
    #   key = "<key>";
    #   signByDefault = true;
    # };
    extraConfig = {
      init.defaultbranch = "main";
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
      };
    };
  };

  programs.gh.enable = true;
  programs.gh = {
    # https://discourse.nixos.org/t/logging-in-with-gh-auth-and-home-manager/61590
    # gitCredentialHelper = {
    #   enable = true;
    #   hosts = [
    #     "https://github.com"
    #     "https://api.github.com"
    #   ];
    # };
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
    };
    # hosts = {
    #   "github.com" = {
    #     user = "ori-nonni";
    #   };
    # };
  };

  # gh-dash extension has it's own config
  programs.gh-dash.enable = true;
  # programs.gh-dash.settings = {
  #   prSections = [{
  #     title = "My Pull Requests";
  #     filters = "is:open author:@me";
  #   }];
  # };

  # https://nixos.wiki/wiki/Fish
  # defaults fine for now
  # see dotfiles/fish for things to improve
  # todo, maybe add wt.exe to path for pane splitting etc
  programs.fish.enable = true;
  programs.fish = {
    #not sure this is ever run?
    loginShellInit = ''
      # echo "we are a login shell"
      if string match -q -e microsoft (uname -r)
        ulimit -Sn 65536 # increase sockets on WSL2
      end
      # stupid hack for stupid nix dotnet root
      # set -gx DOTNET_ROOT (dirname (readlink -f (which dotnet)))
      # set -gx DOTNET_ROOT $(dotnet --info | awk -F': ' '/Base Path:/ {path=$2; gsub(/^[ \t]+/, "", path); sub(/\/[^/]+\/[^/]+\/?$/, "", path); print path}')
    '';

    shellInit = ''
      set -gx PATH (string match -v '/mnt/c/*' $PATH)
      # fish_add_path -aP /mnt/c/Windows/System32
    '';
    shellAbbrs = {
      #better to define this in git?
      gco = "git checkout";
      gcp = "git push";
      gpr = "git pull --rebase";
      grs = "git remote -v show";
      # gs  = "git stash";
      gsu = "git stash --include-untracked --keep-index";
      gsp = "git stash pop";
      la = "ls -al";
      hmu = "home-manager switch --flake ~/dotfiles/home-manager/";
      # omnisharp = "OmniSharp";
      # grep = "rg";
    };
  };

  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
  };

  programs.zk = {
    enable = true;
# https://github.com/zk-org/zk/blob/main/docs/config/config.md
    settings = {
      notebook = {
        dir = "~/vimwiki";
      };

      note = {
        language = "en";
        default-title = "Untitled";
        filename = "{{slug title}}-{{id}}";
        extension = "md";
        template = "/home/nonni/vimwiki/templates/default.md";
        id-charset = "alphanum";
        id-length = 4;
        id-case = "lower";
      };

      group.journal = {
        paths = [ "journal" ];
        note = {
          template = "/home/nonni/vimwiki/templates/journal.md";
          filename = "{{format-date now}}";
          # note, this is not a template
          # default-title = "{{format-date now}}";
        };
      };
      alias.journal = ''zk new --no-input "$ZK_NOTEBOOK_DIR/journal"'';
    };
  };


  # Templates managed by Home Manager too. 
  # Which I don't really think is a good idea
  home.file."vimwiki/templates/default.md".text = ''
    ---
    title: "{{title}}"
    date: "{{format-date now}}"
    tags: [journal]
    ---

    # {{title}}
    
  '';

  #include links?
  # prev: "[[{{yesterday}}]]"
  # next: "[[{{tomorrow}}]]"
  home.file."vimwiki/templates/journal.md".text = ''
    ---
    title: "{{format-date now}}"
    date: "{{format-date now}}"
    tags: [journal]
    ---

    # {{format-date now "long"}}
    
  '';

  # Some convenience aliases
  # home.shellAliases = {
  #   zn = "zk new --edit";
  #   zd = "zk new --group diary --title $(date +%F) --edit";
  #   zf = "zk list | fzf | xargs nvim";
  # };

  programs.pyenv = {
    enable = true;
  };

  programs.go.enable = true;

  # todo, how can we do this better?
  programs.tmux = {
    package = tmux-custom;
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
      set-option -g focus-events on

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
  # https://github.com/extrawurst/gitui/blob/master/KEY_CONFIG.md
  programs.gitui.keyConfig = ''
    (
        move_left: Some(( code: Char('h'), modifiers: "")),
        move_right: Some(( code: Char('l'), modifiers: "")),
        move_up: Some(( code: Char('k'), modifiers: "")),
        move_down: Some(( code: Char('j'), modifiers: "")),

        stash_open: Some(( code: Char('l'), modifiers: "")),
        open_help: Some(( code: F(1), modifiers: "")),

        status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),
    )
  '';

  programs.fzf.enable = true;
  # todo make flake, see what solvi is doing github.com/solvimarm
  programs.neovim = {
    enable = false;
    # extraLuaConfig =  lib.fileContents ../nvimcurrlazy/init.lua ;
    viAlias = true;
    vimAlias = true;
    # package = pkgs.nvim-pkg;
    extraPackages = with pkgs; [
      csharp-ls
      csharpier # formatter
      fsautocomplete
      netcoredbg

      lua-language-server
      stylua

      nil # nix lsp
      nixfmt-rfc-style

      typescript-language-server

      zls_0_15 # zig language server
    ];
    plugins = vimStartupPlugins ++ vimOptionalPlugins;
  };
}
