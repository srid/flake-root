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
    }; 
```

Now you have access to the program that returns the absolute path to the project root via `${lib.getExe config.flake-root.package}`.

## Examples

- https://github.com/Platonic-Systems/mission-control