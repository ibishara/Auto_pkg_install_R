# Multi-Package Installer For Conda Environments (Supports R Repositories)

### Problem
Installing different packages into a conda environment from different repos (e.g., R packages) is a manual, time consuming task. Usually, some packages are installable through conda shell scripting while others are available from inside R as CRAN, Bioconductor. 

Installation may include troubleshooting failed dependencies, finding alternative repos, going back and forth between shell and R environments. 

### Goal
Automate the installation process by simply providing package & repo names.

#### Features

- **Environment Creation:** Create and activate a new conda environment if it doesn't already exist.
- **Package File:** Install packages based on user input provided in a `pkg_file.txt`. The file should list the package names and their corresponding repositories.
- **Manual Package Input:** Install packages based on user input of repo:package in command line.
- **Multi-Repository Support:** Supports installation of packages from R language repos as CRAN and Bioconductor, in addition to Pip, Conda, and GitHub.
- **GitHub Formatting:** Supports GitHub packages with the format `username/package_name`.
- **Conda Channels:** Installs Conda packages from the `conda-forge`, `r`, and `bioconda` channels.
- **Shell Support:** bash and zsh 
- **Handles Failed Dependencies**

#### Usage
1. Download `install_conda_pkgs.sh` and `pkg_file.txt` using this command: `curl -O https://raw.githubusercontent.com/ibishara/Automatic_Conda_Packages_Installer/main/install_conda_pkgs.sh && curl -O https://raw.githubusercontent.com/ibishara/Automatic_Conda_Packages_Installer/main/pkg_file.txt && chmod +x install_conda_pkgs.sh && mv install_conda_pkgs.sh ~/.local/bin/ && mv pkg_file.txt ~/`
2. Use vim or nano to modify `pkg_file.txt` with package and repo names you'd like to install.
   ```bash
   vi ~/pkg_file.txt
   
4. Specify the conda environment name `"ENV_NAME"` and package file as arguments. Alternatively, you can provide a string to populate the named list of packages and their sources:

   ```bash
   # Using a package file
   install_conda_pkgs "ENV_NAME" "~/pkg_file.txt"
   
   # Or using a string argument
   install_conda_pkgs "ENV_NAME" "CRAN:ggplot2,Bioconductor:ggtree,GitHub:jokergoo/ComplexHeatmap,pip:numpy"
   ```
   #### Example `pkg_file.txt`: 
   ```
   # Format: package=source
   
   numpy=pip
   Seurat=CRAN
   treeio=Bioconductor
   ComplexHeatmap=GitHub:jokergoo/ComplexHeatmap
   data.table=conda

   ```


