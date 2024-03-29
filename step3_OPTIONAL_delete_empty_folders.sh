#!/opt/homebrew/bin/bash


shopt -s nullglob  # Allow finding no matches with globstar

# Base directory where your Takeout folders are located
base_dir="/Volumes/SeagateExp/Takeout"


# delete subfolder inside Takeout*
for takeout_folder in "${base_dir}"/Takeout*; do
  find "$takeout_folder"/* -type d -empty -delete
done

# delete folder Takeout*
for takeout_folder in "${base_dir}"/Takeout*; do
  if [[ ! "$(ls -A "$takeout_folder")" ]]; then
    rmdir "$takeout_folder"
  fi
done
