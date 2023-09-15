#!/bin/bash

install_conda_pkgs() {
  env_name="$1"
  pkg_input="$2"

  # Check if conda environment already exists
  env_exists=$(conda env list | awk '{print $1}' | grep -w $env_name)
  if [[ -z $env_exists ]]; then
    # If the environment doesn't exist, create it
    conda create -n $env_name r-base -y 2>&1 | tee install.log
  fi

  # Activate the environment
  conda activate $env_name

  # Initialize an empty string for R named list
  pkgs_r="list("

  # Check if the package input is a file or string
  if [[ -f $pkg_input ]]; then
    # Populate named list from file (format: package=source)
    while IFS="=" read -r key value; do
      pkgs_r+="${key}=\"${value}\","
    done < "$pkg_input"
  else
    # Populate named list from string (format: source:package,source:package,...)
    IFS="," read -ra pairs <<< "$pkg_input"
    for pair in "${pairs[@]}"; do
      IFS=":" read -r source pkg <<< "$pair"
      pkgs_r+="${pkg}=\"${source}\","
    done
  fi

  pkgs_r=${pkgs_r%,} # Remove trailing comma
  pkgs_r+=")"

  # R script
  Rscript - <<EOF | tee -a install.log
# Install devtools for GitHub packages
if (!require("devtools", quietly = TRUE))
    install.packages("devtools")

# Importing the dictionary of packages
pkgs <- $pkgs_r

# Install CRAN, Bioconductor, and GitHub packages
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

  # Install packages via Conda or pip
  for pkg in "${!packages[@]}"
  do
    # Conda installation
    if [ "${packages[$pkg]}" == "conda" ]; then
      for channel in "conda-forge" "r" "bioconda"
      do
        echo "Trying to install r-$pkg through Conda channel $channel..." | tee -a install.log
        conda run -n $env_name conda install -c $channel r-$pkg -y 2>&1 | tee -a install.log && break || echo "Could not install r-$pkg through Conda channel $channel, trying without 'r-' prefix..." | tee -a install.log
        if [ $? -ne 0 ]; then
          echo "Trying to install $pkg through Conda channel $channel..." | tee -a install.log
          conda run -n $env_name conda install -c $channel $pkg -y 2>&1 | tee -a install.log && break || echo "Could not install $pkg through Conda channel $channel" | tee -a install.log
        fi
      done
    # Pip installation
    elif [ "${packages[$pkg]}" == "pip" ]; then
      echo "Trying to install $pkg through pip..." | tee -a install.log
      conda run -n $env_name pip install $pkg 2>&1 | tee -a install.log || echo "Could not install $pkg through pip" | tee -a install.log
    fi
  done


}
