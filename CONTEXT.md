# Workstation Provisioning

The dotfiles repository defines a portable developer workstation baseline and the boundary between that baseline and individual project toolchains.

## Language

**Workstation bootstrap**:
An idempotent procedure that makes a fresh supported machine ready to clone and start a project.
_Avoid_: fresh install, machine setup

**Evergreen tool**:
A service-coupled developer tool that is deliberately installed at latest stable rather than pinned.
_Avoid_: pinned agent, reproducible agent binary

**Project toolchain**:
The runtimes and dependencies a repository declares and installs for its own development workflow.
_Avoid_: workstation SDK set

**Private runtime**:
A runtime installed solely to support one application and not exposed as a general development command.
_Avoid_: global Node

**Native-Windows project support**:
The ability to install and run a repository's declared toolchain on Windows without requiring full workstation-config parity.
_Avoid_: Windows workstation parity

**Incremental extraction**:
Moving a volatile concern out of Home Manager without reorganizing unrelated legacy dotfiles.
_Avoid_: bootstrap rewrite, dotfiles cleanup

**Interactive authentication**:
A user-completed agent login performed after installation rather than credential restoration by bootstrap scripts.
_Avoid_: token migration, automated account restore

**WSL host readiness**:
The Windows and WSL settings a distribution cannot safely configure for itself, including systemd availability, graphics integration, and required networking behavior.
_Avoid_: Ubuntu bootstrap

**Distro SSH identity**:
An SSH key generated in one WSL distribution and registered with GitHub for that distribution's Git access.
_Avoid_: shared private key, copied SSH key

**APT bootstrap prerequisites**:
The small Ubuntu-provided package set needed before Nix and Home Manager are available.
_Avoid_: second workstation package manager

**Migration distribution**:
An existing WSL Ubuntu distribution that continues to receive the workstation workflow without being the target release for new provisioning.
_Avoid_: fresh-provisioning target

**Agent configuration**:
The Git-managed settings and authored resources an agent loads, distinct from its credentials, sessions, caches, and installed package state; every managed agent receives this treatment by default.
_Avoid_: agent runtime state

## Relationships

- A **Workstation bootstrap** installs the manager needed to obtain a **Project toolchain**.
- An **Evergreen tool** is installed by its upstream mechanism and may own a **Private runtime**.
- A **Project toolchain** overrides workstation baseline language SDKs when the repository declares a version.
- **Native-Windows project support** consumes the same repository declarations but does not require the **Workstation bootstrap** to run on Windows.
- **Incremental extraction** preserves Home Manager ownership of stable workstation configuration.
- An **Evergreen tool** is installed and then uses **Interactive authentication** before it can access its service.
- **WSL host readiness** is verified before a **Workstation bootstrap** configures the Ubuntu distribution.
- A **Distro SSH identity** is registered after initial interactive GitHub authentication and before SSH-based Git use.
- **APT bootstrap prerequisites** exist only to enable the **Workstation bootstrap**; general workstation tools remain outside APT.
- A **Migration distribution** runs the same workstation workflow, while new distributions use the newest supported Ubuntu LTS.
- An **Agent configuration** is linked into the conventional agent directory; agent runtime state remains local to that directory.

## Flagged ambiguities

- Browser policy is inconsistent: Fish sets `BROWSER=firefox` while Fish `xdg-open`/`wsl-open` functions send HTTP(S) URLs to a Windows Firefox helper. Non-Fish agent processes may therefore select an Ubuntu browser and require WSLg. Resolve this after observing the agent cohort's actual authentication behavior.

## Example dialogue

> **Dev:** "Why does this agent bring Node when Node is not installed on the workstation?"
> **Maintainer:** "The agent owns a **Private runtime**; projects still acquire Node only through their declared **Project toolchain**."
