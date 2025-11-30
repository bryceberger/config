{pkgs, ...}: {
  imports = [./hardware/janus.nix];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_17;
  boot.kernelPatches = [
    {
      name = "bits-per-pixel fix + bigscreen EDID quirk";
      patch = builtins.fetchurl {
        url = "https://gitlab.com/lvra/lvra.gitlab.io/-/raw/b0dde5a4048bbfa8db39b562ee9b15beacf3cba3/content/docs/other/bigscreen-beyond/bigscreen-beyond-kernel.patch";
        sha256 = "0j8pp0iz9nnpfavzspjyfbcrbjlhwrv6sfwflc1zzyvr9jwxfzrj";
      };
    }
  ];

  programs.sway.enable = true;

  services.ollama = {
    enable = false;
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
  programs.steam.extest.enable = true;
  hardware.xpadneo.enable = true;
  programs.nix-ld.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
  security.pam.services.swaylock = {};

  services.udev.extraRules = ''
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
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PasswordAuthentication = false;
    };
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };
  services.monado = {
    enable = true;
    defaultRuntime = false;
    highPriority = true;
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
