## Auto_pkg_install_R

### Build an automatic package installer from different package repositories

#### Tech stack
- Bash with conda installed 

#### Features

- **Environment Creation:** Create and activate a new conda environment if it doesn't already exist. The name of the environment is provided as the first bash argument.
- **Package File:** Install packages based on user input provided in a `pkg_file.txt` (second bash argument). The file should list the package names and their corresponding repositories.
- **Multi-Repository Support:** Supports installation of packages from CRAN, Bioconductor, Conda, and GitHub.
- **Devtools:** Includes mandatory installation of `devtools` package to handle installations from GitHub.
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


