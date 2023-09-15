#!/bin/bash

install_conda_pkgs() {
  env_name="$1"
  pkg_input="$2"

  # Check if conda environment already exists
  env_exists=$(conda env list | awk '{print $1}' | grep -w $env_name)
  if [[ -z $env_exists ]]; then
    conda create -n $env_name r-base -y 2>&1 | tee install.log
  fi

  # Activate the environment
  conda activate $env_name

  # Initialize an empty string for R named list
  pkgs_r="list()"

  # Initialize indexed arrays for Conda and Pip packages
  conda_pkgs=()
  pip_pkgs=()

  # Check if the package input is a file or string
  if [[ -f $pkg_input ]]; then
    while IFS="=" read -r key value; do
      if [[ $key =~ ^# ]]; then continue; fi  # Skip comment lines
      if [[ $value == GitHub* ]]; then
        repository=${value#GitHub:}
        pkgs_r+="${key}=\"${repository}\","
        value="GitHub"
      else
        pkgs_r+="${key}=\"${value}\","
      fi
      if [[ $value == conda ]]; then
        conda_pkgs+=("$key")
      elif [[ $value == pip ]]; then
        pip_pkgs+=("$key")
      fi
    done < "$pkg_input"
  else
    IFS="," read -ra pairs <<< "$pkg_input"
    for pair in "${pairs[@]}"; do
      IFS=":" read -r source pkg <<< "$pair"
      pkgs_r+="${pkg}=\"${source}\","
    done
  fi

  pkgs_r=${pkgs_r%,}  # Remove trailing comma
  pkgs_r+=")"

  # R script for package installation
  Rscript - <<EOF | tee -a install.log
    options(repos = 'https://cran.r-project.org')  # Set CRAN mirror
    if (!require("devtools", quietly = TRUE)) install.packages("devtools")
    if (!require("fs", quietly = TRUE)) install.packages("fs")  # Install missing 'fs' package
    pkgs <- $pkgs_r
    for (pkg in names(pkgs)) {
      source <- pkgs[[pkg]]
      message(paste0("Currently installing ", pkg, " from ", source))
      if (!require(pkg, character.only = TRUE)) {
        tryCatch({
          if (source == "CRAN") install.packages(pkg)
          else if (source == "Bioconductor") {
            if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager")
            BiocManager::install(pkg)
          } else if (source == "GitHub") devtools::install_github(pkg)
        },
        error = function(e) { message(paste0("Could not install ", pkg, " through ", source)) })
      }
    }
EOF


  # Install Conda or Pip packages
  for pkg in "${conda_pkgs[@]}"; do
    echo "Currently installing $pkg through conda..." | tee -a install.log
    # Conda installation loop through channels
    for channel in "conda-forge" "r" "bioconda"; do
      echo "Trying to install r-$pkg through Conda channel $channel..." | tee -a install.log
      conda run -n $env_name conda install -c $channel r-$pkg -y 2>&1 | tee -a install.log && break || echo "Could not install r-$pkg through Conda channel $channel, trying without 'r-' prefix..." | tee -a install.log
      if [ $? -ne 0 ]; then
        echo "Trying to install $pkg through Conda channel $channel..." | tee -a install.log
        conda run -n $env_name conda install -c $channel $pkg -y 2>&1 | tee -a install.log && break || echo "Could not install $pkg through Conda channel $channel" | tee -a install.log
      fi
    done
  done

  for pkg in "${pip_pkgs[@]}"; do
    echo "Currently installing $pkg through pip..." | tee -a install.log
    conda run -n $env_name pip install $pkg 2>&1 | tee -a install.log || echo "Could not install $pkg through pip" | tee -a install.log
  done
}
