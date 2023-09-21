#!/bin/bash

install_conda_pkgs() {
  env_name="$1"
  pkg_input="$2"

  # List to hold packages that failed to install
  failed_pkgs=()

# Check if conda environment already exists
env_exists=$(conda env list | awk '{print $1}' | grep -w $env_name)
if [[ -z $env_exists ]]; then
  # Add multiple channels
  conda config --add channels r
  conda config --add channels bioconda
  conda config --add channels conda-forge

  conda create -n $env_name r-base -y 2>&1 | tee install.log
fi

  # Activate the environment
  conda activate $env_name

  # Initialize an empty string for R named list elements
  pkgs_r=""

  # Initialize indexed arrays for Conda and Pip packages
  conda_pkgs=()
  pip_pkgs=()

  # Check if the package input is a file or a string
  if [[ -f $pkg_input ]]; then
    while IFS="=" read -r key value; do
      # Skip empty lines or malformed lines
      if [[ -z $key || -z $value || $key =~ ^# ]]; then continue; fi
      
      # Handle GitHub packages specially
      if [[ $value == GitHub* ]]; then
        repository=${value#GitHub:}
        pkgs_r+="${key}=\"GitHub:${repository}\","  # Append GitHub source tag
      else
        pkgs_r+="${key}=\"${value}\","
      fi

      # Fill the conda and pip package arrays
      if [[ $value == conda ]]; then
        conda_pkgs+=("$key")
      elif [[ $value == pip ]]; then
        pip_pkgs+=("$key")
      fi
    done < "$pkg_input"
  fi
  # Remove trailing comma and wrap the elements in list()
  pkgs_r=${pkgs_r%,}
  pkgs_r="list(${pkgs_r})"


  # Debug: Print pkgs_r
  echo "Debug: pkgs_r is $pkgs_r" | tee -a install.log

# R script for package installation
Rscript - <<EOF 2> R_stderr.log
  options(repos = 'https://cran.r-project.org')  # Set CRAN mirror
  failed_r_pkgs <- character(0)
  pkgs <- $pkgs_r
  for (pkg in names(pkgs)) {
    source <- pkgs[[pkg]]
    if (!require(pkg, character.only = TRUE)) {
      tryCatch({
        if (source == "CRAN") install.packages(pkg)
        else if (source == "Bioconductor") {
          if (!require("BiocManager", quietly = TRUE)) install.packages("BiocManager")
          BiocManager::install(pkg)
        } else if (startsWith(source, "GitHub:")) {
          repository <- sub("GitHub:", "", source)
          if (!require("devtools", quietly = TRUE)) install.packages("devtools")
          devtools::install_github(repository)
        }
      },
      error = function(e) {
        message(paste0("Could not install ", pkg, " through ", source))
        failed_r_pkgs <- c(failed_r_pkgs, pkg)
      })
    }
  }
  if (length(failed_r_pkgs) > 0) {
    message(paste0("Failed to install the following R packages: ", paste(failed_r_pkgs, collapse = ", ")))
    write(paste(failed_r_pkgs, collapse = ","), "failed_r_packages.txt")
  }
EOF

# Initialize arrays for missing and outdated dependencies
missing_deps=()
outdated_deps=()

# Parse the R stderr log to find missing and outdated dependencies
while IFS= read -r line; do
  # Change here for POSIX-compliant string comparison
  if [[ "$line" =~ "not available for package" ]]; then
    dep=$(echo "$line" | awk -F"‘|’" '{print $2}')
    missing_deps+=("$dep")
  # Change here for POSIX-compliant string comparison
  elif [[ "$line" =~ "is being loaded, but" ]] && [[ "$line" =~ "is required" ]]; then
    dep=$(echo "$line" | awk -F"‘|’" '{print $2}')
    outdated_deps+=("$dep")
  fi
done < "R_stderr.log"

# Remove duplicates
missing_deps=($(printf "%s\n" "${missing_deps[@]}" | sort -u))
outdated_deps=($(printf "%s\n" "${outdated_deps[@]}" | sort -u))

# Update outdated dependencies through Conda
for dep in "${outdated_deps[@]}"; do
  conda run -n $env_name conda update -c conda-forge "r-$dep" -y 2>&1 | tee -a install.log
done

# Install missing dependencies through Conda (as before)
for dep in "${missing_deps[@]}"; do
  installed=false
  for channel in "conda-forge" "r" "bioconda"; do
    conda run -n $env_name conda install -c $channel "r-$dep" -y 2>&1 | tee -a install.log && { installed=true; break; }
  done
  if [[ $installed == false ]]; then
    echo "Could not install r-$dep through Conda" | tee -a install.log
  fi
done

# If there were missing or outdated dependencies, rerun the function
if [ ${#missing_deps[@]} -ne 0 ] || [ ${#outdated_deps[@]} -ne 0 ]; then
  install_conda_pkgs "$env_name" "$pkg_input"
else
  echo "All packages installed successfully." | tee -a install.log
fi




  # Install Conda packages
  for pkg in "${conda_pkgs[@]}"; do
    installed=false
    for channel in "conda-forge" "r" "bioconda"; do
      conda run -n $env_name conda install -c $channel r-$pkg -y 2>&1 | tee -a install.log && { installed=true; break; }
    done
    if [[ $installed == false ]]; then
      failed_pkgs+=("r-$pkg (Conda)")
    fi
  done

  # Install Pip packages
  for pkg in "${pip_pkgs[@]}"; do
    conda run -n $env_name pip install $pkg 2>&1 | tee -a install.log || failed_pkgs+=("$pkg (pip)")
  done

  # Print the list of failed packages
  if [ ${#failed_pkgs[@]} -ne 0 ]; then
    echo "The following packages failed to install:" | tee -a install.log
    for pkg in "${failed_pkgs[@]}"; do
      echo "  - $pkg" | tee -a install.log
    done
  else
    echo "All packages installed successfully." | tee -a install.log
  fi
}
