{
  pkgs,
  lib,
  ...
}: let
  llama-server = lib.getExe' (pkgs.llama-cpp-rocm) "llama-server";

  llama-swap-config = name: args: let
    extra-args = builtins.concatLists (
      lib.attrsets.mapAttrsToList
      (name: value: ["--${name}" (toString value)])
      args
    );
  in {
    cmd = lib.strings.concatStringsSep " " (
      [
        llama-server
        "--hf-repo"
        name
        # "--jinja"
        "--port"
        "\${PORT}"
      ]
      ++ extra-args
    );
  };
in {
  systemd.services.llama-swap = let
    port = 9292;
    settings.models."qwen3.5:9b" =
      llama-swap-config "unsloth/Qwen3.5-9B-GGUF:UD-Q4_K_XL" {
        temp = 0.6;
        top-p = 0.95;
        top-k = 20;
        min-p = 0.00;
        reasoning = "on";
        chat-template-file = ./qwen3.5-template.jinja;
      }
      // {
        aliases = [
          "claude-haiku-4-5"
          "claude-haiku-4-5-20251001"
        ];
      };
    settings.tll = 600;
    configFile = (pkgs.formats.yaml {}).generate "config.yaml" settings;
  in {
    description = "Model swapping for LLaMA C++ Server (or any local OpenAPI compatible server)";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    # copied from nixpkgs, but added cache env
    environment = {
      XDG_CACHE_HOME = "/var/cache/llama-swap";
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      ROCR_VISIBLE_DEVICES = "GPU-b797b89d131e1f77";
    };

    serviceConfig = {
      Type = "exec";
      ExecStart = "${lib.getExe pkgs.llama-swap} --listen :${toString port} --config ${configFile}";
      Restart = "on-failure";
      RestartSec = 3;

      CacheDirectory = "llama-swap";

      # for GPU acceleration
      PrivateDevices = false;

      DynamicUser = true;
      NoNewPrivileges = true;
      PrivateTmp = true;
    };
  };
}
