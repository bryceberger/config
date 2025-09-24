{pkgs, ...}: {
  imports = [./hardware/janus.nix];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services.xserver = {
    # ugh vr no work nice on wayland -_-
    # doesn't work too well on X either lol
    # enable = true;
    # autorun = false;
    # displayManager.startx.enable = true;
    # windowManager.i3 = {
    #   enable = true;
    #   extraPackages = with pkgs; [dmenu i3status i3lock];
    # };
  };
  programs.sway.enable = true;

  services.ollama = {
    enable = true;
    loadModels = [
      "qwen3:0.6b"
      "qwen3:14b"
      "gpt-oss:20b"
    ];
    rocmOverrideGfx = "11.0.0";
    environmentVariables = {
      ROC_ENABLE_PRE_VEGA = "1";
    };
  };

  programs.fish.enable = true;
  users = {
    defaultUserShell = pkgs.fish;
    groups = {
      plugdev = {};
      dialout = {};
      media = {};
    };
    users.bryce = {
      isNormalUser = true;
      description = "bryce";
      extraGroups = [
        "dialout"
        "docker"
        "input"
        "networkmanager"
        "plugdev"
        "video"
        "wheel"
        "media"
      ];
      openssh.authorizedKeys.keys = [
        # luna
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJQmROnDI1j/JpJeNtB7/F8MIMPLIBsJBd4E80ysEwa bryce.z.berger@gmail.com"
        # janus
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgTjWmuWkpxIl8OhxuPKH5IP72k8apa7M8JfFdwMwLe bryce.z.berger@gmail.com"
      ];
    };

    users.media = {
      isNormalUser = true;
      group = "media";
      openssh.authorizedKeys.keys = [
        # glenn macbook
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDv0aqKzA7axNXTCIYsc5QvcL0Mz5ohd6qog+u3Uno90 glenn@glenns-air.lan"
        # luna
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEJQmROnDI1j/JpJeNtB7/F8MIMPLIBsJBd4E80ysEwa bryce.z.berger@gmail.com"
        # janus
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGgTjWmuWkpxIl8OhxuPKH5IP72k8apa7M8JfFdwMwLe bryce.z.berger@gmail.com"
      ];
    };
  };

  programs.steam.enable = true;
  hardware.xpadneo.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
  security.pam.services.swaylock = {};

  services = {
    udev.extraRules = ''
      # fomu
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="5bf0", MODE="0664", GROUP="plugdev"
      # kindle?
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0324", MODE="0664", GROUP="plugdev"
      # kindle but jessica
      SUBSYSTEM=="usb", ATTRS{idVendor}=="1949", ATTRS{idProduct}=="9981", MODE:="0666"
      # steam vr camera
      # doesn't actually work but this makes me feel like I'm doing my part
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28de", ATTRS{idProduct}=="2400", MODE="0660", TAG+="uaccess"
    '';
    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PasswordAuthentication = false;
      };
    };

    # monado = {
    #   enable = true;
    #   defaultRuntime = true;
    # };
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-users = [
      "nixremote"
    ];
    secret-key-files = /etc/nixos/private.pem;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
