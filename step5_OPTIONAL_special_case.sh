#!/opt/homebrew/bin/bash

# Directory of the 'all' folder
all_dir="/Users/tzhao9/Documents/Takeout/all"

echo "Starting the renaming process..."

####################################################################################
# Special case: handle the specific matching case ("a(1).extension" matching with "a.extension(1).json")
#   - e.g.,:
#   - IMG_3943(1).HEIC
#   - IMG_3943.HEIC(1).json
####################################################################################
rename_files_in_folder() {
    local folder_path="$1"
    echo "--------------------------------"
    echo "Processing folder: $folder_path"

    shopt -s nocasematch
    shopt -s nullglob

    # Loop over JSON files following the special naming convention
    for json_file in "$folder_path"/*\(1\).json; do
        echo "*-*-*-*"
        echo "Processing JSON file: $json_file"

        # Extracting the necessary components from the JSON filename
        local base_name_with_ext="${json_file##*/}" # Extract filename from path; IMG_3943.HEIC(1).json
        base_name_with_ext="${base_name_with_ext%\(1\).json}" # Remove (1).json part; IMG_3943.HEIC
        local base_name="${base_name_with_ext%.*}" # Extract base name without extension;  IMG_3943
        local extension="${base_name_with_ext##*.}" # Extract extension; HEIC

        # Construct the expected image filename
        local expected_image_filename="${base_name}(1).${extension}" #IMG_3943(1).HEIC
        local image_file_path="${folder_path}/${expected_image_filename}"

        echo "Looking for image file: $image_file_path"

        if [[ -f "$image_file_path" ]]; then
            echo "Found matching image file: $expected_image_filename"

            # Extract photo taken time from JSON
            local photo_taken_time=$(jq -r '.photoTakenTime.timestamp' "$json_file")
            if [[ -z "$photo_taken_time" || "$photo_taken_time" == "null" ]]; then
                echo "Photo taken time not found or invalid in $json_file"
                continue
            fi
            
            # Convert timestamp to a more readable format, assuming timestamp is in seconds
            local new_file_name=$(date -r "$photo_taken_time" +"%Y_%m_%d_%H_%M_%S")

            # Construct new path for the image file
            local new_path="${folder_path}/${new_file_name}.${extension}"
            echo "Renaming $image_file_path to $new_path"

            # Perform the renaming
            mv "$image_file_path" "$new_path"
            if [[ $? -eq 0 ]]; then
                echo "Successfully renamed to $new_path"
                # Delete the used JSON file after successful rename
                rm -f "$json_file"
            else
                echo "Failed to rename $image_file_path"
            fi
        else
            echo "No matching image file found for JSON: $json_file"
        fi
    done

    shopt -u nocasematch
    shopt -u nullglob
}

# Assuming $all_dir is correctly set to the parent directory of your "Photos from XXXX" folders
# all_dir="/Volumes/SeagateExp/Takeout/all"
for year_folder in "$all_dir"/Photos\ from*; do
    if [[ -d "$year_folder" ]]; then
        rename_files_in_folder "$year_folder"
    else
        echo "No 'Photos from XXXX' folders found in $all_dir."
    fi
done
#
