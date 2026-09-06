{ lib, buildGoModule }:

buildGoModule {
  pname = "awecron";
  version = "0-unstable-2024-08-02";

  src = /home/user/dev/sysadmin/awecron;

  vendorHash = "sha256-/EGXT9nQjvVi9/8OIKb+GZszRQx8qANznTWlqK9RX2w=";
  subPackages = [ "." ];

  meta = with lib; {
    description = "Custom cron daemon with dynamic sleep";
    license = licenses.mit;
    mainProgram = "awecron";
  };
}
