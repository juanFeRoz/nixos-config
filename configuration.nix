{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.configurationLimit = 10;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  nix.settings.auto-optimise-store = true;

  boot.loader.systemd-boot.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Bogota";

  nix.settings.experimental-features = ["nix-command" "flakes"];

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.juanfe = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    packages = with pkgs; [
      git
      alejandra
      adwaita-icon-theme
      glib
      waybar
      firefox
      alacritty
      wlprop
      slurp
      wl-clipboard
      mako
      xdg-user-dirs
      pw-volume
      playerctl
      xfce.thunar
      xfce.thunar-volman
      kickoff
      ripgrep
    ];
  };

  fonts.enableDefaultPackages = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
  ];

  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [grim swayidle swaylock brightnessctl];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];

  system.stateVersion = "25.05";
}
