#!/bin/bash
for d in `find . -type d -name 'mingw-w64-k*'`; do
echo $d
pushd $d

awk -v newsums="$(makepkg -g)" '
BEGIN {
  if (!newsums) exit 1
}

/^[[:blank:]]*(md|sha)[[:digit:]]+sums=/,/\)[[:blank:]]*$/ {
  if (!i) print newsums; i++
  next
}

1
' PKGBUILD > PKGBUILD.new && mv PKGBUILD{.new,}
popd
done

