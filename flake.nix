{
  description = "A `flake-parts` module for finding your way to the project root directory";
  outputs = { self, ... }: {
    flakeModule = ./flake-module.nix;
  };
}
