```python
import os
import subprocess

def check_env_exists(env_name):
    cmd = "conda env list | awk '{print $1}' | grep '^" + env_name + "$'"
    env_exists = subprocess.run(cmd, shell=True, check=True, stdout=subprocess.PIPE).stdout.decode('utf-8').strip()
    return env_exists == env_name

def create_env(env_name):
    cmd = "conda create --name " + env_name + " r-base"
    subprocess.run(cmd, shell=True, check=True)

def activate_env(env_name):
    cmd = "conda activate " + env_name
    subprocess.run(cmd, shell=True, check=True)

def conda_env_setup(env_name):
    if not check_env_exists(env_name):
        create_env(env_name)
    activate_env(env_name)

if __name__ == "__main__":
    env_name = "your_env_name_here"
    conda_env_setup(env_name)
```
This Python script checks if a Conda environment with the specified name exists. If it doesn't, it creates a new environment and installs the `r-base` package. It then activates the environment.