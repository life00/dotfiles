{ lib, buildGoModule }:

buildGoModule {
  pname = "awecron";
  version = "0-unstable-2024-08-02";

  src = /home/user/dev/sysadmin/awecron;

  vendorHash = null;
  subPackages = [ "." ];

  meta = with lib; {
    description = "Custom cron daemon with dynamic sleep";
    license = licenses.mit;
    mainProgram = "awecron";
  };
}
