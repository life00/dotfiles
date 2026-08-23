{ lib, buildGoModule, fetchFromGitHub }:

# ponytail: src/ is gitignored — copy source from original dev tree before building
# cp -r /path/to/awecron-src pkgs/awecron/src
let
  src = ../.gitignored/awecron-src; # placeholder path
in
# ponytail: fallback to fetchFromGitHub if local src absent
buildGoModule {
  pname = "awecron";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "life00";
    repo = "awecron";
    rev = "main";
    hash = lib.fakeHash; # ponytail: replace with actual hash after first build
  };

  subPackages = [ "." ];

  vendorHash = lib.fakeHash; # ponytail: replace with actual vendorHash after first build

  meta = with lib; {
    description = "Custom cron daemon with dynamic sleep";
    license = licenses.mit;
    mainProgram = "awecron";
  };
}
