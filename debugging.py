```python
import logging

# Set up logging
logging.basicConfig(filename='install.log', level=logging.DEBUG)

def debug_print(variable_name, variable_value):
    """
    Function to print intermediate variables for debugging.
    """
    print(f"{variable_name}: {variable_value}")
    logging.debug(f"{variable_name}: {variable_value}")

def debug_install_conda_pkgs(env_name, pkg_input, failed_pkgs, env_exists, pkgs_r, conda_pkgs, pip_pkgs):
    """
    Function to debug the install_conda_pkgs function.
    """
    debug_print("env_name", env_name)
    debug_print("pkg_input", pkg_input)
    debug_print("failed_pkgs", failed_pkgs)
    debug_print("env_exists", env_exists)
    debug_print("pkgs_r", pkgs_r)
    debug_print("conda_pkgs", conda_pkgs)
    debug_print("pip_pkgs", pip_pkgs)
```