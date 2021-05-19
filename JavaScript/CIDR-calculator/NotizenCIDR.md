# Sources

https://www.ionos.com/digitalguide/server/know-how/cidr-classless-inter-domain-routing/

https://cidr-rechner.de/


## original Tasks
https://halle.awo-rpk.de/pluginfile.php?file=%2F1803%2Fmod_assign%2Fintroattachment%2F0%2FCIDR-Netzklassen.pdf&amp;forcedownload=1


# Notes

- used to be 5 classes (A, B, C, D, E)
- IP-Address --> Subnetmask + 1st IP + Last IP + amount + available addresses
- class C: subnet mask would be /24 (24 bits determine network component of IP addres)
	- can compile e.g. /25  (binary value 11111111 11111111 11111111 10000000) = (dot-decimal notation) 255.255.255.128
- IPv4 = consists of 32 bits -->  *binary equivalent:* 201.105.7.34 corresponds to 11001001 01101001 00000111 00100010
	- therefore possible suffixes in CIDR range from 0 to 32

***

## subnets
- 201.105.7.34/24 is in the *same network* as 201.105.7.1/24
	- only first 24 bits of network component are counted
	- same network --> must be equal
	- ramaining bits reserved for host part
	
- host: 
	- network address: only 0s in host part
	- broadcast address: only 1s

- IP-Address with /30 (suffix) --> calculateable *Net ID*
	- to test if belong to same network
	
## examples

- accomodate 2000 hosts --> CIDR table : need a _/21 network_ 
	- ### *logarithm: x=log2(2000)* --> round up to 11 --> subnet with 2^11 hosts: 2048
		- remember to *substract* 2 addresses for broadcast and network
- 210.105.40.0/21 --> 2048 - 2 = 2046 IP addresses 
	- highest = broadcast: 210.105.47.255/21
	- ### 2048 (max number of adr. in subnet) / 256 (number of possibilities in one octet) = 8
		- -->  in the third octet the eight values from 40 to 47, and in the fourth octet, all values from 0 to 255, must be covered

# questions
- how to determine mask? --> has to be a given? know how many hosts need to be served?


# supernetting
//TODO later look into here
	
<br>
<br>

# CODING Solutions
## API to get public IP

## find subnet mask of public IP
- whois lookup

## frontend
- enter how many hosts must be served
- show highest (broadcast)
- show lowest (network)
- show available addresses

## [Calculations](http://subnetcalculator.info/CIDR-tutorial)
- *reminder: 11111111 is equal to 2^7+2^6+2^5+2^4+2^3+2^2+2^1+2^0, or 255.*
- *reminder: 
			168/2 = 84, remainder is 0
			84/2 = 42, remainder is 0
			42/2 = 21, remainder is 0
			21/2 = 10, remainder is 1
			10/2 = 5, remainder is 0
			5/2 = 2, remainder is 1
			2/2 = 1, remainder is 0
			1/2 = 0, remainder is 1 *
			
	| 168 - | 40- | 40- | 12- | 12- | 4- | 0 | 0 |
	|---|---|---|---|---|---|---|---|
	| 128 | 64 | 32 | 16 | 8 | 4 | 2 | 1 |
	| 1 | 0 (n.l)| 1 | 0 (n.l.) | 1 | 0 | 0 | 0 |
<br>
	
- ### IPv4 = 32 bits (4 octets)
	- --> get the mask e.g. /25
	- first 25 characters are *1*
		- 11111111 11111111 111111111 0000000
		- 11111111.11111111.11111111.10000000
		- 255 . 255 . 255 . 128 *(Subnetmask for prefix /25)*
- ### identify network- and host-bits (Subnetmask has 32 bit)
	- NetworkBits equal prefix (e.g. 25)
	- HostBits equal 32
	- SubnetMask = NetworkBits + HostBits
		- --> HostBits = 32 - 25
		- HostBits = 7
- ### find Maximum Hosts per Subnet
	- 2^HostBits
	- Hosts = 2^7 = 128 ( 128-2=126 valid hosts)
- ### find total subnets in given Network ( maximum number of subnets in network)
	- 2^NetworkBits
	- Subnets = 2^25 = 33554432
	- /25 network maximum 33554432 unique subnets possible
- ### NetworkAddress and BroadcastAddress
- NetworkAddress = IP-Address (binary) *BITWISE AND* Subnetmask/prefix (binary)
- BroadcastAddress = IP-Address *BITWISE OR* Wildcard Mask
	- Wildcard Mask = inverted Subnet Mask (00000000.00000000.00000000.01111111)


| IP Address: 112.3.2.3 /25 | |
|----|---|
| Network Bits  |	25 |
| Host Bits |	7 |
| Maximum Hosts per Subnet 	| 128 (126 Valid hosts) |
| Maximum Subnets in Network 	| 33554432 |
| Subnetmask 	| 255.255.255.128 |
| Wildcard Mask 	| 0.0.0.127 |
| Network Address 	| 112.3.2.0 |
| Broadcast Address 	| 112.3.2.127 |
		
<br>
<br>

# ZIEL:
Eingabe: 50 PCs
Eingabe: IP-Adresse
Ausgabe: der REST

		
<br>
<br>

## SubnetMask calculation
 ```
 a = 0b11001              // 11001     input
mask = (1 << 4)          // 10000     mask 5th bit with 1
ones = (1 << 5) - 1      // 11111     generate all ones
mask = mask ^ ones       // 01111     inverted mask
a = a & mask			// 01001     turn 5th bit off!
```

This works because the base 2 number with 1 at nth position represents the decimal number 2**(n-1), so 2**(n-1)-1 is the highest number that you can represent with n-1 bits (because we start at zero). That number corresponds to n-1 1's!
```
n         2^(n-1)   2^(n-1)     2^(n-1)-1
2         2         10          01
3         4         100         011
4         8         1000        0111
```

[Source](https://medium.com/@parkerjmed/practical-bit-manipulation-in-javascript-bfd9ef6d6c30)