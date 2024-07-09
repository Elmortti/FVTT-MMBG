#!/bin/bash

# Define the list stored in $cmds
cmds=(-KEYW -HELP value3)

# Value to test
set -x

# Flag to indicate if value is found

target_dir=$(find "c:/Work/Maps/" -type d -name *379* -type d -name *379* -type d -name "*webp*")
echo "$target_dir"
read -p "press enter" 