{pkgs, ...}: {
  imports = [./hardware/luna.nix];

  hardware.graphics = {
    enable = true;
    extraPackages = [pkgs.mesa];
  };

  boot = {
    initrd.kernelModules = ["amdgpu"];
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.grub.configurationLimit = 20;
  };

  networking.networkmanager.enable = true;

  programs.fish.enable = true;
  users = {
    defaultUserShell = pkgs.fish;
    groups = {
      plugdev = {};
      dialout = {};
    };
    users.bryce = {
      isNormalUser = true;
      description = "bryce";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "plugdev"
        "vboxusers"
        "video"
        "dialout"
      ];
    };
  };

  # first is kindle, second is chipcraft course
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0004", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="6146", MODE="0664", GROUP="plugdev"

    # seme
    ATTR{idVendor}=="0403", ATTRS{manufacturer}=="Digilent", MODE:="666"
    ATTR{idVendor}=="0403", ATTRS{manufacturer}=="Xilinx", MODE:="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0008", MODE:="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0007", MODE:="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0009", MODE:="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000d", MODE:="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="000f", MODE:="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0013", MODE:="666"
    ATTR{idVendor}=="03fd", ATTR{idProduct}=="0015", MODE:="666"

    ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", MODE:="666"
    ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", MODE:="666"
    ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", MODE:="666"
  '';

  environment.systemPackages = with pkgs; [
    brightnessctl
    cachix
    cpufrequtils
  ];

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
  security.pam.services.swaylock = {};

  programs.steam.enable = true;

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    upower.enable = true;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune.enable = true;
    };
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
