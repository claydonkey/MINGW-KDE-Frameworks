#!/bin/bash
root=$PWD
# makepkg -f --sign
for f in $root/mingw-w64* 
do 
	echo "uploading $(basename $f)"
	 github-release.exe upload -R -u claydonkey -n $(basename $f) -r mingw-KDE-Frameworks -t v0.1 -f $f
done
for f in $root/mingw-w64*.pkg.tar.xz
do
	echo "adding $(basename $f) to db"
	 repo-add -s ~/Documents/Minnow/Source/MinGW/MINGW-KDE-Frameworks/kde.db.tar.xz $f  
done
#cd ..
#./createdb.sh

