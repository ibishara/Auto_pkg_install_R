```python
import subprocess
import os

def install_r_pkgs(env_name, pkgs_r):
    failed_pkgs = []

    # Format R packages list
    pkgs_r = pkgs_r.rstrip(',')
    pkgs_r = f"list({pkgs_r})"

    # R script to install packages
    r_script = f"""
    pkgs <- {pkgs_r}
    for (pkg in names(pkgs)) {{
        if (!require(pkg, character.only = TRUE)) {{
            tryCatch({{
                if (pkgs[[pkg]] == 'CRAN') {{
                    install.packages(pkg, repos = 'http://cran.rstudio.com/')
                }} else if (pkgs[[pkg]] == 'Bioconductor') {{
                    if (!requireNamespace('BiocManager', quietly = TRUE))
                        install.packages('BiocManager')
                    BiocManager::install(pkg)
                }} else if (pkgs[[pkg]] == 'GitHub') {{
                    if (!requireNamespace('devtools', quietly = TRUE))
                        install.packages('devtools')
                    devtools::install_github(pkg)
                }}
            }}, error = function(e) {{
                write(paste(pkg, 'failed to install'), 'failed_r_packages.txt', append = TRUE)
            }})
        }}
    }}
    """

    # Write R script to a temporary file
    with open('temp.R', 'w') as f:
        f.write(r_script)

    # Run R script in the specified Conda environment
    cmd = f"conda run -n {env_name} Rscript temp.R"
    process = subprocess.Popen(cmd, shell=True)
    process.wait()

    # Remove temporary file
    os.remove('temp.R')
```