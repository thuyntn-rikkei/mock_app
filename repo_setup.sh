#!/bin/bash

# set the hooksPath config to point to a versioned directory :
git config --local core.hooksPath ".githooks/"
chmod +x .githooks/pre-commit
echo "Hooks installed successfully!"