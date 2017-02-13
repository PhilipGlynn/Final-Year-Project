#!bin/bash
rm ./output.hex
convert $1    -resize 100x55\!  ./Resize$1
convert ./Resize$1  txt: | \
while read line; do
	for splitLine in $line
	do
		if [[ $splitLine == *"#"* ]]
		then
			rgbHex=$splitLine
			if [ -n "${rgbHex:1:2}" ]; then
				 echo -en "\x${rgbHex:1:2}" >> ./output.hex
			fi	
			if [ -n "${rgbHex:3:2}" ]; then
				 echo -en "\x${rgbHex:3:2}" >> ./output.hex
			fi	
			if [ -n "${rgbHex:5:2}" ]; then
				 echo -en "\x${rgbHex:5:2}" >> ./output.hex
			fi
  		fi	  
	done
done
perl toSerial.pl
#rm ./output.hex
rm ./Resize$1
