#!/opt/homebrew/bin/bash

# Directory of the 'all' folder
all_dir="/Users/tzhao9/Documents/Takeout/all"


echo "Starting the renaming process..."

# Function to rename files within a given year folder
rename_files_in_folder() {
    local folder_path="$1"
    echo "--------------------------------"
    echo "Processing folder: $folder_path"
    
    declare -A date_counts

    shopt -s nocasematch
    for json_file in "$folder_path"/*.json; do
        echo "*-*-*-*"
        echo "Processing JSON file: $json_file"
        if [[ -f "$json_file" ]]; then
            local base_name="${json_file%.json}"
            
            if [[ -f "$base_name" ]]; then
                    local ext="${base_name##*.}"
                    echo "Found corresponding file for JSON: $base_name with extension: $ext"

                    local photo_taken_time=$(jq -r '.photoTakenTime.formatted' "$json_file")
                    echo "Photo taken time extracted: '$photo_taken_time'"
                    
                    # Use Python to parse and format the date, and include the timezone abbreviation
                    local photo_date=$(python3 -c "import sys; from datetime import datetime; \
                    input_str = sys.argv[1].replace(u'\u202F', ' ').replace(u'\u00A0', ' '); \
                    dt = datetime.strptime(input_str, '%b %d, %Y, %I:%M:%S %p %Z'); \
                    print(dt.strftime('%Y_%m_%d_%I_%M_%S_%p') + ('_' + dt.strftime('%Z') if dt.strftime('%Z') else ''))" "$photo_taken_time" 2>/dev/null)
                    
                    echo "Formatted date: '$photo_date'"
                                        
                    if [[ -n "$photo_date" ]]; then
                        local seq=${date_counts[$photo_date]:=0}
                        let date_counts[$photo_date]++
                        local new_name="${photo_date}_$(printf "%02d" $((seq+1))).$ext"
                        echo "Attempting to rename $base_name to $new_name"
                        
                        mv "$base_name" "$folder_path/$new_name"
                        if [[ $? -eq 0 ]]; then
                            echo "Renamed $base_name to $new_name successfully."

                            # Check for corresponding live photo .MP4 file
                            base_name_without_ext="${base_name%.$ext}"
                            local live_photo_file="${base_name_without_ext}.MP4"

                            if [[ -f "$live_photo_file" ]]; then
                                local new_live_photo_name="${photo_date}_$(printf "%02d" $((seq+1))).MP4"
                                echo "Attempting to rename live photo $live_photo_file to $new_live_photo_name"
                                mv "$live_photo_file" "$folder_path/$new_live_photo_name"
                                if [[ $? -eq 0 ]]; then
                                    echo "Renamed live photo $live_photo_file to $new_live_photo_name successfully."
                                else
                                    echo "Failed to rename live photo $live_photo_file."
                                fi
                            fi
                            # Delete the used JSON file after successful rename
                            rm -f "$json_file"
                        else
                            echo "Failed to rename $file."
                        fi
                    else
                        echo "Failed to parse date for $json_file"
                        continue
                    fi
                fi
            else
                echo "JSON file not found: $json_file"
            fi
    done
    shopt -u nocasematch
}


for year_folder in "$all_dir"/Photos\ from*; do
    if [[ -d "$year_folder" ]]; then
        rename_files_in_folder "$year_folder"
    else
        echo "No 'Photos from XXXX' folders found in $all_dir."
    fi
done

echo "Renaming process complete."

