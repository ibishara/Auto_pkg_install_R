#!/bin/bash

setup_R_environment() {
  env_name="$1"
  pkg_file="$2"

  env_exists=$(conda env list | awk '{print $1}' | grep -w $env_name)
  if [[ -z $env_exists ]]; then
    conda create -n $env_name r-base -y 2>&1 | tee install.log
  fi

  conda activate $env_name

  pkgs_r="list("
  
  while IFS="=" read -r key value; do
    pkgs_r+="${key}=\"${value}\","
  done < "$pkg_file"

  pkgs_r=${pkgs_r%,}
  pkgs_r+=")"

  Rscript - <<EOF | tee -a install.log
if (!require("devtools", quietly = TRUE))
    install.packages("devtools")

options(repos = c(CRAN = "https://cloud.r-project.org"))

pkgs <- $pkgs_r

for (pkg in names(pkgs)) {
  source <- pkgs[[pkg]]
  if (!require(pkg, character.only = TRUE)) {
    tryCatch(
      {
        if (source == "CRAN") {
          install.packages(pkg)
        } else if (source == "Bioconductor") {
          if (!require("BiocManager", quietly = TRUE))
            install.packages("BiocManager")
          BiocManager::install(pkg)
        } else if (source == "GitHub") {
          devtools::install_github(pkg)
        }
      },
      error = function(e) {
        message(paste0("Could not install ", pkg, " through ", source))
      }
    )
  }
}
EOF

  while IFS="=" read -r key value; do
    if [[ "$value" == "conda" ]]; then
      for channel in "conda-forge" "r" "bioconda"; do
        echo "Trying to install r-$key through Conda channel $channel..." | tee -a install.log
        conda run -n $env_name conda install -c $channel r-$key -y 2>&1 | tee -a install.log && break || echo "Could not install r-$key through Conda channel $channel, trying without 'r-' prefix..." | tee -a install.log
        if [ $? -ne 0 ]; then
          echo "Trying to install $key through Conda channel $channel..." | tee -a install.log
          conda run -n $env_name conda install -c $channel $key -y 2>&1 | tee -a install.log && break || echo "Could not install $key through Conda channel $channel" | tee -a install.log
        fi
      done
    fi
  done < "$pkg_file"
}

setup_R_environment $1 $2