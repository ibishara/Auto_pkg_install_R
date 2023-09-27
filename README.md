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
- **Handles Failed Dependencies:**

#### Usage
1. Download `install_conda_pkgs.sh` and `pkg_file.txt`. 
2. Load the function into your terminal session or source it from a file:
   ```bash
   source install_conda_pkgs.sh
   
3. Run the function, specifying the environment name and package file as arguments. Alternatively, you can provide a string to populate the named list of packages and their sources:

   ```bash
   # Using a package file
   install_conda_pkgs "ENV_NAME" "pkg_file.txt"
   
   # Using a string argument
   install_conda_pkgs "ENV_NAME" "CRAN:ggplot2,Bioconductor:ggtree,GitHub:jokergoo/ComplexHeatmap,pip:numpy"
   ```
   #### Example `pkg_file.txt`: 
   ```
   # Format: package=source
   
   Seurat=CRAN
   treeio=Bioconductor
   ComplexHeatmap=GitHub:jokergoo/ComplexHeatmap
   data.table=conda
   numpy=pip
   ```

#### Limitations
1. Cannot deal with library dependencies errors (yet).
