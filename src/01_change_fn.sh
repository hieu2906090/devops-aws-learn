#!/bih/bash

# ------------------------------------------------------------- 
FOLDER_PATH=/Users/hieunguyen/Desktop

# find "$FOLDE_PATH" -maxdepth 1 -type f -name "*.txt"

find $desktop -maxdepth 1 -type f -name "*.txt" -exec sh -c 'x={}; mv "$x" $(echo $x | sed 's/\.txt/\-old.txt/g')' \;

# ------------------------------------------------------------- 
# REF CODE
# for i in $FOLDER_PATH/*
# do
# 	if [ -f "$i" ]; then	
# 		echo "$i is file"
# 		mv -- "$i" "${i}_bkup"
# 	else 
# 		echo "$i is not file"
# 	fi	
# done