## MINGW-KDE-Frameworks
Initial MINGW-KDE-Frameworks
The KDE Frameworks build on the Qt framework, providing everything from simple utility classes (such as those in KCoreAddons) to integrated solutions for common requirements of desktop applications (such as KNewStuff, for fetching downloadable add-on content in an application, or the powerful KIO multi-protocol file access framework).

# Using Hosted Binaries
### 1. Add to MSYS pacman config:

vim /etc/pacman.conf

[kde]
Include = /etc/pacman.d/mirrorlist.kde

vim /etc/pacman.d/mirrorlist.kde

Server = https://github.com/claydonkey/MINGW-KDE-Frameworks/releases/download/0.1/

### 2. Update pacman db

pacman -Sy

  error: kde: key "CBD471804F360D3F" is unknown
  :: Import PGP key 4096R/88ABBE3705D3B232380AAAE5CBD471804F360D3F, "Anthony Campbell (claydonkey) <anthony@claydonkey.com>", created:      2017-07-25? [Y/n] Y
  :: Synchronizing package databases...


### 3. Add gpg to pacman:

pacman-key --lsign-key CBD471804F360D3F

### 4. Update pacman db

pacman -Sy

### To Do:
KF5WindowSystemTargets.cmake needs patching

set_target_properties(KF5::WindowSystem PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include/KF5/KWindowSystem;~~/mingw64/include/KF5;~~${_IMPORT_PREFIX}/include/KF5"
  INTERFACE_LINK_LIBRARIES "Qt5::Widgets"
)
