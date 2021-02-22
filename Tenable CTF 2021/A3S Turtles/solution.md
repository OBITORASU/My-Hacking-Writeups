# Solution for A3S Turtles

## Problem worth 250 points under Steganography
## Statement:
Turtles all the way down.
(We are provided a download link for a cryptic file by the name of turtles128.zip)

## Solution:
My initial thought was as simple as extracting the zip file and inspecting its contents but I met with a roadblock right at the start, the file was password protected. Well since we were never really provided any hints in the original problem statement I had to resort to brute force to guess the password. In this case, I used a neat tool called fcrackzip, its easily available on kali linux and install with a simple ```sudo apt-get install fcrackzip``` command. Then I started my brute force attack on the zip file and found the password to be a simple 0, the extracted file was yet another ```.zip``` file but this time instead of ```turtles128.zip``` it was ```turtles127.zip```. It became obvious that the real file had been zipped 128 times, I started playing around with the zip files and noticed that the password for the files always ranged between 1s or 0s. This caught my attention very quickly and I had a clear picture of what was going on.The password for the zip files when arranged together makes up a 128 bit long binary message. It was way too much effort manually playing around with the file which had been zipped so many times so I scripted out my work with a simple bash script. 

**Note: I had made a custom wordlist (word.txt here) with only 1 and 0 to make the script run faster.**

Here is the script for reference (I have uploaded the script separately on the repo as well):
```
#!/bin/bash

for i in {128..1}
do 
	PASS=$(fcrackzip -u -D -p  /root/Desktop/word.txt turtles$i.zip | grep -o '[[:digit:]]*')
	echo -n $PASS >> message.txt  
	unzip -P $PASS turtles$i.zip > /dev/null 2>&1
	rm turtles$i.zip
done
```
Upon running the script I had 2 files with me ```message.txt``` and ```key.png``` which had a hexadecimal key in it. I knew exactly what I was dealing with at this point, the binary message we extracted was the encrypted message (our flag in this case) and the key.png was the key to decipher the message. The encryption used was very easy to guess from the name of the challenge, A3S is very close to AES just in l33t :P

I went to [cyberchef](https://gchq.github.io/CyberChef/) I selected the AES decrypt recipe and got to work decoding. I entered the key and the binary message in hex format and started tinkering with the different AES encryption modes. I got the flag ```flag{steg0_a3s}``` on ```ECB``` mode and that concluded the challenge for me. 
