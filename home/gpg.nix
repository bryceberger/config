{pkgs, ...}: let
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
      default-key = "FDBF801F1CE5FB66EC3075C058CA4F9FEF8F4296";
      use-agent = true;
    };
  };
}
