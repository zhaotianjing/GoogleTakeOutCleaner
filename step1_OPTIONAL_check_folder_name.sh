#!/opt/homebrew/bin/bash

# Change to the directory where all your Takeout folders are located
cd /Volumes/SeagateExp/Takeout

# Loop through each Takeout folder
for takeout_folder in Takeout*; do
    echo "Checking in $takeout_folder..."
    # Check if 'Google Photos' directory exists inside
    if [[ -d "$takeout_folder/Google Photos" ]]; then
        # Find all directories inside 'Google Photos' that do not start with 'Photos from'
        for folder in "$takeout_folder/Google Photos"/*; do
            if [[ -d "$folder" && ! $(basename "$folder") =~ ^Photos\ from ]]; then
                # Print the name of the directory that doesn't match the pattern
                echo " !! Found non-standard folder: $folder"
            fi
        done
    else
        echo "'Google Photos' directory not found in $takeout_folder."
    fi
done