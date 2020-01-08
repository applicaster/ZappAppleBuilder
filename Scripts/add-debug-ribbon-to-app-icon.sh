#!/bin/sh
IFS=$'\n'
CURRENT_DIR=$1

# install for icon ribbon
brew install ImageMagick

RIBBON_IMAGE_DIR="${CURRENT_DIR}/Scripts/Resources"
ORIG_RIBBON_IMAGE="${RIBBON_IMAGE_DIR}/debug-icon-ribbon.png"
RESIZED_RIBBON_IMAGE="$RIBBON_IMAGE_DIR/debug-icon-ribbon-resized.png"
TARGET_PATH="${CURRENT_DIR}/Zapp-AppAssets.xcassets/App Icon & Top Shelf Image.brandassets/App Icon.imagestack/Layer5.imagestacklayer/Content.imageset"

apply_on_images(){
  PATTERN=$1
  find ${TARGET_PATH} -name "${PATTERN}" | while read line ;
  do
      WIDTH=$(identify -format %w $line)
      convert ${ORIG_RIBBON_IMAGE} -resize ${WIDTH}x${WIDTH} ${RESIZED_RIBBON_IMAGE}
      composite ${RESIZED_RIBBON_IMAGE} ${line} ${line}
      echo "App icon updated with debug ribbon: ${line}"
  done
}

# proceed with app icon images
apply_on_images "Icon-App*.png"
