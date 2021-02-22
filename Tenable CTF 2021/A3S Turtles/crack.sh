#!/bin/bash

for i in {128..1}
do 
	PASS=$(fcrackzip -u -D -p  /root/Desktop/word.txt turtles$i.zip | grep -o '[[:digit:]]*')
	echo -n $PASS >> message.txt  
	unzip -P $PASS turtles$i.zip > /dev/null 2>&1
	rm turtles$i.zip
done
 
