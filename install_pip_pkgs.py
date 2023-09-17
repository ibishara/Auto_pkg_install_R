```python
import os
import subprocess

def install_pip_pkgs(env_name, pip_pkgs, failed_pkgs):
    for pkg in pip_pkgs:
        try:
            print(f"Installing {pkg} using pip...")
            subprocess.check_call(f"conda activate {env_name} && pip install {pkg}", shell=True)
            print(f"Successfully installed {pkg} using pip.")
        except subprocess.CalledProcessError:
            print(f"Failed to install {pkg} using pip.")
            failed_pkgs.append(pkg)
            with open("install.log", "a") as log_file:
                log_file.write(f"Failed to install {pkg} using pip.\n")
    return failed_pkgs
```