#!/usr/bin/env bash

# Directory containing photos
DIR="/home/shin/Downloads/upscayl_png_upscayl-standard-4x_3x/upscayl_png_upscayl-standard-4x_3x/"

# Loop through all files in directory
for file in "$DIR"/*; do
	if [[ -f "$file" ]]; then
		echo "Processing: $file"
		magick.sh --downscale "$file" "$file" 50%
	fi
done
