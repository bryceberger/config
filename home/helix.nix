{
  pkgs,
  nix-std,
  helix,
  system,
  ...
}: let
  std = nix-std.lib;

  map-languages = langs:
    builtins.map
    (name: {inherit name;} // langs.${name})
    (builtins.attrNames langs);

  language = map-languages {
    bash.formatter.command = "shfmt";
    c.indent = {
      tab-width = 4;
      unit = "\t";
    };
    cpp.indent = {
      tab-width = 4;
      unit = "    ";
    };
    git-commit.file-types = [{glob = "COMMIT_EDITMSG";} "jjdescription"];
    java.indent = {
      tab-width = 4;
      unit = "    ";
    };
    nix.formatter = {
      command = "alejandra";
      args = ["-q"];
    };
    python.language-servers = ["pyright" "ruff"];
    toml.language-servers = ["ctags-lsp"];
    typst.formatter.command = "typstyle";
    verilog = {
      language-servers = ["svls"];
      formatter = {
        command = "verible-verilog-format";
        args = ["--indentation_spaces" "4" "-"];
      };
    };
    veryl = {
      file-types = ["veryl" "vl"];
      scope = "source.veryl";
      comment-token = "//";
      indent = {
        tab-width = 4;
        unit = "    ";
      };
      language-servers = ["veryl-ls"];
    };
  };

  language-server = {
    ctags-lsp.command = "ctags-lsp";
    nixd.command = "nixd";
    pyright = {
      command = "pyright-langserver";
      args = ["--stdio"];
    };
    ruff = {
      command = "ruff";
      args = ["server" "--preview"];
    };
    rust-analyzer.config.check = {command = "clippy";};
    svls.command = "svls";
    veryl-ls = {command = "veryl-ls";};
  };

  config = {
    theme = "catppuccin_mocha";

    editor = {
      auto-format = false;
      bufferline = "multiple";
      color-modes = true;
      cursorline = true;
      file-picker.hidden = true;
      gutters = ["diagnostics" "diff" "line-numbers" "spacer"];
      indent-guides.render = true;
      line-number = "relative";
      true-color = true;
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      statusline = {
        right = [
          "diagnostics"
          "version-control"
          "position"
          "position-percentage"
          "file-encoding"
        ];
      };
      inline-diagnostics = {
        cursor-line = "hint";
        other-lines = "error";
      };

      lsp.display-messages = true;
    };

    keys = {
      normal = {
        "$" = "goto_line_end";
        "0" = "goto_line_start";
        ";" = "command_mode";
        C-h = "jump_view_left";
        C-j = "jump_view_down";
        C-k = "jump_view_up";
        C-l = "jump_view_right";
        G = "goto_file_end";
        T = "extend_line_down";
        X = "extend_line_up";
        t = "extend_line_above";
        x = "extend_line_below";
        space = {
          i = ":toggle lsp.display-inlay-hints";
          o = ":format";
          m = {
            m = ":run-shell-command make";
            n = ":run-shell-command ninja -C build";
          };
          c = {
            r = ":run-shell-command cargo run";
            b = ":run-shell-command cargo build";
            t = ":run-shell-command cargo test";
          };
          R = ":reflow";
        };
      };
      select = {
        "$" = "goto_line_end";
        "0" = "goto_line_start";
        ";" = "command_mode";
        G = "goto_file_end";
        T = "extend_line_down";
        X = "extend_line_up";
        t = "extend_line_above";
        x = "extend_line_below";
        space.R = ":reflow";
      };
      insert.j.k = "normal_mode";
    };
  };
in {
  home.packages = with pkgs; [
    # extra lanugage servers
    nil
    alejandra
    bash-language-server
    shellcheck
    shfmt
  ];

  programs.helix = {
    enable = true;
    package = helix.packages.${system}.helix;
  };

  xdg.configFile = {
    "helix/languages.toml".text = std.serde.toTOML {
      inherit language language-server;
    };
    "helix/config.toml".text = std.serde.toTOML config;
  };
}
