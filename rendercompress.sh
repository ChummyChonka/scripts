#!/bin/bash
if [[ $# != 1 ]]
then
    echo "Usage: ./rendercompress.sh /insert/path/here"
    echo "0: $0"
    echo "exiting"
    exit 1
else
    if [[ -d $1 ]]
    then
        folder=$1
    fi
fi

#script is intended to work with 3840x2160 base renders
fullhd_folder="${folder}/fullhd"
ultrahd_folder="${folder}/ultrahd"
processed_folder="${folder}/processed"
trash_installed=true

#check if imagemagick is installed
if ! command -v convert &> /dev/null
then
    echo "'convert' not found. You need to install ImageMagick to run this script."
    echo "exiting"
    exit 1
fi

#check if trash-cli is installed
if ! command -v trash &> /dev/null
then
    echo "'trash-cli' is not installed on your system."
    echo "This script puts all thumbnails into the trashcan to allow for manual intervention."
    echo "Are you fine with fully deleting them instead? (y/n)"
    read
    if [[ $REPLY == "y" ]]
    then
        echo "Using 'rm' instead of 'trash'."
        trash_installed=false
    else
        echo "Please install 'trash-cli' to continue."
        echo "exiting"
        exit 1
    fi
fi

#setup folders if they do not exist
mkdir -p "${fullhd_folder}"
mkdir -p "${ultrahd_folder}"
mkdir -p "${processed_folder}"

#put thumbnails into trash or delete them
if [[ trash_installed == true ]]
then
    for t in $(find $folder -iname "*_png_icon.png"); do trash $t; done
else
    for t in $(find $folder -iname "*_png_icon.png"); do rm $t; done
fi

#do the actual compression
echo "starting the compression process..."
for f in $(find $folder -maxdepth 1 -iname "*.png")
do
    filename=${f##*\/} #removes leading path
    #convert to webp resize by half in both directions 2160p => 1080p
    convert "$f" -resize 50% -format webp -define webp:lossless=true "${fullhd_folder}/${filename%.*}.webp"
    #convert to webp as is 2160p => 2160p
    convert "$f" -format webp -define webp:lossless=true "${ultrahd_folder}/${filename%.*}.webp"
    #move original file into processed folder
    mv "$f" "${processed_folder}/${filename}"
    echo "processed: $filename"
done

echo "exiting"
exit 0