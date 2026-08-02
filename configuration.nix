# Edit this configuration file to define what should be installed on your system. Help is available in the 
# configuration.nix(5) man page, on https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{ imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    gfxmodeEfi = "1920x1080";
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.plymouth = {
    enable = true;
  };
  boot.kernelParams = [ "quiet" "splash" ];

  networking.hostName = "nixie"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "US/Eastern";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-vulkan;
  };

  programs.steam.enable = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    withUWSM = true;
  };

  services.displayManager.regreet = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 16;
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    theme = {
      name = "Colloid-Dark";
      package = pkgs.colloid-gtk-theme;
    };
  };

  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.kmscon = {
    enable = true;
    config = {
      hwaccel = true;
      font-engine = "pango";
      font-size = 14;
      font-name = "JetBrainsMono Nerd Font Mono";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.caskaydia-cove
    nerd-fonts.noto
  ];

  security.sudo.wheelNeedsPassword = false;

  users.users.brian = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "input" "audio" "dialout" "networkmanager" ];
    shell = pkgs.zsh;
    linger = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    pango
  ];

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

