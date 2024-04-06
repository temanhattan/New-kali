#!/bin/bin/bash

# Update package lists
echo "gotta wrangle those wild package lists..."
sudo apt update
if [[ $? -ne 0 ]]; then
  echo "Uh, the package list gremlins seem to be at it again! Retrying..."
  sudo apt update
  if [[ $? -ne 0 ]]; then  
    echo "Giving up on the package gremlins for now. Update might be broken."
    exit 1
  fi
fi

# Upgrade non-system packages
echo "Time to unleash the upgrade kraken on those non-system packages..."
sudo apt -y upgrade
if [[ $? -ne 0 ]]; then
  echo "Looks like some upgrades got lost in the code dimension! Retrying..."
  sudo apt -y upgrade
  if [[ $? -ne 0 ]]; then
    echo "The code dimension seems like a tricky place. Skipping non-system upgrades."
  fi
fi

# Upgrade system packages with dependency handling
echo "Summoning the dependency wranglers for system package upgrades..."
sudo apt -y full-upgrade

# Remove unused packages
echo "Let's banish the unused package ghosts..."
sudo apt -y autoremove
AUTOREMOVE_EXIT=$?

# Handle non-empty directories (safer approach)
if [[ $AUTOREMOVE_EXIT -ne 0 ]]; then
  echo "Whoa! Found some stubborn packages clinging to their directories. "
  echo "Here's a list of the haunted directories (use 'ls -l <directory>' to see whats lurking):"
  apt-get autoremove --simulate | grep "Directory not empty" | cut -d':' -f1
  echo "You might want to appease the package spirits before retrying autoremove."
fi

echo "Update and upgrade complete! (Hopefully no gremlins or package ghosts were harmed)"
