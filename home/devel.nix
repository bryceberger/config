{pkgs, ...}: let
  clang-format-text = args:
    pkgs.lib.foldlAttrs
    (acc: name: value: acc + "${name}: ${toString value}\n")
    ""
    args;
in {
  home.packages = with pkgs; [
    sccache
  ];
  home.sessionVariables = {
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
  };
  home.file = {
    ".clang-format".text = clang-format-text {
      BasedOnStyle = "Google";
      IndentWidth = 4;
      PointerAlignment = "Left";
      BreakBeforeBraces = "Attach";
      AllowShortBlocksOnASingleLine = "Empty";
      AllowShortCaseLabelsOnASingleLine = "true";
      AllowShortIfStatementsOnASingleLine = "Never";
      AlignAfterOpenBracket = "BlockIndent";
      DerivePointerAlignment = "false";
      BinPackParameters = "false";
      BreakConstructorInitializers = "BeforeComma";
      AlignOperands = "DontAlign";
    };
  };
}
