```python
import os
import subprocess
from conda_env_setup import setup_conda_env
from package_installation import read_pkg_list, install_conda_pkgs, install_pip_pkgs
from install_r_pkgs import install_r_pkgs
from error_handling import handle_failed_pkgs
from logging import log_installation

def install_conda_pkgs(env_name, pkg_input):
    # Step 1: Initialize Variables
    failed_pkgs = []
    pkgs_r = ""
    conda_pkgs = []
    pip_pkgs = []

    # Step 2: Check If Conda Environment Exists
    env_exists = setup_conda_env(env_name)

    # Step 3: Activate Conda Environment
    if not env_exists:
        os.system(f"conda activate {env_name}")

    # Step 4: Read Package List
    pkgs_r, conda_pkgs, pip_pkgs = read_pkg_list(pkg_input)

    # Step 5: Format R Packages List
    pkgs_r = pkgs_r.rstrip(',')
    pkgs_r = f"list({pkgs_r})"

    # Step 6: Install R Packages
    failed_r_pkgs = install_r_pkgs(pkgs_r)
    failed_pkgs.extend(failed_r_pkgs)

    # Step 7: Install Conda Packages
    failed_conda_pkgs = install_conda_pkgs(conda_pkgs)
    failed_pkgs.extend(failed_conda_pkgs)

    # Step 8: Install Pip Packages
    failed_pip_pkgs = install_pip_pkgs(pip_pkgs)
    failed_pkgs.extend(failed_pip_pkgs)

    # Step 9: Error Reporting and Logging
    handle_failed_pkgs(failed_pkgs)
    log_installation(failed_pkgs)

if __name__ == "__main__":
    env_name = input("Enter the name of the Conda environment: ")
    pkg_input = input("Enter the package list (filename or string): ")
    install_conda_pkgs(env_name, pkg_input)
```