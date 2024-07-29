#!/bin/bash

# Script to automate the setup and sync of a new Obsidian vault from the docs_template repository

TEMPLATE_REPO_URL="https://github.com/cltj/docs_template.git"
TEMP_DIR=".template_temp"

# Function to prompt for the target directory
prompt_target_directory() {
  read -p "Enter the path to the target directory where the new vault will be created: " TARGET_DIR
  if [ ! -d "$TARGET_DIR" ]; then
    echo "Target directory does not exist. Please create it first."
    exit 1
  fi
}

# Function to create necessary directories
create_directories() {
  mkdir -p "$TARGET_DIR/.obsidian"
}

# Function to copy configuration files
copy_config() {
  cp -r .obsidian/* "$TARGET_DIR/.obsidian/"
}

# Function to initialize a new git repository
initialize_git() {
  cd "$TARGET_DIR"
  git init -b main
  git add .
  git commit -m "Initial commit from docs_template"
}

# Function to sync with the template repository
sync_template() {
  echo "Syncing with the docs_template repository..."

  # Clone the template repository to a temporary directory
  git clone $TEMPLATE_REPO_URL $TEMP_DIR

  # List of files to sync
  FILES_TO_SYNC=(
    ".obsidian/*"
    "README.md"
    "Index.md"
    "Archive/Archive.md"
    "Projects/Project.md"
    "Resources/Resource.md"
  )

  # Copy the specified files from the template to the target directory
  for file in "${FILES_TO_SYNC[@]}"; do
    cp -r $TEMP_DIR/$file "$TARGET_DIR/"
  done

  # Clean up the temporary directory
  rm -rf $TEMP_DIR
}

# Main function to run the setup
main() {
  prompt_target_directory
  echo "Setting up your new Obsidian vault at $TARGET_DIR..."
  create_directories
  copy_config
  initialize_git
  echo "Setup complete! Your new Obsidian vault is ready."
}

# Function to run the sync
sync() {
  prompt_target_directory
  echo "Syncing with the latest template at $TARGET_DIR..."
  sync_template
  echo "Sync complete!"
}

# Execute the main function
if [ "$1" == "sync" ]; then
  sync
else
  main
fi
