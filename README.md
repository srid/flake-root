# flake-root

A `flake-parts` module for finding your way to the project root directory

## Usage

```nix
{
  inputs = {
    flake-root.url = "github:srid/flake-root";
    ...
  };
  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit self; } {
      imports = [
        inputs.flake-root.flakeModule
      ];
      perSystem = { pkgs, lib, config, ... }: {
        flake-root.projectRootFile = "flake.nix";  # Not necessary, as flake.nix is the default
        devShells.default = pkgs.mkShell {
          inputsFrom = [ config.flake-root.devShell ];  # Provides $FLAKE_ROOT in dev shell
        };
      };
    };
}
```

Now you have access to the program that returns the absolute path to the project root via `${lib.getExe config.flake-root.package}`. There is also `config.flake-root.devShell` which exposes a `shellHook` providing the `$FLAKE_ROOT` environment variable.

## Examples

- This module is in turn used by the following `flake-parts` modules:
  - https://github.com/Platonic-Systems/mission-control
  - https://github.com/srid/proc-flake

## Credit

The bash script is originally based on [numtide/treefmt](https://github.com/numtide/treefmt/blob/66959743ba9e955819a16960319a09d152acff9a/module-options.nix#L98-L109).
