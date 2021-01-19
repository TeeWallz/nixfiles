{ lib
, self
, inputs
, system
, pkgs
, nixosModules
}:
let
  inherit (lib) removeSuffix;
  inherit (builtins) listToAttrs;
  genAttrs' = values: f: listToAttrs (map f values);

in
{
  pkgImport = pkgs: overlays: import pkgs {
    inherit system overlays;
    config = { allowUnfree = true; };
  };


  buildNixosConfigurations = paths:
    genAttrs' paths (path:
      let
        hostName = removeSuffix ".nix" (baseNameOf path);
      in
      {
        name = hostName;
        value = lib.nixosSystem {
          inherit system;

          modules =
            let
              global = {
                networking.hostName = hostName;
                nixpkgs = { pkgs = pkgs; };
                nix.nixPath = let path = toString ../.; in
                  [
                    "nixpkgs=${inputs.master}"
                    "nixos=${inputs.nixos}"
                    "nixos-config=${path}/hosts/GytisOS.nix"
                  ];

                nix.package = pkgs.nixUnstable;
                nix.extraOptions = ''
                  experimental-features = nix-command flakes
                '';

                nix.registry = {
                  nixos.flake = inputs.nixos;
                  nixflk.flake = self;
                  nixpkgs.flake = inputs.master;
                };

                system.configurationRevision = lib.mkIf (self ? rev) self.rev;
              };

            in
            [
              (import path)
              global
            ] ++ nixosModules;

          extraArgs = {
            inherit system inputs;
          };
        };
      });
}
