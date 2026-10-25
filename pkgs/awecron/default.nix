{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule {
  pname = "awecron";
  version = "0-unstable-2024-07-06";

  src = fetchFromGitHub {
    owner = "life00";
    repo = "awecron";
    rev = "158016731bf746d85c56331e5bb9a9c1e1a6128e";
    hash = "sha256-GAPMlipuqY5ZPVzM8VuBw89WmbDpJCczw93lSPq2eew=";
  };

  vendorHash = "sha256-/EGXT9nQjvVi9/8OIKb+GZszRQx8qANznTWlqK9RX2w=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Custom cron daemon with dynamic sleep";
    license = licenses.mit;
    mainProgram = "awecron";
  };
}
