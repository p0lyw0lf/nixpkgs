{
  lib,
  stdenvNoCC,
  fetchurl,
  makeBinaryWrapper,
  jre,
}:

stdenvNoCC.mkDerivation rec {
  version = "10.24.0";
  pname = "checkstyle";

  src = fetchurl {
    url = "https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${version}/checkstyle-${version}-all.jar";
    sha256 = "sha256-sREZA1/H9S3rXXW6qjyVwpLY75JQCqBooMEATUssvYM=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -D $src $out/checkstyle/checkstyle-all.jar
    makeWrapper ${jre}/bin/java $out/bin/checkstyle \
      --add-flags "-jar $out/checkstyle/checkstyle-all.jar"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Checks Java source against a coding standard";
    mainProgram = "checkstyle";
    longDescription = ''
      checkstyle is a development tool to help programmers write Java code that
      adheres to a coding standard. By default it supports the Sun Code
      Conventions, but is highly configurable.
    '';
    homepage = "https://checkstyle.org/";
    changelog = "https://checkstyle.org/releasenotes.html#Release_${version}";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.lgpl21;
    maintainers = with maintainers; [ pSub ];
    platforms = jre.meta.platforms;
  };
}
