#!/opt/homebrew/bin/bash


# Base directory where your Takeout folders are located
base_dir="/Volumes/SeagateExp/Takeout"
# Directory to consolidate all photos and non-standard folders
all_dir="${base_dir}/all"

# Create the 'all' directory if it doesn't already exist
mkdir -p "$all_dir"

# Loop through each Takeout folder
for takeout_folder in "${base_dir}"/Takeout*; do
	echo "-----------------"
    echo "Processing $takeout_folder..."
    
    # Path to the Google Photos directory in the current Takeout folder
    google_photos_dir="$takeout_folder/Google Photos"
    
    # Check if 'Google Photos' directory exists
    if [[ -d "$google_photos_dir" ]]; then
        # Loop through each item inside 'Google Photos'
        for item in "$google_photos_dir"/*; do
            # If the item is a directory
            if [[ -d "$item" ]]; then
                # Extract the base name of the item (folder name)
                item_name=$(basename "$item")
                
                # Check if the item follows the 'Photos from XXXX' naming convention
                if [[ "$item_name" =~ ^Photos\ from ]]; then
                    # Extract the year or specific name after 'Photos from'
                    year="$item_name"
                    
                    # Ensure the destination directory exists
                    mkdir -p "${all_dir}/${year}"
                    
                    # Move the contents of the current year's folder
                    mv "$item"/* "${all_dir}/${year}/"
                    
                    # After moving, check if the folder is empty and delete it if so
                    if [ -z "$(ls -A "$item")" ]; then
                        rmdir "$item"
                    fi
                else
                    # For non-standard folders, move them into a special directory within 'all'
                    # Ensure the destination directory exists
                    mkdir -p "${all_dir}/Non-standard folders/${item_name}"
                    
                    # Move the non-standard folder
                    mv "$item"/* "${all_dir}/Non-standard folders/${item_name}/"
                    
                    # After moving, check if the folder is empty and delete it if so
                    if [ -z "$(ls -A "$item")" ]; then
                        rmdir "$item"
                    fi
                fi
            fi
        done
    else
        echo "'Google Photos' directory not found in $takeout_folder."
    fi
done

echo "Photos and non-standard folders consolidation complete."
