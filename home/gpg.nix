{
  pkgs,
  gpg-key,
  ...
}: let
  pinentry = pkgs.pinentry-tty;
in {
  home.file = {
    ".gnupg/gpg-agent.conf".text = ''
      pinentry-program ${pinentry}/bin/pinentry
      default-cache-ttl 34560000
      max-cache-ttl 34560000
    '';
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = gpg-key;
      use-agent = true;
    };
  };
}
