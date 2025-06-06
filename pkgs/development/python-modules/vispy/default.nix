{
  lib,
  stdenv,
  buildPythonPackage,
  replaceVars,
  fetchPypi,
  cython,
  fontconfig,
  freetype-py,
  hsluv,
  kiwisolver,
  libGL,
  numpy,
  oldest-supported-numpy,
  packaging,
  pythonOlder,
  setuptools,
  setuptools-scm,
  wheel,
}:

buildPythonPackage rec {
  pname = "vispy";
  version = "0.15.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1S0QwGl/SJkFVc6iorrT+fWncjkYVv2jZOpLvGn9B1w=";
  };

  patches = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    (replaceVars ./library-paths.patch {
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      gl = "${libGL.out}/lib/libGL${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    cython
    oldest-supported-numpy
    setuptools
    setuptools-scm
    wheel
  ];

  buildInputs = [ libGL ];

  propagatedBuildInputs = [
    freetype-py
    hsluv
    kiwisolver
    numpy
    packaging
  ];

  doCheck = false; # otherwise runs OSX code on linux.

  pythonImportsCheck = [
    "vispy"
    "vispy.color"
    "vispy.geometry"
    "vispy.gloo"
    "vispy.glsl"
    "vispy.io"
    "vispy.plot"
    "vispy.scene"
    "vispy.util"
    "vispy.visuals"
  ];

  meta = with lib; {
    description = "Interactive scientific visualization in Python";
    homepage = "https://vispy.org/index.html";
    changelog = "https://github.com/vispy/vispy/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ goertzenator ];
  };
}
