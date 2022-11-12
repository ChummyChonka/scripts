#!/bin/bash
folder="/your/folder/here"
log="$folder/log"
error_log="$folder/errorlog"
suffix="comp.ogg"
audio_extensions="(ogg|opus|mp3|m4a|wav)"
lufs="-23"
quality="3"

#create logfiles if they don't exist
touch $log
touch $error_log

#converting all spaces in filenames to underscores
find $folder -depth -name '* *' -execdir bash -c 'for i; do mv "$i" "${i// /_}"; done' _ {} +

#reduce all double underscore to single underscore
find $folder -depth -name '* *' -execdir bash -c 'for i; do mv "$i" "${i//__/_}"; done' _ {} +

#look for multiple dots in filname, increase counter if filename does not match *.comp.ogg
counter=0
for f in $(find $folder -regextype gnu-awk -iregex ".*\..*\.$audio_extensions")
do
    filename=${f##*\/}
    ending=${filename#*.}
    if [[ $ending != $suffix ]]
    then
        counter=$((counter+1))
        echo $f >> $error_log
        echo " -> filname contains multiple dots which can cause issues with the script" >> $error_log
    fi
done
#if counter > 0 exit script and display # of errors
message="There have been $counter filename issues found"
if [[ $counter != 0 ]]
then
    echo "${message}, see errorlog for details"
    echo "exiting"
    exit 1
else
    echo "${message}, continuing with script execution"
fi

#find all audio files to convert
for f in $(find $folder -regextype gnu-awk -iregex ".*\.$audio_extensions")
do
    file=${f##*\/} #file without leading path
    filename=${file%%.*} #filename without extensions, this does remove ANY trailing extensions
    wholefile=${f%%.*}
    grep $filename $log > /dev/null #check if file has been processed before
    if [[ $? != 0 ]] #true when file NOT found in log
    then
        #do conversion and append file to log
        ffmpeg -y -i "$f" -c:a libvorbis -q:a $quality -af loudnorm=I=$lufs:dual_mono=true ${wholefile}.${suffix}
        echo $filename >> $log
    else
        #removes leading path from file leaving only the actual filename
        echo "skipped: $file"
    fi
done

echo "done"
echo "exiting script"
exit 0
