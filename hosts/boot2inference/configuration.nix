{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/iso-image.nix")
    (inputs.nixpkgs + "/nixos/modules/profiles/minimal.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" ];
  boot.loader.timeout = lib.mkForce 0;

  hardware.amdgpu.initrd.enable = true;

  isoImage.makeEfiBootable = true;
  isoImage.squashfsCompression = "zstd -Xcompression-level 3";

  networking.hostName = "boot2inference";

  nixpkgs.hostPlatform = "x86_64-linux";

  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.avahi.settings.publish.disable-publishing = false;

  services.llama-cpp.enable = true;
  services.llama-cpp.openFirewall = true;
  services.llama-cpp.package = pkgs.llama-cpp-rocm;
  services.llama-cpp.settings.host = "0.0.0.0";

  system.stateVersion = "26.11";
}
