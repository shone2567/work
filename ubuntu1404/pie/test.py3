#!/usr/bin/python3
import random

print(list(range(0,50,2)))
lis = [ "A", 2, 3, 4,5,6,7,8,9,10,"J","Q","K"]
#for var in [1,2,3]:
for var in lis: 
	print(var)
#for var in list(range(5)):
	#print(var)
random.shuffle(lis)
print(lis)


