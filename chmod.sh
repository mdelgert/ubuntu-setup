#!/bin/bash

# This script will loop through all .sh files in the current directory and run 'chmod +x' on each of them.
for file in *.sh; do
    if [ -f "$file" ]; then
        chmod +x "$file"
        echo "Made $file executable."
    else
        echo "$file is not a regular file."
    fi
done
echo "All .sh files have been made executable."