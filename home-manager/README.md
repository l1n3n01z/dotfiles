https://nix-community.github.io/home-manager/index.xhtml
first run:
nix run home-manager/master -- init --switch dotfiles/home-manager
After that, home-manager has installed itself and we can skip nix run
home-manager switch dotfiles/home-manager

The flake inputs are not automatically updated by Home Manager. You need to use the standard nix flake update command for that.

If you only want to update a single flake input, then the command nix flake lock --update-input <input> can be used.

You can also pass flake-related options such as --recreate-lock-file or --update-input <input> to home-manager when building or switching, and these options will be forwarded to nix build. See the NixOS Wiki page for details.
