# Keep stable workstation configuration in Home Manager; manage evergreen agents and project SDK exceptions outside it

Home Manager/Nix remains the declarative owner of stable WSL workstation configuration, shell/editor tooling, and one current-LTS .NET baseline. Evergreen service-coupled agents (Pi, Claude Code, and GitHub Copilot CLI) are installed and explicitly updated through their supported upstream mechanisms because current releases matter more than flake-pinned binaries; their authored configuration is Git-managed separately from credentials and runtime state. mise is Nix-managed but used only for reviewed project-local .NET/Node overrides, while Python remains Nix-managed until a portable Python project justifies project-local tooling.

## Consequences

- Fresh provisioning targets newest Ubuntu LTS on WSL2 with systemd; the existing Ubuntu 24.04 distribution remains a supported migration distribution.
- Bootstrap uses a small APT prerequisite set, then Nix/Home Manager; it does not upgrade Ubuntu automatically.
- Agent runtimes may be private, but ordinary `node` and `npm` must not appear on the developer PATH after bootstrap.
- Project contracts remain in ecosystem-native files such as `global.json`, lockfiles, and minimal reviewed `mise.toml` files; Nix flakes may be optional Linux conveniences, not the only project setup path.
