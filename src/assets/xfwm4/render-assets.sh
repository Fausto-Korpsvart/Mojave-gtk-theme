#! /usr/bin/env bash

INKSCAPE="/usr/bin/inkscape"
OPTIPNG="/usr/bin/optipng"

SRC_FILE="assets-Light.svg"
DARK_SRC_FILE="assets-Dark.svg"
ASSETS_DIR="assets-Light"
DARK_ASSETS_DIR="assets-Dark"

INDEX="assets.txt"

# check command avalibility
has_command() {
  "$1" -v $1 > /dev/null 2>&1
}

rm -rf "$ASSETS_DIR" "$DARK_ASSETS_DIR"
mkdir -p $ASSETS_DIR && mkdir -p $DARK_ASSETS_DIR

for i in `cat $INDEX`
do
    if [ $(jobs -p | wc -l) -ge ${BUILD_THREADS} ]; then wait; fi
    echo Rendering $ASSETS_DIR/$i.png

      $INKSCAPE --export-id=$i \
                --export-id-only \
                --export-filename=$ASSETS_DIR/$i.png $SRC_FILE >/dev/null 2>&1 &&
    $OPTIPNG -o7 --quiet $ASSETS_DIR/$i.png &

    if [ $(jobs -p | wc -l) -ge ${BUILD_THREADS} ]; then wait; fi
    echo Rendering $DARK_ASSETS_DIR/$i.png

      $INKSCAPE --export-id=$i \
                --export-id-only \
                --export-filename=$DARK_ASSETS_DIR/$i.png $DARK_SRC_FILE >/dev/null 2>&1 &&
    $OPTIPNG -o7 --quiet $DARK_ASSETS_DIR/$i.png &
done

wait
exit 0
