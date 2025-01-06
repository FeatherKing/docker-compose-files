#!/bin/bash

# Function to replace domain
replace_domain() {
  local folder="$1"
  local dry_run="$2"
  local domain="$3"

  find "$folder" -type f -print0 | while IFS= read -r -d $'\0' file; do
    if [[ "$dry_run" == "true" ]]; then
      echo "--- Processing file: $file ---"
      sed "s/$domain/replace\.me/g" "$file"
    else
      sed -i "s/$domain/replace\.me/g" "$file"
    fi
  done
}

# Get the folder path and domain
folder_path="$1"
dry_run="$2"
domain="$3" # Now required

# Check if folder exists
if [[ ! -d "$folder_path" ]]; then
  echo "Error: Folder '$folder_path' does not exist."
  exit 1
fi

# Check if domain is provided
if [[ -z "$domain" ]]; then
  echo "Error: Domain must be provided."
  exit 1
fi

# Replace domain
replace_domain "$folder_path" "$dry_run" "$domain"

if [[ "$dry_run" == "true" ]]; then
    echo "Dry run complete. No files were modified."
else
    echo "Replacement complete. Files have been modified."
fi
