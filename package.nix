{
  stdenv,
  libx11,
  libxcursor,
  libxrandr,
  libxinerama,
  libxi,
  libGLX,
  pkg-config,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "musializer";
  src = ./.;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libGLX
    libx11
    libxcursor
    libxrandr
    libxinerama
    libxi
  ];
  postConfigure = ''
    NIX_CFLAGS_COMPILE="$(pkg-config --libs \
    glx) $NIX_CFLAGS_COMPILE"
    $CC -o nob ./nob.c
  '';
  buildPhase = ''
    runHook preBuild
    ./nob
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -R build/ $out/bin
    runHook postInstall
  '';
})
