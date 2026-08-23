{ lib, buildGoModule, fetchFromGitHub }:

# ponytail: src/ is gitignored — copy source from original dev tree before building
# cp -r /path/to/getmusic-src pkgs/getmusic/src
buildGoModule {
  pname = "getmusic";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "life00";
    repo = "getmusic";
    rev = "main";
    hash = lib.fakeHash; # ponytail: replace with actual hash after first build
  };

  subPackages = [ "." ];

  vendorHash = lib.fakeHash; # ponytail: replace with actual vendorHash after first build

  meta = with lib; {
    description = "Batch music downloader using yt-dlp";
    license = licenses.mit;
    mainProgram = "getmusic";
  };
}
