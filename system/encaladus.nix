{pkgs, ...}: {
  imports = [./hardware/encaladus.nix];

  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 10;
    efi.canTouchEfiVariables = true;
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

    users.plex.extraGroups = ["media"];
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      # "ssh-ng://janus?priority=30"
    ];
    trusted-public-keys = [
      "janus:nQWcqncr+jWA5+fmv+NWtiySKCyuf6OiFDSJgWji+00="
    ];
    builders-use-substitutes = true;
    connect-timeout = 1;
  };

  nix.buildMachines = [
    {
      hostName = "janus";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      maxJobs = 16;
      speedFactor = 2;
    }
  ];

  system.stateVersion = "24.05";
}
