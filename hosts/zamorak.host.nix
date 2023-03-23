{ config, builtins, lib, pkgs, modulesPath, ... }:
{

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "usb_storage" "nvme" "sd_mod" "sdhci_pci" "rtsx_usb_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = { device = "rpool/nixos/local/root"; fsType = "zfs"; };
  fileSystems."/nix" = { device = "rpool/nixos/local/nix"; fsType = "zfs"; };
  # fileSystems."/home" = { device = "zroot/locker/home"; fsType = "zfs"; };

  fileSystems."/boot" = { device = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003"; fsType = "vfat"; };

  boot.zfs.devNodes = "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.generationsDir.copyKernels = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.copyKernels = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.zfsSupport = true;
  # boot.loader.grub.extraInstallCommands = with builtins;
  #   (toString (map (diskName:
  #     "cp -r " + config.boot.loader.efi.efiSysMountPoint + "/EFI" + " "
  #     + zfsRoot.mirroredEfi + diskName + zfsRoot.partitionScheme.efiBoot + "\n")
  #     (tail zfsRoot.bootDevices)));
  boot.loader.grub.devices = [ "/dev/disk/by-id/ata-QEMU_HARDDISK_QM00003-part1"];
    # (map (diskName: zfsRoot.devNodes + diskName) zfsRoot.bootDevices);

}

