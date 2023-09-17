```python
import os

def write_failed_packages(failed_pkgs):
    with open('failed_r_packages.txt', 'w') as f:
        for pkg in failed_pkgs:
            f.write(f"{pkg}\n")

def handle_errors(failed_pkgs):
    if failed_pkgs:
        print("The following packages failed to install:")
        for pkg in failed_pkgs:
            print(f"- {pkg}")
        write_failed_packages(failed_pkgs)
    else:
        print("All packages installed successfully.")

def log_errors(failed_pkgs):
    with open('install.log', 'a') as f:
        if failed_pkgs:
            f.write("The following packages failed to install:\n")
            for pkg in failed_pkgs:
                f.write(f"- {pkg}\n")
        else:
            f.write("All packages installed successfully.\n")
```