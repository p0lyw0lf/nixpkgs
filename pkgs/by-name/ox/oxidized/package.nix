{
  lib,
  ruby,
  bundlerApp,
  bundlerUpdateScript,
}:

bundlerApp {
  pname = "oxidized";
  gemdir = ./.;

  inherit ruby;

  exes = [
    "oxidized"
    "oxs"
  ];

  passthru.updateScript = bundlerUpdateScript "oxidized";

  meta = with lib; {
    description = "Network device configuration backup tool. It's a RANCID replacement";
    homepage = "https://github.com/ytti/oxidized";
    license = licenses.asl20;
    maintainers = with maintainers; [ nicknovitski ];
    teams = [ teams.wdz ];
    platforms = platforms.linux;
  };
}
