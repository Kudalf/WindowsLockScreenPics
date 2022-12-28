#!/bin/sh
# Create a top folder if not exists
userName=13564
topFolder=$(printf "/c/Users/%s/Desktop/LockScreenPics" $userName)
sourceFolder=$(printf "/c/Users/%s/AppData/Local/Packages/Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy/LocalState/Assets" $userName)
echo $(printf "Top folder is: %s." $topFolder)
mkdir -p $topFolder

# Set working directory to the top folder
cd $topFolder
echo $(printf "PWD is: %s." $(pwd))

# Store the the last modified folder
lastModifiedFolder=$(ls -d -t */ | cut -f1 -d'/' | head -n 1)
echo $(printf "Last modified folder is: %s." $lastModifiedFolder)

# copy the newest pictures
now=$(Date +'%m-%d-%Y')
echo $(printf "Today's date is: %s." $now)
newFolder=$(printf "%s/%s" $topFolder $now)
echo $(printf "The new folder is: %s." $newFolder)
# Compare time. If the new folder is the same as the last modified, aka the script is run twice a day, abort
if [[ "$now" == $lastModifiedFolder ]]; then
	echo "The script has already been run today. Abort."
	sleep 5s
	exit 0
fi

# Create a new folder
mkdir -p $newFolder

# Move the pics to the new folder
cp -R "$sourceFolder"/* $newFolder
echo 'Moved!'

# Rename files to .jpg
for file in "$newFolder"/* ; do
	mv $file "$file.jpg"
done
echo 'Renamed!'

# If last modified and new folder are the same, remove the new folder
if diff -q $lastModifiedFolder $newFolder &>/dev/null; then
	rm -r $newFolder
	echo "No new changes since last update. Abort the process."
	sleep 5s
	exit 0
fi
echo "New pictures successfully saved!"
sleep 5s