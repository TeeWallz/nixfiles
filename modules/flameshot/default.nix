{ config, pkgs, lib, ... }:
{
  imports = [ ../autostart-systemd ];

  environment.systemPackages = [ pkgs.flameshot ];

  systemd.user.services.flameshot = {
    description = "Flameshot";
    wantedBy = ["autostart.target"];
    serviceConfig = {
      Restart = "always";
      ExecStart = "/run/current-system/sw/bin/execWithEnv ${pkgs.flameshot}/bin/flameshot";
    };
  };

}
