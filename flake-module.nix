{ self, lib, flake-parts-lib, ... }:
let
  inherit (flake-parts-lib)
    mkPerSystemOption;
  inherit (lib)
    mkOption
    types;
in
{
  options = {
    perSystem = mkPerSystemOption
      ({ config, self', inputs', pkgs, system, ... }:
        let
          mainSubmodule = types.submodule {
            options = {
              projectRootFile = mkOption {
                type = types.str;
                description = lib.mdDoc "The name of the unique file that exists only at project root";
                default = "flake.nix";
              };
              # Functions
              package = mkOption {
                type = types.package;
                description = lib.mdDoc ''
                  The Nix package providing the command to find the project root.
                '';
                default = pkgs.writeShellApplication {
                  name = "flake-root";
                  text = ''
                    set -euo pipefail
                    find_up() {
                      ancestors=()
                      while true; do
                        if [[ -f $1 ]]; then
                          echo "$PWD"
                          exit 0
                        fi
                        ancestors+=("$PWD")
                        if [[ $PWD == / ]] || [[ $PWD == // ]]; then
                          echo "ERROR: Unable to locate the ${config.flake-root.projectRootFile} in any of: ''${ancestors[*]@Q}" >&2
                          exit 1
                        fi
                        cd ..
                      done
                    }
                    find_up "${config.flake-root.projectRootFile}"
                  '';
                };
              };
            };
          };

        in
        {
          options.flake-root = lib.mkOption {
            type = mainSubmodule;
            description = lib.mdDoc ''
              flake-root module options
            '';
          };
        });
  };
}
