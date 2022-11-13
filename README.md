# scripts
Just various scripts I use on my linux desktop.
Most of them are useful for working with renpy, but some might be completely unrelated.

If you know your way around a linux terminal I would love to get some suggestions on how to improve my scripts.

## rendercompress.sh
This script can be used to compress Daz Studio .png output files to webp. It expects files with a resolution of 3840x2160 and compresses them losslessly to 3840x2160 as well as 1920x1080. It does the latter by reducing both axes to 50%. A 1920x1080 input file would therefor result in an 960x540 output file and so on.

I use this script to more easily create a 1080p version of my games for public release and a 4k version for patreons.

## normalize.sh
This script can be used to normalize various audio files in a folder and its subfolders and then compress them to an .ogg format. The script is intended to be able to run on the same folder multiple times like after new audio files have been added. It does this by keeping track of previously processed files in a log file. If you have edited a source file you can easily delete the single line listing that particular source file from the log or even delete the log entirely to have the script reprocess the entire sound library. This DOES overwrite existing output files which have been created by previous runs of the script.

I use this script to get the volume of multiple audio files to roughly the same level, so that I don't have to manually adjust the volume for each file seperately in renpy. I run this script from time to time on my ever growing sound/music library. It does take quite a while to run this script on a big library, so don't do this if you are pressed for time. Have it run in the background while doing something else.