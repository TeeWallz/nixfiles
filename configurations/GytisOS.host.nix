{ config, builtins, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./base.nix
    ./dev.nix
    ./xorg.nix
    ./cli
  ];

  nixpkgs.config.allowBroken = true;
  environment.variables = {
    XKB_DEFAULT_OPTIONS = "terminate:ctrl_alt_bksp,caps:escape,altwin:swap_alt_win";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest; # Default value is 'pkgs.linuxPackages'
  #hardware.bluetooth.enable = true;                  # Default value is 'false'
  #services.openssh.passwordAuthentication = true;    # Default value is 'false'
  services.zerotierone.enable = true; # Default value is 'false'
  services.zerotierone.joinNetworks = [ "9bee8941b5c7428a" "12ac4a1e710088c5" ]; # Default value is '[]'
  #time.timeZone = "Europe/Vilnius";                  # Default value is 'Europe/Vilnius'
  #networking.enableIPv6 = false;                     # Default value is 'true'

  services.xserver.displayManager.defaultSession = "none+i3";
  services.xserver.windowManager.i3.enable = true;
  programs.sway.enable = true;
  home-manager.users.gytis = import ../home-manager;
  users.extraUsers.gytis = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Gytis Ivaskevicius";
    extraGroups = [ "audio" "dialout" "adbusers" "wheel" "networkmanager" "docker" "vboxusers" ];
    initialPassword = "toor";
  };

  environment.systemPackages = with pkgs; [
    geekbench
    fuse-overlayfs
    nox
    tdesktop
    rustup
    cargo
    grpcui
    woeusb
    multimc
    minecraft
    zfsUnstable
  ];

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  networking.extraHosts = ''
  '';

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

  boot.extraModulePackages = [
    config.boot.kernelPackages.zfsUnstable
  ];
  boot.zfs.enableUnstable = true;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" = { device = "zroot/locker/os"; fsType = "zfs"; };
  fileSystems."/home" = { device = "zroot/locker/home"; fsType = "zfs"; };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/F794-3014"; fsType = "vfat"; };
  fileSystems."/nix" = { device = "zroot/locker/nix"; fsType = "zfs"; };


  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkForce "performance";
}
