{
  pkgs,
  lib,
  inputs,
  system,
  ...
}: let
  make-cmd = cmd: args: let
    args' = builtins.concatLists (
      lib.attrsets.mapAttrsToList
      (name: value:
        if builtins.isBool value
        then ["--${lib.optionalString value "no-"}${name}"]
        else ["--${name}" (toString value)])
      args
    );
  in
    lib.strings.concatStringsSep " " ([cmd] ++ args');

  llama-swap-cmd = model: args:
    make-cmd (lib.getExe' pkgs.llama-cpp-rocm "llama-server") (args
      // {
        inherit model;
        port = "\${PORT}";
      });

  fetchModel = repo: file: args: let
    model = inputs.nix-hug.lib.${system}.fetchModel ({
        repoId = repo;
        filters.files = [file];
      }
      // args);
  in "${model}/${file}";

  qwen38 = fetchModel "unsloth/Qwen3.8-27B-GGUF" "Qwen3.8-27B-UD-Q4_K_M.gguf" {
    rev = "4ca720788d1e01f1bff70c033e0d0028fd02e502";
    fileTreeHash = "sha256-N7PVnYrXCvB05t4xsTZZF6CdSCitgJZa3QQNMDCqrcc=";
    gitRepoHash = "sha256-eY/zo6QuryVdt2S58qmtehKna92ogQvklTLr6ALXpXA=";
  };

  qwen-chat-template = fetchModel "froggeric/Qwen-Fixed-Chat-Templates" "chat_template.jinja" {
    rev = "756cfb69d742355fd310b4ba9d50815a27d9d241";
    fileTreeHash = "sha256-KAAl+qYORR+iWMHTt9nDAGXKb8nXz4JX6K1ePVLMU+Y=";
    gitRepoHash = "sha256-xeaffbMQM+ufS/xts6DsZD2+t4sB60ARRgWgBPV1BIM=";
  };
in {
  systemd.services.llama-swap = let
    port = 9292;
    settings.globalTTL = 600;
    settings.models."qwen3.8:27b-q4" = let
      context = 128000;
    in {
      cmd = llama-swap-cmd qwen38 {
        ctx-size = context;

        temp = 1.0;
        top-p = 0.95;
        top-k = 20;
        min-p = 0.00;

        cache-type-k = "q4_0";
        cache-type-v = "q4_0";

        reasoning = "on";
        reasoning-format = "deepseek";
        reasoning-preserve = true;

        chat-template-file = qwen-chat-template;
      };
      aliases = ["qwen3.8:27b"];
      capabilities = {
        "in" = ["text" "image"];
        out = ["text"];
        tools = true;
        context = context;
      };
    };
    settings.store.path = "/var/lib/llama-swap/store.sqlite";
    configFile = (pkgs.formats.yaml {}).generate "config.yaml" settings;
  in {
    description = "Model swapping for LLaMA C++ Server (or any local OpenAPI compatible server)";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    environment = {
      XDG_CACHE_HOME = "/var/cache/llama-swap";
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      ROCR_VISIBLE_DEVICES = "GPU-b797b89d131e1f77";
    };

    path = [
      pkgs.rocmPackages.rocm-smi
    ];

    serviceConfig = {
      Type = "exec";
      ExecStart = make-cmd (lib.getExe pkgs.llama-swap) {
        listen = "0.0.0.0:${toString port}";
        config = configFile;
      };
      Restart = "on-failure";
      RestartSec = 3;

      CacheDirectory = "llama-swap";
      StateDirectory = "llama-swap";

      # for GPU acceleration
      PrivateDevices = false;

      DynamicUser = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };

  networking.firewall.allowedTCPPorts = [9292];
  networking.firewall.extraCommands = ''
    iptables -A INPUT -p tcp --dport 9292 --source 192.168.1.0/24 -j ACCEPT
  '';
}
