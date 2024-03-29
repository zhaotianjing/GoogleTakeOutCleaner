#!/opt/homebrew/bin/bash

# Directory of the 'all' folder
all_dir="/Users/tzhao9/Documents/Takeout/all"

echo "Starting the renaming process..."

# Assuming $all_dir is correctly set to the parent directory of your "Photos from XXXX" folders
# all_dir="/Volumes/SeagateExp/Takeout/all"
for year_folder in "$all_dir"/Photos\ from*; do
    if [[ -d "$year_folder" ]]; then
            find "$year_folder" -name '*.json' -type f -exec rm {} + 
    fi
done