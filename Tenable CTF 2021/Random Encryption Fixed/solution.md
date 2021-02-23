# Solution for Random Encryption Fixed

## Problem worth 100 points under Coding Section

## Statement:

We found the following file on a hacked terminal:
```
import random
flag = "flag{not_the_flag}"
seeds = []
for i in range(0,len(flag)):
    seeds.append(random.randint(0,10000))

res = []
for i in range(0, len(flag)):
    random.seed(seeds[i])
    rands = []
    for j in range(0,4):
        rands.append(random.randint(0,255))

    res.append(ord(flag[i]) ^ rands[i%4])
    del rands[i%4]
    print(str(rands))

print(res)
print(seeds)
```
We also found sample output from a previous run:
```
[249, 182, 79]
[136, 198, 95]
[159, 167, 6]
[223, 136, 101]
[66, 27, 77]
[213, 234, 239]
[25, 36, 53]
[89, 113, 149]
[65, 127, 119]
[50, 63, 147]
[204, 189, 228]
[228, 229, 4]
[64, 12, 191]
[65, 176, 96]
[185, 52, 207]
[37, 24, 110]
[62, 213, 244]
[141, 59, 81]
[166, 50, 189]
[228, 5, 16]
[59, 42, 251]
[180, 239, 144]
[13, 209, 132]
[184, 161, 235, 97, 140, 111, 84, 182, 162, 135, 76, 10, 69, 246, 195, 152, 133, 88, 229, 104, 111, 22, 39]
[9925, 8861, 5738, 1649, 2696, 6926, 1839, 7825, 6434, 9699, 227, 7379, 9024, 817, 4022, 7129, 1096, 4149, 6147, 2966, 1027, 4350, 4272] 
```

## Solution:

The code is fairly simple to understand. In the code, initially a ```flag``` variable is initialized with a placeholder flag (not the real flag) then the real encryption begins. The code uses the first for loop to iterate over the entire length of the flag, and on every iteration a seed value is generated which is a random value ranging anywhere between 0 to 10000. A list (```seeds```) contains all the randomly generated seed values. Then we come across the second for loop which also iterates for the entire length of the flag, inside it, ```random.seed()``` method is called with the seed parameter which is the seed from ```seeds``` list corresponding to the current iteration number. Now, the third nested for loop is triggered which runs exactly for 4 iterations and appends 4 random integers in the range of 0 to 255 to another list (```rands```). Once, the third for loop's operation is carried out, we move control back to the body of the second for loop where the a list ```res``` is initialized with ```(ord(flag[i]) ^ rands[i%4])``` where ```i``` is the current iteration number. After this, ```rands[i%4]``` is deleted and the rest of the contents of ```rands``` is printed as a string after which the second for loop finishes its operation. Finally the program prints out both the ```res``` and ```seeds``` list, where ```res``` basically contains the obfuscated flag while ```seeds``` contains the seed values used during execution.

Looking at the output we notice that, the particular value of ```rands``` which was used during the ```^``` xor operation to generate ```res``` had been removed from the it. But, luckily we had access to all the seed values in ```seeds``` as well as the values for ```res```. It is well known that once ```random.seed()``` method is called with a seed value, ```random.randint()``` method will always generate the same numbers from a given range and that is the thing we are going to abuse.

I fired up my text editor and wrote a quick script to recreate the values of ```rands``` which were used during the xor operation. After that all I had to do was xor the known values of ```res``` with the values regenerated for ```rands``` suing the same seed values, to get back the original flag.

Here is the script I used (I have also uploaded it in the repo itself):
```
import random

seeds = [9925, 8861, 5738, 1649, 2696, 6926, 1839, 7825, 6434, 9699, 227, 7379, 9024, 817, 4022, 7129, 1096, 4149, 6147, 2966, 1027, 4350, 4272]
res = [184, 161, 235, 97, 140, 111, 84, 182, 162, 135, 76, 10, 69, 246, 195, 152, 133, 88, 229, 104, 111, 22, 39]
key = []

for i in range(0, len(res)):
    random.seed(seeds[i])
    rands = []
    for j in range(0,4):
        rands.append(random.randint(0,255))
    key.append(rands[i%4])

decodedflag = []
for i in range(0, len(res)):
    decodedflag.append(key[i]^res[i])

for element in decodedflag:
    print(chr(element), end="")
```

On running the script we are presented with our original flag ```flag{Oppsie_LULZ_fixed}```.
