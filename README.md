# MINGW-KDE-Frameworks
Initial MINGW-KDE-Frameworks
The KDE Frameworks build on the Qt framework, providing everything from simple utility classes (such as those in KCoreAddons) to integrated solutions for common requirements of desktop applications (such as KNewStuff, for fetching downloadable add-on content in an application, or the powerful KIO multi-protocol file access framework).


# Using Hosted Binaries
### 1. Add to MSYS pacman config:

#### pacman.conf
[kde] Include = /etc/pacman.d/mirrorlist.kde

#### mirrorlist.kde
Server = https://github.com/claydonkey/MINGW-KDE-Frameworks/releases/download/5.37.0-1v0.9sr/

```
$ echo '[kde] Include = /etc/pacman.d/mirrorlist.kde' >> /etc/pacman.conf
$ echo 'Server = https://github.com/claydonkey/MINGW-KDE-Frameworks/releases/download/5.37.0-1v0.9sr/' > /etc/pacman.d/mirrorlist.kde 
```
### 2. Update pacman db

```
$ pacman -Sy

error: kde: key "CBD471804F360D3F" is unknown
:: Import PGP key 4096R/88ABBE3705D3B232380AAAE5CBD471804F360D3F, "Anthony Campbell (claydonkey) <anthony@claydonkey.com>", created:      2017-07-25? [Y/n] Y
:: Synchronizing package databases...
```

### 3. Add gpg to pacman:
```
$ pacman-key --lsign-key CBD471804F360D3F
```
check imported correctly
```
$ gpg --homedir /etc/pacman.d/gnupg/ --list-keys --keyid-format long
...
pub   4096R/CBD471804F360D3F 2017-07-25
uid                          Anthony Campbell (claydonkey) <anthony@claydonkey.com>
...
```

### 4. Update pacman db
```
pacman -Sy
```


# Building packages:

Uses github-release.exe (package in repo) and mutt.

```
cd mingw-w64-PKGBUILD-common
```
### To build and install locally
```
./build-install VERSION [GPGPHRASE]
```
### To build and upload
```
./build-upload VERSION [GPGPHRASE] [EMAIL]
```
### Generic command
using build-kf5
```
./build-kf5 -[shared static] -[release debug] -[nostrip strip] -[install] -[version] VERSION -[sign] GPGPHRASE 

```


