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
            adwaita-icon-theme
            glib
            waybar
            firefox
            pwvucontrol
            lua-language-server
            zathura
            file-roller
            gccgo15
            tree-sitter
            fzf
            networkmanagerapplet
            wlprop
            unzip
            slurp
            wl-clipboard
            mako
            tmux
            xdg-user-dirs
            playerctl
            ripgrep
            alacritty
            kitty
            direnv
        ];
    };

    fonts.enableDefaultPackages = true;

    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
    ];
    services.gvfs.enable = true; # Mount, trash, and other functionalities

    fonts.packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
    ];

    services.gnome.gnome-keyring.enable = true;

    programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [grim swayidle swaylock brightnessctl wmenu ];
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
