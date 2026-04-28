{pkgs, ...}: let
  map-languages = langs:
    map
    (name: {inherit name;} // langs.${name})
    (builtins.attrNames langs);

  languages = {inherit language language-server;};

  indent = n: {
    tab-width = n;
    unit = pkgs.lib.strings.replicate n " ";
  };

  language = map-languages {
    bash.formatter = {
      command = "shfmt";
      args = ["-i" "4"];
    };
    c.indent = indent 4;
    cpp.indent = indent 4;
    java.indent = indent 4;
    meson.formatter = {
      command = "meson";
      args = ["format" "-"];
    };
    nix.formatter = {
      command = "alejandra";
      args = ["-q"];
    };
    python.language-servers = [
      "pyrefly"
      "pyright"
      "ruff"
      "ty"
    ];
    tcl = {
      file-types = ["tcl" "xdc"];
      indent = indent 4;
    };
    toml.language-servers = ["taplo"];
    typst.formatter.command = "typstyle";
    verilog = {
      language-servers = ["svls"];
      file-types = ["v" "sv" "vh" "svh"];
      formatter = {
        command = "verible-verilog-format";
        args = ["--indentation_spaces" "4" "-"];
      };
    };
  };

  lsp = cmd: config: {
    inherit config;
    command = builtins.head cmd;
    args = builtins.tail cmd;
  };
  language-server = {
    nixd = lsp ["nixd"] {};
    pyrefly = lsp ["pyrefly" "lsp"] {
      pyrefly.displayTypeErrors = "force-on";
    };
    pyright = lsp ["basedpyright-langserver" "--stdio"] {};
    ruff = lsp ["ruff" "server" "--preview"] {};
    rust-analyzer = lsp ["rust-analyzer"] {
      check.command = "clippy";
      cargo.targetDir = true;
    };
    svls.command = "svls";
    taplo = lsp ["taplo" "lsp" "stdio"] {
      root_dir = [".git" "*.toml"];
    };
    ty = lsp ["ty" "server"] {};
    veryl-ls = lsp ["veryl-ls"] {};
  };

  settings = {
    theme = "catppuccin_mocha";

    editor = {
      auto-format = false;
      bufferline = "multiple";
      color-modes = true;
      cursorline = true;
      file-picker.hidden = false;
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
      end-of-line-diagnostics = "disable";

      lsp.display-progress-messages = true;
      lsp.auto-document-highlight = true;
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
    nixd
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
