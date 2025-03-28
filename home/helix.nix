{
  pkgs,
  username,
  ...
}: let
  map-languages = langs:
    builtins.map
    (name: {inherit name;} // langs.${name})
    (builtins.attrNames langs);

  languages = {inherit language language-server;};

  language = map-languages {
    bash.formatter = {
      command = "shfmt";
      args = ["-i" "4"];
    };
    c.indent = {
      tab-width = 4;
      unit = "    ";
    };
    cpp.indent = {
      tab-width = 4;
      unit = "    ";
    };
    java.indent = {
      tab-width = 4;
      unit = "    ";
    };
    nix.formatter = {
      command = "alejandra";
      args = ["-q"];
    };
    python.language-servers = ["pyright" "ruff"];
    toml.language-servers = ["taplo"];
    typst.formatter.command = "typstyle";
    verilog = {
      language-servers = ["svls"];
      formatter = {
        command = "verible-verilog-format";
        args = ["--indentation_spaces" "4" "-"];
      };
    };
  };

  language-server = {
    nixd.command = "nixd";
    taplo = {
      command = "taplo";
      args = ["lsp" "stdio"];
    };
    pyright = {
      command = "pyright-langserver";
      args = ["--stdio"];
    };
    ruff = {
      command = "ruff";
      args = ["server" "--preview"];
    };
    rust-analyzer.config = {
      check.command = "clippy";
      cargo.targetDir = "/tmp/rust-analyzer";
    };
    svls.command = "svls";
    veryl-ls = {command = "veryl-ls";};
  };

  settings = {
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

      lsp.display-progress-messages = true;
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
    alejandra
    bash-language-server
    nil
    shellcheck
    shfmt
    taplo
  ];

  programs.helix = {
    enable = true;
    defaultEditor = true;
    inherit settings languages;
  };
}
