# Define the log file path
log_file="/Users/$USER/miniforge3/miniforge_installation.log"

# install Miniforge in user's MacOS directory
export PREFIX=/Users/$USER/miniforge3

# Function to log messages
log() {
    local message="$1"
    logger -t "Miniforge3 installation" "$message"
    echo "$(date): $message" >> "$log_file"
}

# Initialize the log file if it doesn't exist
touch "$log_file"

#Download and install latest Miniforge
curl -LO https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-arm64.sh
log "Installing Miniforge..."
bash Miniforge3-MacOSX-arm64.sh -b -p $PREFIX/miniforge
source $PREFIX/miniforge/bin/activate
conda deactivate
conda init bash
rm Miniforge3-MacOSX-arm64.sh
log "Miniforge3 installation completed."


# Create the conda_cache directory if it doesn't exist
if [ ! -d "$PREFIX/conda_cache" ]; then
    log "Creating conda_cache directory at $PREFIX/conda_cache"
    mkdir -p "$PREFIX/conda_cache"
fi

# Update the CONDA_PKGS_DIRS variable in ~/.bash_profile
RELOCATE_CACHE="export CONDA_PKGS_DIRS=${PREFIX}/conda_cache"
if ! grep -qF "$RELOCATE_CACHE" ~/.bash_profile; then
  # If the line is not found, append it to ~/.bash_profile
  echo "$RELOCATE_CACHE" >> ~/.bash_profile
fi

# source ~/.bash_profile to load modifications
source ~/.bash_profile

log "Miniforge installation script completed."
# Explain the user the steps
echo "Type these two lines to activate miniconda"
# echo "export CONDA_PKGS_DIRS=${PREFIX}/conda_cache"
echo "source ${PREFIX}/miniforge/bin/activate"