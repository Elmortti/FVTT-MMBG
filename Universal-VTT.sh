echo "$(find "c:/Work/Maps/" -type d -wholename */*/*Universal*VTT*)" | grep -oE '/[0-9]+[0-9a-zA-Z-]+-UniversalVTT' | sed -E 's/-UniversalVTT+$//g' | sed 's/\///g' | tee UniversalVTT.txt
start notepad UniversalVTT.txt