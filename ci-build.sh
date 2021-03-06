#!/bin/bash

# AppVeyor and Drone Continuous Integration for MSYS2
# Author: Renato Silva <br.renatosilva@gmail.com>
# Author: Qian Hong <fracting@gmail.com>
# Additions for Min-KDE-Frameworks: Anthony Campbell <anthony@claydonkey.com>

# Configure
cd "$(dirname "$0")"
source 'ci-library.sh'
mkdir artifacts
git_config user.email 'ci@claydonkey.com'
git_config user.name  'Claydonkey Continuous Integration'
git remote add upstream 'https://github.com/claydonkey/MINGW-KDE-Frameworks'
git fetch --quiet upstream

# Detect
list_commits  || failure 'Could not detect added commits'
list_packages || failure 'Could not detect changed files'
message 'Encrypt var test' $TEST_SECURE
message 'MSYSTEM' $MSYSTEM
message 'Processing changes' "${commits[@]}"
message 'List directory' $(ls $(dirname ${BASH_SOURCE[0]}))

test -z "${packages}" && success 'No changes in package recipes'
define_build_order || failure 'Could not determine build order'

# Build
#MINGW_PREFIX="/mingw64"
#MINGW_PACKAGE_PREFIX="mingw-w64-x86_64"
#export MINGW_PREFIX="/mingw64"
#export MINGW_PACKAGE_PREFIX="mingw-w64-x86_64"
message 'Building packages' "${packages[@]}"
execute 'Updating system' update_system
execute 'Approving recipe quality' check_recipe_quality
execute 'Check Prefixes' echo $MINGW_PREFIX " " $MINGW_PACKAGE_PREFIX
execute 'kf5 database - pre install' pacman --sync --search kf5

for package in "${packages[@]}"; do
    execute 'Building binary' makepkg  --noconfirm  --skippgpcheck --nocheck --syncdeps  --cleanbuild #--rmdeps
    execute 'Building source' makepkg --noconfirm --noprogressbar --skippgpcheck --allsource #--config '/etc/makepkg_mingw64.conf'
    execute 'Installing' yes:pacman --noprogressbar --upgrade --force *.pkg.tar.xz
    message 'Signing Package' 
    echo $KDE_PGP_PASSPHRASE | gpg -b --passphrase-fd 0  --default-key $KDE_PGP_KEY *.pkg.tar.xz
    mv "${package}"/*.pkg.tar.xz artifacts
    mv "${package}"/*.pkg.tar.xz.sig artifacts
    mv "${package}"/*.sig artifacts
    mv "${package}"/*.src.tar.gz artifacts
    unset package
done

#execute 'kf5 database - post install' pacman --sync --search kf5
#execute 'List root directory - post install' ls -l
#execute 'List 64 share directory - post install' ls -l /mingw64/bin
#execute 'List share directory - post install' ls -l /usr/share
#execute 'Location of sphinx-build - post  install' whereis sphinx-build
# Deploy
cd artifacts || success 'All packages built successfully'
execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
execute 'Generating build references'  create_build_references  "${PACMAN_REPOSITORY_NAME:-ci-build}"
execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
