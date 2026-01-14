# update command:
# nix shell np#bundix np#ruby_4_0 --command sh -c "export BUNDLE_FORCE_RUBY_PLATFORM=1 && cd vendored/git-pkgs && bundle lock && bundix --ruby=\$(ruby --version)"
{
  ruby,
  bundlerApp,
}: let
  pname = "git-pkgs";
in
  bundlerApp {
    inherit ruby pname;
    exes = [pname];
    gemdir = ./.;
    gemset = import ./gemset.nix;
  }
