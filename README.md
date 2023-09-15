## Auto_pkg_install_R

### Build an automatic package installer from different package repositories

### Tech stack
Bash with conda installed 

### Features

Create an activate new conda environment if doesn't exist as first bash argument
Install packages based on user input in pkg_file.txt (second bash argument) with package name and repository
Install from CRAN, Bioconductor, Conda, or github 
Includes mandatory installation of devtools package to handle github installations 
Install packages from github with format: username/package_name
Install conda packages from conda-forge, r, and bioconda channels

### Usage
Load the function into your terminal session or source it from a file
Source pkg_install_v0.01.sh
Run the function with the environment name and package file as arguments or populate named list from string (format: source:package,source:package,...)
Setup_R_environment "analysis_test" "pkg_file.txt"
Setup_R_environment "analysis_test" CRAN:ggplot2,Bioconductor:ggtree,GitHub:jokergoo/ComplexHeatmap"



