#!/bin/bash
root=$PWD
#"/c/Users/User/Documents/Minnow/Source/MinGW/MINGW-KDE-Frameworks"
for f in $root/kde* 
do 
	echo "uploading $(basename $f)"
	github-release.exe upload -R -u claydonkey -n $(basename $f) -r mingw-KDE-Frameworks -t v0.1 -f $f
done



