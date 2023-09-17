```python
import os
import subprocess
import shlex

def install_conda_pkgs(env_name, pkg_input):
    failed_pkgs = []
    pkgs_r = ""
    conda_pkgs = []
    pip_pkgs = []

    # Check if Conda environment exists
    env_exists = subprocess.run(shlex.split(f"conda env list | awk '{{print $1}}' | grep ^{env_name}$"), capture_output=True, text=True).stdout

    # If environment doesn't exist, create it and install r-base
    if not env_exists:
        subprocess.run(shlex.split(f"conda create --name {env_name} r-base"), check=True)

    # Activate Conda environment
    os.environ["CONDA_DEFAULT_ENV"] = env_name

    # Read package list
    if os.path.isfile(pkg_input):
        with open(pkg_input, 'r') as f:
            for line in f:
                if not line.startswith("#"):
                    key, value = line.strip().split("=")
                    if value == "CRAN" or value == "Bioconductor" or value == "GitHub":
                        pkgs_r += f"'{key}'='{value}',"
                    elif value == "conda":
                        conda_pkgs.append(key)
                    elif value == "pip":
                        pip_pkgs.append(key)

    # Format R packages list
    pkgs_r = "list(" + pkgs_r.rstrip(",") + ")"

    # Install R packages
    r_code = f"""
    pkgs <- {pkgs_r}
    for (pkg in names(pkgs)) {{
        if (!require(pkg, character.only = TRUE)) {{
            if (pkgs[pkg] == 'CRAN') {{
                install.packages(pkg)
            }} else if (pkgs[pkg] == 'Bioconductor') {{
                if (!requireNamespace('BiocManager', quietly = TRUE))
                    install.packages('BiocManager')
                BiocManager::install(pkg)
            }} else if (pkgs[pkg] == 'GitHub') {{
                if (!requireNamespace('devtools', quietly = TRUE))
                    install.packages('devtools')
                devtools::install_github(pkg)
            }}
        }}
    }}
    """
    try:
        subprocess.run(["Rscript", "-e", r_code], check=True)
    except subprocess.CalledProcessError:
        failed_pkgs.append(pkg)

    # Install Conda packages
    for pkg in conda_pkgs:
        try:
            subprocess.run(shlex.split(f"conda install --channel conda-forge --channel r --channel bioconda {pkg}"), check=True)
        except subprocess.CalledProcessError:
            failed_pkgs.append(pkg)

    # Install Pip packages
    for pkg in pip_pkgs:
        try:
            subprocess.run(shlex.split(f"pip install {pkg}"), check=True)
        except subprocess.CalledProcessError:
            failed_pkgs.append(pkg)

    # Error reporting and logging
    with open("install.log", 'a') as f:
        if failed_pkgs:
            f.write(f"Failed to install the following packages: {', '.join(failed_pkgs)}\n")
        else:
            f.write("All packages installed successfully.\n")
```