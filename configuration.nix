{
config,
lib,
pkgs,
...
}: {
    imports = [
        ./hardware-configuration.nix
    ];

    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };

    system.autoUpgrade.enable  = true;
    system.autoUpgrade.allowReboot  = true;

    nix.settings.auto-optimise-store = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.consoleMode = "max";

    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "nixos";

    networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 5050 ];
        allowedUDPPorts = [ 5050 ];
    };

    networking.wireless.iwd.enable = true;

    networking.wireless.iwd = {
        settings = {
            # The [Settings] group
            Settings = {
                RoamThreshold = -80;
                RoamThreshold5G = -80;
            };
        };
    };

    boot = {
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
            "quiet"
            "splash"
            "boot.shell_on_fail"
            "udev.log_priority=3"
            "rd.systemd.show_status=auto"
            "bt_coex=0"
        ];
    };

    time.timeZone = "America/Bogota";

    nix.settings.experimental-features = ["nix-command" "flakes"];

    services.pipewire = {
        enable = true;
        pulse.enable = true;
    };

    virtualisation.docker = {
        enable = true;
    };

    users.users.juanfe = {
        isNormalUser = true;
        extraGroups = ["wheel" "docker"];
        packages = with pkgs; [
            git
            adwaita-icon-theme
            glib
            waybar
            blesh
            tldr
            alejandra
            firefox
            pwvucontrol
            discord
            aria2
            impala
            lua-language-server
            obsidian
            nwg-look
            fancy-cat
            docker-compose
            file-roller
            gccgo15
            tree-sitter
            fzf
            wlprop
            unzip
            slurp
            wl-clipboard
            mako
            tmux
            xdg-user-dirs
            playerctl
            ripgrep
            kitty
            direnv
        ];
    };

    nixpkgs.config.allowUnfree = true;

    fonts.enableDefaultPackages = true;

    programs.thunar.enable = true;

    programs.thunar.plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
    ];

    programs.steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    services.gvfs.enable = true; # Mount, trash, and other functionalities

    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
    services.blueman.enable = true;

    hardware.bluetooth.settings = {
        General = {
            Experimental = true;
        };
    };

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
