{
  description = "Library and tooling that supports remote filesystem and process operations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        packages.default =
          pkgs.rustPlatform.buildRustPackage {
            name = "distant";

            src = self;

            cargoLock = {
              lockFile = self + /Cargo.lock;
            };

            # Build time
            nativeBuildInputs = with pkgs; [ perl ];

            # Requires internal DNS resolution
            doCheck = false;

            meta = {
              mainProgram = "distant";
              license = with lib.licenses; [ mit asl20 ];
            };
          };

        devShells = {
          default = pkgs.mkShell {
            nativeBuildInputs = [
              pkgs.cargo
            ];
          };
        }
        ;
      }
    );
}
