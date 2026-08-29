{ lib, buildGoModule }:

# ponytail: source comes from the LOCAL dev tree — `~/dev/src/awecron` (a
# clone of life00/awecron, branch `master`, with `go mod vendor` run inside).
# It must exist on the machine that builds this flake. It is NOT tracked in
# git (flakes cannot see gitignored/untracked paths, so an in-repo ./src
# fails to evaluate). fetchFromGitHub has no offline fallback.
buildGoModule {
  pname = "awecron";
  version = "0-unstable-2024-08-02";

  src = /home/user/dev/src/awecron;

  # go-toml/v2 is pre-vendored inside src/vendor (offline-friendly); passing
  # null makes buildGoModule use the on-disk vendor dir instead of hashing.
  vendorHash = null;

  subPackages = [ "." ];

  meta = with lib; {
    description = "Custom cron daemon with dynamic sleep";
    license = licenses.mit;
    mainProgram = "awecron";
  };
}