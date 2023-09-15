# Auto_pkg_install_R
## Automatic R Package Installer For Conda Environment

#### Features

- **Environment Creation:** Create and activate a new conda environment if it doesn't already exist.
- **Package File:** Install packages based on user input provided in a `pkg_file.txt`. The file should list the package names and their corresponding repositories.
- **Manual Package Input:** Install packages based on user input of repo:package in command line.
- **Multi-Repository Support:** Supports installation of packages from CRAN, Bioconductor, Conda, and GitHub.
- **GitHub Formatting:** Supports GitHub packages with the format `username/package_name`.
- **Conda Channels:** Installs Conda packages from the `conda-forge`, `r`, and `bioconda` channels.


#### Usage
1. Load the function into your terminal session or source it from a file:
   ```bash
   source pkg_install_v0.01.sh
   
2. Run the function, specifying the environment name and package file as arguments. Alternatively, you can provide a string to populate the named list of packages and their sources:

   ```bash
   # Using a package file
   setup_R_environment "analysis_test" "pkg_file.txt"
   
   # Using a string argument
   setup_R_environment "analysis_test" "CRAN:ggplot2,Bioconductor:ggtree,GitHub:jokergoo/ComplexHeatmap"
   ```
   #### Example `pkg_file.txt`: 
   ```
   # Format: package=source
   
   Seurat=CRAN
   treeio=Bioconductor
   ComplexHeatmap=GitHub:jokergoo/ComplexHeatmap
   data.table=conda
   ```


