#!/bin/bash
folder="/your/folder/here"
1080p_folder="1080p"
4k_folder="2160p"

for f in "${folder}/*.png"
filename=${f##*\/} #removes leading path
do
    #convert to webp resize by half in both directions 2160p => 1080p
    convert "$f" -resize 50% -format webp -define webp:lossless=true "${folder}/${1080p_folder}/${filename%.*}.webp"
    #convert to webp as is 2160p => 2160p
    convert "$f" -format webp -define webp:lossless=true "${folder}/${4k_folder}/${filename%.*}.webp"
    echo "$f processed"
done
