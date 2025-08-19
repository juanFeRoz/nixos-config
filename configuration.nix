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

    networking.networkmanager.enable = false;

    networking.wireless.iwd.enable = true;

    services.resolved.enable = true;


    boot = {
        plymouth = {
            enable = true;
            theme = "rings";
            themePackages = with pkgs; [
                # By default we would install all themes
                (adi1090x-plymouth-themes.override {
                    selected_themes = [ "rings" ];
                })
            ];
        };

        # Enable "Silent boot"
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
            "quiet"
            "splash"
            "boot.shell_on_fail"
            "udev.log_priority=3"
            "rd.systemd.show_status=auto"
        ];
        # Hide the OS choice for bootloaders.
        # It's still possible to open the bootloader list by pressing any key
        # It will just not appear on screen unless a key is pressed
        loader.timeout = 0;

    };

    time.timeZone = "America/Bogota";

    nix.settings.experimental-features = ["nix-command" "flakes"];

    services.pipewire = {
        enable = true;
        pulse.enable = true;
    };

    users.users.juanfe = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager"];
        packages = with pkgs; [
            git
            adwaita-icon-theme
            glib
            waybar
            firefox
            pwvucontrol
            lua-language-server
            dropbox
            obsidian
            nwg-look
            joycond-cemuhook
            zathura
            file-roller
            gccgo15
            tree-sitter
            fzf
            networkmanagerapplet
            wpa_supplicant
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

    services.flatpak.enable = true;

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

    powerManagement.powertop.enable = true;
    services = {
        power-profiles-daemon.enable = false;
        tlp = {
            enable = true;
            settings = {
                CPU_BOOST_ON_AC = 1;
                CPU_BOOST_ON_BAT = 0;
                CPU_SCALING_GOVERNOR_ON_AC = "performance";
                CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
                STOP_CHARGE_THRESH_BAT0 = 95;
            };
        };
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
