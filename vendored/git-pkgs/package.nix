# update command:
# nix shell np#bundix np#ruby_4_0 --command sh -c "export BUNDLE_FORCE_RUBY_PLATFORM=1 && cd vendored/git-pkgs && bundle lock && bundix --ruby=\$(ruby --version)"
{
  lib,
  ruby,
  bundlerApp,
}: let
  pname = "git-pkgs";

  s = sha256: {
    inherit sha256;
    remotes = ["https://rubygems.org"];
    type = "gem";
  };
  overrides = {
    ffi.source = s "sha256-Dp8597s5NPd61v6rSWYr536H7tzesqP1wCNMKThWPUw=";
    sqlite3.source = s "sha256-7OnACzLsX1UNOko1xB6o1zhWNYnwkLnf0NUQt65fKWw=";
  };
in
  bundlerApp {
    inherit ruby pname;
    exes = [pname];
    gemdir = ./.;
    gemset = lib.recursiveUpdate (import ./gemset.nix) overrides;
  }
