#!/bin/sh
SCALE="scale=960:960"
OPTIONS="-y -sws_flags lanczos -preset medium -c:v libx264 -crf 20 -profile:v main -level 3.1 -an"
INPUT="omni_highlights.mp4"
PREFIX="output"
echo "ffmpeg -i $INPUT -vf 'crop=960:960:0:0,$SCALE' $OPTIONS '${PREFIX}_1.mp4'..."
ffmpeg -i $INPUT \
-vf "crop=960:960:0:0,$SCALE" $OPTIONS "${PREFIX}_1.mp4" \
-vf "crop=960:960:960:0,$SCALE" $OPTIONS "${PREFIX}_2.mp4" \
-vf "crop=960:960:1920:0,$SCALE" $OPTIONS "${PREFIX}_3.mp4" \
-vf "crop=960:960:0:960,$SCALE" $OPTIONS "${PREFIX}_4.mp4" \
-vf "crop=960:960:960:960,$SCALE" $OPTIONS "${PREFIX}_5.mp4" \
-vf "crop=960:960:1920:960,$SCALE" $OPTIONS "${PREFIX}_6.mp4"