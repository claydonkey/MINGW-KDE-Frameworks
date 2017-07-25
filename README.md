## MINGW-KDE-Frameworks
Initial MINGW-KDE-Frameworks
The KDE Frameworks build on the Qt framework, providing everything from simple utility classes (such as those in KCoreAddons) to integrated solutions for common requirements of desktop applications (such as KNewStuff, for fetching downloadable add-on content in an application, or the powerful KIO multi-protocol file access framework).

# HOSTED BINARIES
### Add to MSYS pacman config:

vim /etc/pacman.conf

[kde]
Include = /etc/pacman.d/mirrorlist.kde

vim /etc/pacman.d/mirrorlist.kde

Server = https://github.com/claydonkey/MINGW-KDE-Frameworks/releases/download/0.1/

### Add gpg to pacman:

pacman-key --lsign-key CBD471804F360D3F

### update pacman db

pacman -Sy
pacman -Su
(pacman -Syy)

### To Do:
KF5WindowSystemTargets.cmake needs patching

set_target_properties(KF5::WindowSystem PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include/KF5/KWindowSystem;~~/mingw64/include/KF5;~~${_IMPORT_PREFIX}/include/KF5"
  INTERFACE_LINK_LIBRARIES "Qt5::Widgets"
)
