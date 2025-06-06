{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  zig,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "findup";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "booniepepper";
    repo = "findup";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EjfKNIYJBXjlKFNV4dJpOaXCfB5PUdeMjl4k1jFRfG0=";
  };

  nativeBuildInputs = [ zig.hook ];

  passthru.tests.version = testers.testVersion { package = finalAttrs.finalPackage; };

  meta = {
    # Doesn't support zig 0.12 or newer, last commit was 2 years ago.
    broken = lib.versionAtLeast zig.version "0.12";
    homepage = "https://github.com/booniepepper/findup";
    description = "Search parent directories for sentinel files";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booniepepper ];
    mainProgram = "findup";
  };
})
