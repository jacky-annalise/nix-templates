{
  description = "Python 3.11 environment";

  # to activate, type `nix develop -c $SHELL` while in the repo directory.
  # or use direnv to automatically do so (see .envrc).
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pname = "Python 3.11 environment";
        pkgs = nixpkgs.legacyPackages."${system}";
        venvDir = ".venv";
        envFile = ".env";
      in
        rec {
          inherit pname;

          devShell = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [
              python311Packages.python
              poetry
            ];

            shellHook = ''
                # Run only if direnv is not installed
                if ! command -v direnv &> /dev/null
                then
                  # Create a virtual env if there isn't one
                  if [ ! -d "${venvDir}" ]; then
                    echo "🔄 Venv not found, creating new venv: ${venvDir}"
                    python -m venv .venv
                  fi

                  # Activate virtual env
                  echo "🚀 Activating venv"
                  source "${venvDir}/bin/activate"

                  echo "🐍 Python version: $(python --version)"
                fi
              '';
          };
        }
    );
}
