{
  lib,
  stdenv,
  requireFile,
  autoPatchelfHook,
  makeWrapper,
  versionCheckHook,
  desktop-file-utils,
  git,
  gtk3,
  xdg-utils,
  zenity,
  webkitgtk_4_1,
  glib-networking,
  vulkan-loader,
  libGL,
  libxkbcommon,
  wayland,
}: let
  build = "20261012-142610-e2b8656";
  version = "0.8.3";
  hash = "sha256-vMICgHolxxhYVhofV+A95F+94ZE4STAuNKLwo2xs/nk=";
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "tern";
    version = version;

    # Tern is closed source and, during its closed beta, published only through
    # Stencil's build service.
    # That service answers an unauthenticated request with a redirect to
    # auth.stencil.so.
    src = requireFile {
      name = "Tern-${finalAttrs.version}-linux-x86_64.tar.gz";
      url = "https://build.stencil.so/d/tern/${build}/Tern-${finalAttrs.version}-linux-x86_64.tar.gz";
      hash = hash;
    };

    unpackPhase = ''
      runHook preUnpack
      tar -xzf "$src"
      runHook postUnpack
    '';
    sourceRoot = "tern";

    dontConfigure = true;
    dontBuild = true;

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    # Tern links glibc, libstdc++, and libgcc_s.
    buildInputs = [stdenv.cc.cc.lib];

    # Tern draws through wgpu, which dlopens Vulkan, EGL and the Wayland client
    # instead of linking them, so patchelf sees no DT_NEEDED entry for any of
    # them. RUNPATH is what dlopen from the executable itself reads. The GPU
    # driver is not in the store: autoPatchelfHook replaces the RUNPATH
    # addDriverRunpath would have set, so that path is appended here instead.
    appendRunpaths = [
      (lib.makeLibraryPath [
        vulkan-loader
        libGL
        libxkbcommon
        wayland
      ])
      "/run/opengl-driver/lib"
    ];

    installPhase = ''
      runHook preInstall
      install -Dm755 tern $out/bin/tern
      runHook postInstall
    '';

    # git serves `tern plugin install`, and `tern register` shells out to the
    # desktop entry, icon and MIME caches.
    postFixup = ''
      mv $out/bin/tern $out/bin/.tern-wrapped
      makeWrapper $out/bin/.tern-wrapped $out/bin/tern \
        --prefix PATH : ${
        lib.makeBinPath [
          desktop-file-utils
          git
          gtk3
          zenity
          xdg-utils
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          webkitgtk_4_1
        ]
      } \
      --set GIO_EXTRA_MODULES "${glib-networking.out}/lib/gio/modules"
    '';

    # Runs the patched, wrapped binary: the only check that proves the artifact
    # still loads against this nixpkgs.
    doInstallCheck = true;
    nativeInstallCheckInputs = [versionCheckHook];
    versionCheckProgramArg = "--version";

    meta = {
      description = "Native multiplexing terminal for panes, files and remote sessions";
      homepage = "https://stencil.so/tern";
      # Nothing here can be rebuilt or redistributed: the artifact is the
      # product, and the build service gates it behind a Stencil account.
      license = lib.licenses.unfree;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      maintainers = [lib.maintainers.asterismono];
      mainProgram = "tern";
      platforms = ["x86_64-linux"];
    };
  })
