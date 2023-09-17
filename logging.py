```python
import logging

# Initialize logging
logging.basicConfig(filename='install.log', level=logging.INFO)

def log_message(message):
    logging.info(message)

def log_error(error_message):
    logging.error(error_message)

def log_failed_packages(failed_pkgs):
    if failed_pkgs:
        log_message("The following packages failed to install:")
        for pkg in failed_pkgs:
            log_message(pkg)
    else:
        log_message("All packages installed successfully.")
```