
# GoogleTakeOutCleaner
Organize photos from Google Takeout by: (1) combining all photos together by each year and (2) renaming photos with the photo taken date.

## Running Time
Run each file on Mac terminal directly. The process takes less than 5 minutes for 60GB of photos.

## Before Running
1. Download photos from Google Takeout. You will have something like this:


![Enter image description here](https://github.com/zhaotianjing/GoogleTakeOutCleaner/blob/main/fig1.png)


2. Unzip them and rename the folders to "Takeout 1", "Takeout 2", "Takeout 3", etc.:


![Enter image description here](https://github.com/zhaotianjing/GoogleTakeOutCleaner/blob/main/fig2.png)
   
   
   Inside each folder is a single folder named "Google Photos", which contains folders named "Photos from YEAR" (e.g., "Photos from 2017", "Photos from 2023"). 

3. Copy all folders into a new folder "yourpath/Takeout/all".

   This means in the "all" folder, you will have "Takeout 1", "Takeout 2", "Takeout 3", etc.

## Running Bash Files in Terminal
**Step1: Optional & Recommended**
This bash file checks for folders not named "Photos from YEAR", for example, a folder named "Failed Videos".

**Step2: Must Run**
For instance, if "Takeout 1" and "Takeout 3" both have a folder named "Photos from 2017", this bash file will MOVE files from all "Photos from 2017" folders into a single folder "all/Photos from 2017". 
All years will be processed automatically. (Continuous years are not necessary.)

**Step3: Optional & Recommended**
After step2, all files for the year 2017 are moved into "all/Photos from 2017". This bash file deletes empty folders, helping you identify which files were not moved.

**Step4: Must Run**
This code renames all figures and movies with the date taken, extracted from the JSON file. For example, files named `IMG_3985.png`, `IMG_3985.png.json` will be renamed, e.g., to `2023_02_03_09_43_29_AM_01.png`, where `2023_02_03_09_43_29` is the year-month-day-hour-minute-second, AM/PM indicates morning or afternoon, and `01` is the sequence number (in case multiple photos were taken at the same time).

- Works for all file extensions (e.g., `.png`, `.PNG`, `.HEIC`, `mp4`...) because the original file extensions will be retained.
- Also works for live photos (e.g., `IMG_3985.mp4` will be renamed to `2023_02_03_09_43_29_AM_01.mp4`).
- The JSON file will be deleted after the successful rename.
- Some photo files without a corresponding JSON file will not be renamed.
- It takes less than 5 minutes for 60GB of photos.

**Step5: Optional**
This step addresses the special case where the JSON filename is missing a "0" at the end of the file name compared to the media file's name. For example, when you have `F6F16-00000.jpg` and `F6F16-0000.json`.

Check your folder to see whether this step is needed.

**Step6: Optional & Recommended**
You may have some JSON files without a corresponding photo file. This bash code deletes all such JSON files.

## Results
Inside the `all` folder, you will have folders named like `Photos from 2022`, and inside each folder, you will find photos like:
![Enter image description here](https://github.com/zhaotianjing/GoogleTakeOutCleaner/blob/main/fig3.png)
