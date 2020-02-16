#!/bin/bash
#
# Copyright (C) 2014 Wenva <lvyexuwenfa100@126.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is furnished
# to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

set -e

SRC_FILE="$1"
DST_PATH="$2"
DST_PATH_LAUNCH_IMAGES="$3"
DST_PATH_RESOURCES="$4"

VERSION=1.0.0

info() {
     local green="\033[1;32m"
     local normal="\033[0m"
     echo "[${green}INFO${normal}] $1"
}

error() {
     local red="\033[1;31m"
     local normal="\033[0m"
     echo "[${red}ERROR${normal}] $1"
}

# Check dst path whether exist.
if [ ! -d "$DST_PATH" ];then
    mkdir -p "$DST_PATH"
fi

if [ -e "$SRC_FILE" ]
then
    echo "Source Image File Exists, Continuing..."
else
  echo "1024x1024 Icon Image File Doesn't Exists!"
  exit -1
fi
# Generate, refer to:https://developer.apple.com/library/ios/qa/qa1686/_index.html

info 'Generate Icon-AppStore.png ...'
sips -Z 1024 "$SRC_FILE" --out "$DST_PATH/Icon-AppStore.png"

info 'Generate Icon-App-20x20@1x ...'
sips -Z 20 "$SRC_FILE" --out "$DST_PATH/Icon-App-20x20@1x.png"

info 'Generate Icon-App-20x20@2x ...'
sips -Z 40 "$SRC_FILE" --out "$DST_PATH/Icon-App-20x20@2x.png"

info 'Generate Icon-App-20x20@3x ...'
sips -Z 60 "$SRC_FILE" --out "$DST_PATH/Icon-App-20x20@3x.png"

info 'Generate Icon-App-29x29@1x ...'
sips -Z 29 "$SRC_FILE" --out "$DST_PATH/Icon-App-29x29@1x.png"

info 'Generate Icon-App-29x29@2x ...'
sips -Z 58 "$SRC_FILE" --out "$DST_PATH/Icon-App-29x29@2x.png"

info 'Generate Icon-App-29x29@3x ...'
sips -Z 87 "$SRC_FILE" --out "$DST_PATH/Icon-App-29x29@3x.png"

info 'Generate Icon-App-40x40@1x ...'
sips -Z 40 "$SRC_FILE" --out "$DST_PATH/Icon-App-40x40@1x.png"

info 'Generate Icon-App-40x40@2x ...'
sips -Z 80 "$SRC_FILE" --out "$DST_PATH/Icon-App-40x40@2x.png"

info 'Generate Icon-App-40x40@3x ...'
sips -Z 120 "$SRC_FILE" --out "$DST_PATH/Icon-App-40x40@3x.png"

info 'Generate Icon-App-60x60@2x ...'
sips -Z 120 "$SRC_FILE" --out "$DST_PATH/Icon-App-60x60@2x.png"

info 'Generate Icon-App-60x60@3x ...'
sips -Z 180 "$SRC_FILE" --out "$DST_PATH/Icon-App-60x60@3x.png"

info 'Generate Icon-App-76x76@1x ...'
sips -Z 76 "$SRC_FILE" --out "$DST_PATH/Icon-App-76x76@1x.png"

info 'Generate Icon-App-76x76@2x ...'
sips -Z 152 "$SRC_FILE" --out "$DST_PATH/Icon-App-76x76@2x.png"

info 'Generate Icon-App-83.5x83.5@2x ...'
sips -Z 167 "$SRC_FILE" --out "$DST_PATH/Icon-App-83.5x83.5@2x.png"

info 'Generate Done.'

info 'Clearing Source Image File ...'
[ -e "$SRC_FILE" ] && rm -- "$SRC_FILE"
info 'Clearing Complete.'

info 'Moving Launch Images to LaunchImage folder ...'
files='Default@2x Default-568h@2x Default-667h Default-736h Default-812h Default-896h@2x Default-896h@3x'
for file in $files
do
  if [ -e "$DST_PATH_RESOURCES/$file.png" ]
  then
    mv "$DST_PATH_RESOURCES/$file.png" "$DST_PATH_LAUNCH_IMAGES/$file.png"
    info "Moving $file.png ..."
  fi

done

files='Default-Landscape~ipad Default-Landscape@2x~ipad'
for file in $files
do
  if [ -e "$DST_PATH_RESOURCES/$file.png" ]
  then
    cp "$DST_PATH_RESOURCES/$file.png" "$DST_PATH_LAUNCH_IMAGES/$file.png"
    info "Copy $file.png ..."
fi

done
info 'Moving Complete.'
