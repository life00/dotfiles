{
  pkgs,
  lib,
  ...
}:
let
  python = pkgs.python3.override {
    packageOverrides = lib.composeManyExtensions [
      (pkgs.callPackage ../pkgs/ort-webgpu { })
      (pkgs.callPackage ../pkgs/torchvulkan { })
      (
        _: super:
        # doclang tests need saxonche, whose GraalVM image requires 4k pages (Asahi uses 16k)
        lib.genAttrs [ "doclang" "docling-core" "docling-slim" "docling" ] (
          n: super.${n}.overridePythonAttrs { doCheck = false; }
        )
      )
      (
        _: super:
        # 4.8.0 caps hatchling<1.32 only to keep PyPI metadata <2.5; 1.32 builds it fine
        {
          mail-parser = super.mail-parser.overridePythonAttrs {
            pypaBuildFlags = [ "--skip-dependency-check" ];
          };
          # FIXME: remove once nixpkgs streamlit is >=1.66.1 (first release allowing pillow 13)
          streamlit = super.streamlit.overridePythonAttrs {
            version = "1.66.1";
            src = pkgs.fetchPypi {
              pname = "streamlit";
              version = "1.66.1";
              hash = "sha256-dxCotnRp2nr3vzUDybaK/KVnb4MvYvm9oSIeDOEZQdE=";
            };
          };
        })
    ];
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
      torch
      torchvulkan
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
    corrplot
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
