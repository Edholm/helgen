#!/usr/bin/env sh
# usage: generate-images.sh <template-file.jpg>
#
# Dependencies:
# * imagemagic

templateFile=$1
days="måndag tisdag onsdag torsdag fredag"

for day in ${days} ; do
  convert -font helvetica \
          -fill black \
          -pointsize 30 \
          -gravity NorthWest \
          -annotate +50+200 "\"Är det helg än?\" sa Puh\n\n\"Nej, det är bara ${day}.\" sa Nasse\n\n\"Kuken.\" sa Puh" \
          "${templateFile}" "${day}".png
done