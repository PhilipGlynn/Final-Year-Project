#!bin/bash

convert $1    -resize 100x55\!  ./Resize$1
convert ./Resize$1  txt: | \
while read line; do
	for splitLine in $line
	do
		if [[ $splitLine == *"#"* ]]
		then
			rgbHex=$splitLine
			echo -en "\\x${rgbHex:1:2}" > /dev/ttyUSB1
			echo -en "\\x${rgbHex:3:2}" >> /dev/ttyUSB1
			echo -en "\\x${rgbHex:5:2}" >> /dev/ttyUSB1
  		fi	  
	done
done
#rm ./Resize$1
