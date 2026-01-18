{username, ...}: let
  # get infinite recursion when using `config.home.homeDirectory`
  home = "/home/${username}";
  cache = "${home}/.cache";
  config = "${home}/.config";
  data = "${home}/.local/share";
  state = "${home}/.local/state";
in {
  home.sessionVariables = {
    XDG_CACHE_HOME = cache;
    XDG_CONFIG_HOME = config;
    XDG_DATA_HOME = data;
    XDG_STATE_HOME = state;

    CARGO_HOME = "${data}/cargo";
    CUDA_CACHE_PATH = "${cache}/nv";
    DOTNET_CLI_HOME = "${data}/dotnet";
    DOT_SAGE = "${config}/sage";
    GHCUP_USE_XDG_DIRS = "true";
    GOPATH = "${data}/go";
    GRADLE_USER_HOME = "${data}/gradle";
    HISTFILE = "${state}/bash/history";
    LESSHISTFILE = "${state}/lesshst";
    NPM_CONFIG_CACHE = "${cache}/npm";
    NPM_CONFIG_INIT_MODULE = "${config}/npm/config/npm-init.js";
    NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";
    PYTHONSTARTUP = "${config}/python/startup.py";
    RUSTUP_HOME = "${data}/rustup";
    STACK_ROOT = "${data}/stack";
    STACK_XDG = 1;
    WINEPREFIX = "${data}/wine";
  };

  xdg.configFile = {
    "python/startup.py".source = ./xdg/startup.py;
  };

  xdg.dataFile = {
    # I would _like_ to set the following:
    # build-dir = "${cache}/cargo/{workspace-path-hash}"
    #
    # However, this causes the cargo process invoked by `rust-analyzer` to
    # share the same directory. I'm guessing r-a passes `--target-dir`, but that
    # doesn't affect the `build-dir`. Should search for an issue / open one...
    "cargo/config.toml".text = ''
      [build]
      target-dir = "${cache}/cargo"
    '';
  };
}
