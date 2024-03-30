#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt update

# Upgrade non-system packages to their latest versions
echo "Upgrading packages..."
sudo apt -y upgrade

# Upgrade system packages, potentially handling dependencies
echo "Upgrading system packages..."
sudo apt -y dist-upgrade

# Remove unused packages, addressing potential non-empty directories
echo "Removing unused packages..."
sudo apt -y autoremove || {
  echo "Encountered issues removing unused packages. Attempting to address non-empty directories..."

  # Identify problematic directories
  ERROR_DIRS=$(apt-get autoremove --dry-run | grep "Directory not empty" | sed 's/[^/]*$//')

  # Recursively remove contents of problematic directories (use with caution)
  for DIR in $ERROR_DIRS; do
    echo "WARNING: Directory '$DIR' is not empty and will be recursively removed. Review contents before proceeding (use 'ls -l $DIR' to see files)."
    read -r -p "Continue removing contents and retry autoremove? (y/N) " response
    case "$response" in
      [yY]*)
        sudo rm -rf "$DIR"/*
        ;;
      *)
        echo "Skipping removal of '$DIR'. Autoremove may not complete successfully."
        ;;
    esac
  done

  # Retry autoremove with empty directories
  sudo apt -y autoremove
}

echo "Update and upgrade completed!"
