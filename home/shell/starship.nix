{
  pkgs,
  lib,
  ...
}: let
  builtin-config-file = pkgs.runCommand "starship-jetpack.toml" {} ''
    ${lib.getExe pkgs.starship} preset jetpack -o "$out"
  '';
  builtin-config = fromTOML (builtins.readFile builtin-config-file);

  c = lib.concatMapStrings (s: "$" + s);

  config.right_format = "";
  config.format = let
    left = c ["directory" "nix_shell" "vcs"];
    right = c [
      "singularity"
      "kubernetes"
      "docker_context"
      "package"
      "c"
      "cmake"
      "cobol"
      "daml"
      "dart"
      "deno"
      "dotnet"
      "elixir"
      "elm"
      "erlang"
      "fortran"
      "golang"
      "guix_shell"
      "haskell"
      "haxe"
      "helm"
      "java"
      "julia"
      "kotlin"
      "gradle"
      "lua"
      "maven"
      "nim"
      "nodejs"
      "bun"
      "ocaml"
      "opa"
      "perl"
      "php"
      "pulumi"
      "purescript"
      "python"
      "raku"
      "rlang"
      "red"
      "ruby"
      "rust"
      "scala"
      "solidity"
      "swift"
      "terraform"
      "vlang"
      "vagrant"
      "xmake"
      "zig"
      "buf"
      "conda"
      "pixi"
      "meson"
      "spack"
      "gcloud"
      "openstack"
      "crystal"
      "battery"
      "time"
    ];
    bottom = c ["hostname" "localip" "jobs" "username" "character"];
  in "(${left}$fill${right})\n${bottom}";

  config.character = {
    success_symbol = "[▷](green)";
    error_symbol = "[▶](red)";
  };

  config.directory = {
    truncation_length = 999;
    repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style)";
  };

  config.time = {
    style = "dimmed white";
  };

  config.vcs = {
    order = ["jj" "git"];
    jj_modules = c ["jj_metrics" "jj_change"];
  };

  config.jj_change = {
    format = " [$change_prefix](bold fg:5)[$change_suffix](fg:8) [$commit_prefix](bold fg:4)[$commit_suffix](fg:8)";
  };
  config.jj_metrics = {
    format = " ([▴$added]($added_style))([▿$deleted]($deleted_style))";
    added_style = "dimmed green";
    deleted_style = "dimmed red";
    only_nonzero_diffs = false;
  };

  config.nix_shell = {
    format = " [$symbol$state]($style) [$name](italic dimmed white)";
  };
in {
  xdg.configFile."starship.toml".source = (pkgs.formats.toml {}).generate "starship.toml" (lib.recursiveUpdate builtin-config config);
}
