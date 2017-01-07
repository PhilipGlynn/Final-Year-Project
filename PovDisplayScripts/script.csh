rm outputFile.hex
touch outputFile.hex

set lines= set lines=`cat $1`
set i=1
while ( $i <= $#lines )
    echo $lines[$i] | tr -d '[ \n]' | perl -ne 's/([0-9a-f]{2})/print chr hex $1/gie' > /dev/ttyUSB1
    echo $lines[$i] | tr -d '[ \n]' | perl -ne 's/([0-9a-f]{2})/print chr hex $1/gie' >> outputFile.hex		
    @ i = $i + 1
    
end
