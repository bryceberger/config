{
  lib,
  stdenvNoCC,
  git,
  cacert,
}:
lib.fetchers.withNormalizedHash {} ({
    url,
    revs,
    outputHash ? lib.fakeHash,
    outputHashAlgo ? null,
  }:
    stdenvNoCC.mkDerivation {
      name = lib.sources.urlToName url;
      builder = ./builder.sh;
      fetcher = ./fetcher.sh;

      nativeBuildInputs = [git cacert];

      inherit outputHash outputHashAlgo;
      outputHashMode = "recursive";

      inherit url revs;

      impureEnvVars =
        lib.fetchers.proxyImpureEnvVars
        ++ [
          "GIT_PROXY_COMMAND"
          "NIX_GIT_SSL_CAINFO"
          "SOCKS_SERVER"
          "FETCHGIT_HTTP_PROXIES"
        ];
    })
