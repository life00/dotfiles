{
  pkgs,
  ...
}:
let
  # python packages
  pythonEnv = pkgs.python3.withPackages (ps: [
    ps.jupyterlab
    ps.ipykernel
    ps.jupytext
    ps.matplotlib
    ps.pandas
    ps.seaborn
    ps.numpy
    ps.scipy
    ps.duckdb
    ps.pytest
  ]);

  # R packages
  rPkgs = with pkgs.rPackages; [
    dplyr
    ggplot2
    knitr
    rmarkdown
    readxl
    Rcpp
    styler
    car
    vcd
    zoo
    here
    usethis
    IRkernel
    vrtest
    cointReg
  ];
  rEnv = pkgs.rWrapper.override { packages = rPkgs; };

  quartoEnv = pkgs.callPackage ../pkgs/quarto { extraRPackages = rPkgs; };
in
{
  home.packages = [
    pythonEnv
    quartoEnv
    rEnv
  ];

  # kernels for every jupyter client
  home.sessionVariables.JUPYTER_PATH = toString (
    pkgs.jupyter-kernel.create {
      definitions = {
        python3 = {
          displayName = "Python 3";
          argv = [
            "${pythonEnv}/bin/python3"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "python";
          env = { };
          logo32 = null;
          logo64 = null;
          extraPaths = { };
        };
        ir = {
          displayName = "R";
          argv = [
            "${rEnv}/bin/R"
            "--slave"
            "-e"
            "IRkernel::main()"
            "--args"
            "{connection_file}"
          ];
          language = "R";
          env = { };
          logo32 = null;
          logo64 = null;
          extraPaths = { };
        };
      };
    }
  );
}
