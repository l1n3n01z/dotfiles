{ config, pkgs, lib, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # imports = [

		# inputs.nix-colors.homeManagerModules.default

		# inputs.nixvim.homeManagerModules.nixvim

		# inputs.nixvim_flake.programs.x86_64-linux.default

		# ./tmux.nix

		# ./alacritty.nix

		# ./kitty.nix

		# ./bat.nix

		# ./git.nix

		# ./programs.nix

		# ./zsh.nix

		# ./zellij.nix

		# ./starship.nix

		# ./lazygit.nix

#		./nixvim.nix

#		./window_manager/hyprlock.nix

		#./qutebrowser/qutebrowser.nix

	# ];

 
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

  # The home.packages option allows you to install Nix packages into your
  # environment.
  # home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    
  # ];
home.packages = with pkgs; [ 
		#vscode-langservers-extracted
		typescript-language-server
		csharp-ls
		jq
		ripgrep
		fd
	        dotnetCorePackages.sdk_8_0_4xx
		csharpier
	];

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

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/nonni/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };
 # home.sessionPath = [
 #   "$HOME/bin/zig-0.14"
 # ];

  # this is a bit not very nix
  #xdg.configFile."nvim".source = ../nvimcurrlazy;
 # xdg.configFile."tmux".source = ../tmux;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
 # programs.fish.enable = true;
  # programs.fish.interactiveShellInit = "fish_add_path -p /home/nonni/bin/zig-0.14";
  # programs.curl.enable = true;
 # programs.tmux.enable = true;
   programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      csharpls-extended-lsp-nvim 
      nvim-lspconfig
      gruvbox-material-nvim
    ];
   };
 programs.gitui.enable = true;
  # programs.neovim.extraLuaConfig = lib.fileContents ../nvimcurrlazy/init.lua ;
}
