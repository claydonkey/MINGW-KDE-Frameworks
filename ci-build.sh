#!/bin/bash

# AppVeyor and Drone Continuous Integration for MSYS2
# Author: Renato Silva <br.renatosilva@gmail.com>
# Author: Qian Hong <fracting@gmail.com>

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
message 'Processing changes' "${commits[@]}"
message 'List directory' $(ls $(dirname ${BASH_SOURCE[0]}))
test -z "${packages}" && success 'No changes in package recipes'
define_build_order || failure 'Could not determine build order'

# Build
MINGW_PREFIX="/mingw64"
MINGW_PACKAGE_PREFIX="mingw-w64-x86_64"
export MINGW_PREFIX="/mingw64"
export MINGW_PACKAGE_PREFIX="mingw-w64-x86_64"
message 'Building packages' "${packages[@]}"
execute 'Updating system' update_system
execute 'Location of cmake' whereis cmake
execute 'Location of cmake' whereis pactoys
execute 'Approving recipe quality' check_recipe_quality

for package in "${packages[@]}"; do
    execute 'Check Prefixes' echo $MINGW_PREFIX " " $MINGW_PACKAGE_PREFIX
    execute 'Building binary' makepkg  --noconfirm  --skippgpcheck --nocheck --syncdeps  --cleanbuild #--rmdeps
    execute 'Building source' makepkg --noconfirm --noprogressbar --skippgpcheck --allsource #--config '/etc/makepkg_mingw64.conf'
    execute 'Installing' yes:pacman --noprogressbar --upgrade *.pkg.tar.xz
    mv "${package}"/*.pkg.tar.xz artifacts
    mv "${package}"/*.src.tar.gz artifacts
    unset package
done
execute 'List root directory - post install' ls -l
execute 'List 64 share directory - post install' ls /mingw64/share
execute 'List share directory - post install' ls /usr/share
execute 'Location of sphinx-build - post install' whereis sphinx-build
# Deploy
cd artifacts || success 'All packages built successfully'
execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
execute 'Generating build references'  create_build_references  "${PACMAN_REPOSITORY_NAME:-ci-build}"
execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'x
