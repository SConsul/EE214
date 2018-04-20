#Tracefile for ALU - ADDER

def DecToBin(n):
    if n==0: 
	return ''
    else:
        return DecToBin(n/2) + str(n%2)

import numpy as np

#np.binary_repr(4, width=None)


with open('tracefile.txt', 'w') as tr:
	mask = "1111"
	s=np.array([0,0,0,0,0,0,0,0])
	for input_1 in range(256):
		ans=0
		binIP = str(np.binary_repr(input_1, width=8))
		for i in range(8):
			ans=ans +int(binIP[i])
		#print(binIP + ' ' + str(ans))
		binOP = str(np.binary_repr(ans, width=4))
		tr.write(binIP + ' ' + binOP + ' ' + mask + '\n' )














