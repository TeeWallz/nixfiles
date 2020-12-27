{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [ cachix ];

  nix = {
    extraOptions = "gc-keep-outputs = true";

    binaryCaches = [
      "https://cache.nixos.org"
      "https://cachix.cachix.org"
      "https://gytix.cachix.org/"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "gytix.cachix.org-1:JXNZBxYslCV/hAkfNvJgyxlWb8jRQRKc+M0h7AaFg7Y="
    ];
  };
}
