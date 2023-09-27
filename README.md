# Multi-Package Installer For Conda Environments (Supports R Repositories)

### Problem
Manually installing multiple packages into a Conda environment can be a tedious process, especially when they come from different repositories such as Conda, Pip, CRAN, and Bioconductor. Users often find themselves switching between shell commands and R scripts, solving dependency issues, and searching for packages in various repositories.

### Goal
To streamline this process, this tool automates the installation of multiple packages from different repositories by simply taking a list of package names and their corresponding repositories as input.

#### Features
- **Environment Creation:** Automatically creates and activates a new Conda environment if it doesn't already exist.
- **Package File:** Reads from a pkg_file.txt to install packages. This file should contain package names along with their sources.
- **Manual Package Input:** Enables package installation using a comma-separated string format for package names and repositories.
- **Multi-Repository Support:** Supports Conda, Pip, CRAN, Bioconductor, and GitHub repositories.
- **GitHub Formatting:** Allows installation of GitHub packages using the username/package_name format.
- **Conda Channels:** Utilizes channels like conda-forge, r, and bioconda for package installations.
- **Shell Compatibility:** Works in both bash and zsh shells.
- **Dependency Handling:** Takes care of resolving package dependencies.


#### Installation
1. Make sure `~/.local/bin` is included in your PATH environment variable. If it's not, add the following line to your `.bashrc` or `.zshrc` and then run `source ~/.bashrc` or `source ~/.zshrc`:
   ```bash
   export PATH=$PATH:~/.local/bin
   ```
2. Run the following command to download `install_conda_pkgs.sh` and `pkg_file.txt`:
   ```bash
   curl -O https://raw.githubusercontent.com/ibishara/Automatic_Conda_Packages_Installer/main/install_conda_pkgs.sh && curl -O https://raw.githubusercontent.com/ibishara/Automatic_Conda_Packages_Installer/main/pkg_file.txt &&       chmod +x install_conda_pkgs.sh && mv install_conda_pkgs.sh ~/.local/bin/ && mv pkg_file.txt ~/
   ```

#### Usage
1.After installation, open the `pkg_file.txt` in your home directory and modify it to include the packages you want to install:
   ```bash
   vi ~/pkg_file.txt
   ```
Or use another text editor of your choice.

2. To install the packages, run the install_conda_pkgs script with the Conda environment name (ENV_NAME) and the path to `pkg_file.txt`:
   ```bash
   install_conda_pkgs "ENV_NAME" "~/pkg_file.txt"
   ```
Alternatively, you can specify packages directly as a string:
   ```bash
   install_conda_pkgs "ENV_NAME" "~/pkg_file.txt"
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


