{
  inputs,
  lib,
  perSystem,
  pkgs,
  ...
}:
let
  llamaModels = perSystem.self.llama-models;

  wifiSsid = builtins.getEnv "WIFI_SSID";
  wifiPsk = builtins.getEnv "WIFI_PSK";
in
{
  imports = [
    (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/iso-image.nix")
    (inputs.nixpkgs + "/nixos/modules/profiles/minimal.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" ];
  boot.loader.timeout = lib.mkForce 0;

  environment.systemPackages = [
    llamaModels
    pkgs.iw
    pkgs.llama-cpp-vulkan
    pkgs.wpa_supplicant
  ];

  hardware.amdgpu.initrd.enable = true;
  hardware.enableAllHardware = true;
  hardware.graphics.enable = true;

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;
  isoImage.squashfsCompression = "zstd -Xcompression-level 3";

  networking.hostName = "boot2inference";

  networking.wireless.enable = wifiSsid != "";
  networking.wireless.networks = lib.optionalAttrs (wifiSsid != "") { "${wifiSsid}".psk = wifiPsk; };

  nixpkgs.hostPlatform = "x86_64-linux";

  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.avahi.settings.publish.disable-publishing = false;
  services.avahi.settings.publish.publish-addresses = true;

  services.getty.autologinUser = "root";

  services.llama-cpp.enable = true;
  services.llama-cpp.openFirewall = true;
  services.llama-cpp.package = pkgs.llama-cpp-vulkan;
  services.llama-cpp.settings = {
    host = "0.0.0.0";
    metrics = true;
    models-max = 1;
    models-preset = "${llamaModels}/models.ini";
  };

  system.disableInstallerTools = true;
  system.stateVersion = "26.11";
}
