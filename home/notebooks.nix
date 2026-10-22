{
  pkgs,
  lib,
  ...
}:
let
  python = pkgs.python3.override {
    packageOverrides = lib.composeExtensions (pkgs.callPackage ../pkgs/ort-webgpu { }) (
      _: super:
      # doclang tests need saxonche, whose GraalVM image requires 4k pages (Asahi uses 16k)
      lib.genAttrs [ "doclang" "docling-core" "docling-slim" "docling" ] (
        n: super.${n}.overridePythonAttrs { doCheck = false; }
      )
    );
  };

  # python packages
  pythonEnv = python.buildEnv.override {
    ignoreCollisions = true;
    extraLibs = with python.pkgs; [
      pip
      jupyterlab
      ipykernel
      jupytext
      matplotlib
      pandas
      seaborn
      numpy
      scipy
      duckdb
      docling
      onnxruntime-ep-webgpu
      pytest
      mlflow
      pyarrow
      python-dotenv
      pyyaml
      scikit-learn
      yfinance
    ];
  };

  # R packages
  rPkgs = with pkgs.rPackages; [
    dplyr
    ggplot2
    knitr
    languageserver
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
    moments
    sandwich
    MCS
    fastDummies
    glmnet
    rpart_plot
    ranger
    gbm
    foreach
    doParallel
    grpreg
    xgboost
    igraph
    margins
    neuralnet
    NeuralNetTools
  ];
  rEnv = pkgs.rWrapper.override { packages = rPkgs; };

  quartoEnv = pkgs.callPackage ../pkgs/quarto { extraRPackages = rPkgs; };

  # rstudio's bundled quarto pairs with nixpkgs pandoc (see pkgs/quarto); its wrapper only --set-default's QUARTO_PANDOC
  rstudioEnv = pkgs.symlinkJoin {
    name = "rstudio";
    paths = [ (pkgs.rstudioWrapper.override { packages = rPkgs; }) ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/rstudio --set QUARTO_PANDOC ${quartoEnv}/bin/tools/pandoc
    '';
  };
in
{
  home.packages = [
    pythonEnv
    quartoEnv
    rEnv
    rstudioEnv
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
