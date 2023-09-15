## Auto_pkg_install_R

### Build an automatic package installer from different package repositories

#### Tech stack
- Bash with conda installed 

#### Features

- Create and activate a new conda environment if it doesn't already exist. Pass the environment name as the first bash argument.
- Install packages based on user input in `pkg_file.txt` (passed as the second bash argument), which includes the package name and the repository from which to install it.
- Support for multiple repositories: Install from CRAN, Bioconductor, Conda, or GitHub.
- Includes a mandatory installation of the `devtools` package to handle GitHub installations.
- For GitHub packages, the format is `username/package_name`.
- For Conda packages, installation is attempted from the conda-forge, r, and bioconda channels.

#### Usage
1. Load the function into your terminal session or source it from a file:
   ```bash
   source pkg_install_v0.01.sh
   
2. Run the function with the environment name and package file as arguments, or directly provide a named list from a string (format: source:package,source:package,...):

   ```bash
   setup_R_environment "analysis_test" "pkg_file.txt"
or
   ```bash
   setup_R_environment "analysis_test" "CRAN:ggplot2,Bioconductor:ggtree,GitHub:jokergoo/ComplexHeatmap"

