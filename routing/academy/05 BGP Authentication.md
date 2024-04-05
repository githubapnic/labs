<span style="display:block;text-align:center">![](images/apnic_logo.png)</span>
#<center><b>Deploying BGP (Cisco IOS) Lab</b></center>



>###<center>**Task 5: BGP Authentication**
</center>

>[!alert] Please make sure all previous tasks work as expected and you understand them before doing this task.


>[!knowledge]By default, BGP does not require authentication for routers to establish neighbor relationship, unauthorized routers could accidentally or maliciously participate in the BGP domain with some basic configuration. Therefore, it is recommended to enable BGP authentication in production network.

>[!hint] BGP supports MD5 authentication between neighbors, using a shared password. When authentication is configured, BGP authenticates every TCP segment from its peer and checks the source of each routing update. Peering succeeds only if both routers are configured for authentication and have the same password.

- There are 2 steps in this task:

* [Step 5.1: Configuring BGP authentication](#step-51-configuring-bgp-authentication)

* [Step 5.2: Verifying BGP authentication](#step-52-verifying-bgp-authentication)



### **Step 5.1: Configuring BGP authentication** ###

In this step, we will configure MD5 Authentication for all BGP sessions.


#### **BGP authentication** ####

>* MD5 Password (plain text):
	* iBGP sessions: **iBGP%IW0ntTe11U!!**
	* eBGP session between AS64512 and AS65000: **eBGP%A$64512-65000@pwd**
	* eBGP session between AS64512 and AS65001: **eBGP%A$64512-65001@pwd**
	* eBGP session between AS65000 and AS65001: **eBGP%A$65000-65001@pwd**

>[!alert] Technically, you can use other Password, as long as both ends of BGP peering match.


#### **Step 5.1.1: Configuring BGP authentication on R1** ####

- Select R1 from the Resources tab.

	```powershell-nocode
	Username: apnic
	Password: training
    ```

- The commands below must be run in the privileged exec mode. Type `enable` to enter this mode.

    ```powershell-nocode
	enable
	Password: labconfig
    ```

- Here is the link of IMAGE[Network Topology](images/topology_l3addr.png) with IP addresses for your reference.

- Here is the BGP authentication configuration on **R1**:

	```

	configure terminal
	
	!
	! Enter BGP configuration for AS64512
	router bgp 64512
	 !
	 ! Enable MD5 authentication for BGP peer group: IBGP-IPV4
	 neighbor IBGP-IPV4 password iBGP%IW0ntTe11U!!
	 !
	 ! Enable MD5 authentication for BGP peer group: IBGP-IPV6
	 neighbor IBGP-IPV6 password iBGP%IW0ntTe11U!!
	 !
	 ! Enable MD5 authentication for BGP neighbor: 172.20.0.1 (AS65000)
	 neighbor 172.20.0.1 password eBGP%A$64512-65000@pwd
	 !
	 ! Enable MD5 authentication for BGP neighbor: 2406:6400:4:: (AS65000)
	 neighbor 2406:6400:4:: password eBGP%A$64512-65000@pwd
	
	end
	```


#### **Step 5.1.2: Configuring BGP authentication on R2** ####

- Select R2 from the Resources tab.

	```powershell-nocode
	Username: apnic
	Password: training
    ```

- The commands below must be run in the privileged exec mode. Type `enable` to enter this mode.

    ```powershell-nocode
	enable
	Password: labconfig
    ```

- Here is the link of IMAGE[Network Topology](images/topology_l3addr.png) with IP addresses for your reference.

- Here is the BGP authentication configuration on **R2**:

	```
	configure terminal
	
	router bgp 64512
	 neighbor IBGP-IPV4 password iBGP%IW0ntTe11U!!
	 neighbor IBGP-IPV6 password iBGP%IW0ntTe11U!!
	
	end
	```


#### **Step 5.1.3: Configuring BGP authentication on R3** ####

- Select R3 from the Resources tab.

	```powershell-nocode
	Username: apnic
	Password: training
    ```

- The commands below must be run in the privileged exec mode. Type `enable` to enter this mode.

    ```powershell-nocode
	enable
	Password: labconfig
    ```

- Here is the link of IMAGE[Network Topology](images/topology_l3addr.png) with IP addresses for your reference.

- Here is the BGP authentication configuration on **R3**:

	```
	configure terminal
	
	router bgp 64512
	 neighbor IBGP-IPV4 password iBGP%IW0ntTe11U!!
	 neighbor IBGP-IPV6 password iBGP%IW0ntTe11U!!
	
	end
	```


#### **Step 5.1.4: Configuring BGP authentication on R4** ####

- Select R4 from the Resources tab.

	```powershell-nocode
	Username: apnic
	Password: training
    ```

- The commands below must be run in the privileged exec mode. Type `enable` to enter this mode.

    ```powershell-nocode
	enable
	Password: labconfig
    ```

- Here is the link of IMAGE[Network Topology](images/topology_l3addr.png) with IP addresses for your reference.

- Here is the BGP authentication configuration on **R4**:

	```
	configure terminal
	
	router bgp 64512
	 neighbor IBGP-IPV4 password iBGP%IW0ntTe11U!!
	 neighbor IBGP-IPV6 password iBGP%IW0ntTe11U!!
	
	end
	```


#### **Step 5.1.5: Configuring BGP authentication on R5** ####

- Select R5 from the Resources tab.

	```powershell-nocode
	Username: apnic
	Password: training
    ```

- The commands below must be run in the privileged exec mode. Type `enable` to enter this mode.

    ```powershell-nocode
	enable
	Password: labconfig
    ```

- Here is the link of IMAGE[Network Topology](images/topology_l3addr.png) with IP addresses for your reference.

- Here is the BGP authentication configuration on **R5**:

	```
	configure terminal
	
	router bgp 64512
	 neighbor IBGP-IPV4 password iBGP%IW0ntTe11U!!
	 neighbor IBGP-IPV6 password iBGP%IW0ntTe11U!!
	 neighbor 172.28.0.1 password eBGP%A$64512-65001@pwd
	 neighbor 2406:6401:4:: password eBGP%A$64512-65001@pwd
	
	end
	```


#### **Step 5.1.6: Configuring BGP authentication on R6** ####

- Select R6 from the Resources tab.

	```powershell-nocode
	Username: apnic
	Password: training
    ```

- The commands below must be run in the privileged exec mode. Type `enable` to enter this mode.

    ```powershell-nocode
	enable
	Password: labconfig
    ```

- Here is the link of IMAGE[Network Topology](images/topology_l3addr.png) with IP addresses for your reference.

- Here is the BGP authentication configuration on **R6**:

	```
	configure terminal
	
	router bgp 64512
	 neighbor IBGP-IPV4 password iBGP%IW0ntTe11U!!
	 neighbor IBGP-IPV6 password iBGP%IW0ntTe11U!!
	
	end
	```


#### **Step 5.1.7: Configuring BGP authentication on ISP1** ####

- Select ISP1 from the Resources tab.

	```powershell-nocode
	Username: apnic
	Password: training
    ```

- The commands below must be run in the privileged exec mode. Type `enable` to enter this mode.

    ```powershell-nocode
	enable
	Password: labconfig
    ```

- Here is the link of IMAGE[Network Topology](images/topology_l3addr.png) with IP addresses for your reference.

- Here is the BGP authentication configuration on **ISP1**:

	```
	configure terminal
	
	router bgp 65000
	 neighbor 172.20.0.2 password eBGP%A$64512-65000@pwd
	 neighbor 2406:6400:4::1 password eBGP%A$64512-65000@pwd
	 neighbor 172.20.0.6 password eBGP%A$65000-65001@pwd
	 neighbor 2406:6400:4:1::1 password eBGP%A$65000-65001@pwd
	
	end
	```


#### **Step 5.1.8: Configuring BGP authentication on ISP2** ####

- Select ISP2 from the Resources tab.

	```powershell-nocode
	Username: apnic
	Password: training
    ```

- The commands below must be run in the privileged exec mode. Type `enable` to enter this mode.

    ```powershell-nocode
	enable
	Password: labconfig
    ```

- Here is the link of IMAGE[Network Topology](images/topology_l3addr.png) with IP addresses for your reference.

- Here is the BGP authentication configuration on **ISP2**:

	```
	configure terminal
	
	router bgp 65001
	 neighbor 172.28.0.2 password eBGP%A$64512-65001@pwd
	 neighbor 2406:6401:4::1 password eBGP%A$64512-65001@pwd
	 neighbor 172.20.0.5 password eBGP%A$65000-65001@pwd
	 neighbor 2406:6400:4:1:: password eBGP%A$65000-65001@pwd
	
	end
	```



### **Step 5.2: Verifying BGP authentication** ###

>[!alert] Please perform this verification step only when you have fully completed previous configuration steps of this task.

To check whether BGP can authenticate neighbors successfully, we will reset all BGP sessions on every router, then we expect to see all the BGP neighbors are up back again and received the prefixes as they did in previous task (Task 4: eBGP Configuration).

Use `clear ip bgp *` command for resetting all BGP sessions on each router.

If all BGP neighbors are up back shortly, and the prefixes are received as expected, then it means the BGP authentication is successful.

Following messages will be logged or pop-up on the console, if there is authentication issue (R1-ISP1's BGP session as an example):

	*May 12 2020 13:35:15.181 UTC: %TCP-6-BADAUTH: Invalid MD5 digest from 172.20.0.1(43652) to 172.20.0.2(179) tableid - 0
	*May 12 2020 13:35:15.181 UTC: %TCP-6-BADAUTH: Invalid MD5 digest from 2406:6400:4::(37854) to 2406:6400:4::1(179) tableid - 0 
	
We will do verification with following commands:

* Showing BGP neighbors:
	* IPv4 Unicast: `show bgp ipv4 unicast summary` or `show ip bgp summary`
	* IPv6 Unicast: `show bgp ipv6 unicast summary`
* Showing BGP table:
	* IPv4 Unicast: `show bgp ipv4 unicast` or `show ip bgp`
	* IPv6 Unicast: `show bgp ipv6 unicast`
* Showing BGP routes in routing table:
	* IPv4 Unicast: `show ip route bgp`
	* IPv6 Unicast: `show ipv6 route bgp`


#### **Verification on R1 as example** ####

- Select R1 from the Resources tab.

	```powershell-nocode
	Username: apnic
	Password: training
    ```

- The commands below must be run in the privileged exec mode. Type `enable` to enter this mode.

    ```powershell-nocode
	enable
	Password: labconfig
    ```

- Here is the link of IMAGE[Network Topology](images/topology_l3addr.png) with IP addresses for your reference.

1. Verify BGP neighbors

	- To check IPv4 Unicast BGP neighbors, type `show bgp ipv4 unicast summary`, the result is as shown below:
	
    	```powershell-nocode
		R1#show bgp ipv4 unicast summary
		For address family: IPv4 Unicast
		BGP router identifier 10.0.0.1, local AS number 64512
		BGP table version is 11, main routing table version 11
		10 network entries using 2480 bytes of memory
		12 path entries using 1536 bytes of memory
		8/7 BGP path/bestpath attribute entries using 2112 bytes of memory
		2 BGP AS-PATH entries using 48 bytes of memory
		0 BGP route-map cache entries using 0 bytes of memory
		0 BGP filter-list cache entries using 0 bytes of memory
		BGP using 6176 total bytes of memory
		BGP activity 20/0 prefixes, 24/0 paths, scan interval 60 secs
		
		Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
		10.0.0.2        4        64512       6       8       11    0    0 00:02:30        1
		10.0.0.3        4        64512       5       8       11    0    0 00:02:22        0
		10.0.0.4        4        64512       5       8       11    0    0 00:02:24        0
		10.0.0.5        4        64512       8       8       11    0    0 00:02:14        5
		10.0.0.6        4        64512       6       8       11    0    0 00:02:18        1
		172.20.0.1      4        65000       7       8       11    0    0 00:02:30        3
		```
	
	- To check IPv6 Unicast BGP neighbors, type `show bgp ipv6 unicast summary`, the result is as shown below:

    	```powershell-nocode
		R1#show bgp ipv6 unicast summary
		BGP router identifier 10.0.0.1, local AS number 64512
		BGP table version is 11, main routing table version 11
		10 network entries using 2720 bytes of memory
		12 path entries using 1824 bytes of memory
		8/7 BGP path/bestpath attribute entries using 2112 bytes of memory
		2 BGP AS-PATH entries using 48 bytes of memory
		0 BGP route-map cache entries using 0 bytes of memory
		0 BGP filter-list cache entries using 0 bytes of memory
		BGP using 6704 total bytes of memory
		BGP activity 20/0 prefixes, 24/0 paths, scan interval 60 secs
		
		Neighbor        V           AS MsgRcvd MsgSent   TblVer  InQ OutQ Up/Down  State/PfxRcd
		2001:DB8::2     4        64512       6       8       11    0    0 00:02:34        1
		2001:DB8::3     4        64512       5       8       11    0    0 00:02:23        0
		2001:DB8::4     4        64512       5       8       11    0    0 00:02:20        0
		2001:DB8::5     4        64512       8       8       11    0    0 00:02:04        5
		2001:DB8::6     4        64512       6       8       11    0    0 00:02:18        1
		2406:6400:4::   4        65000       7       9       11    0    0 00:02:32        3
		```
	
	All BGP neighbors have recovered after reset, and they have received the same number of prefixes as they did in previous task (Task 4: eBGP Configuration).

2. Verify BGP table

	- To check IPv4 Unicast BGP table, type `show bgp ipv4 unicast`, the result is shown as below:

    	```powershell-nocode
		R1#show bgp ipv4 unicast
		BGP table version is 11, local router ID is 10.0.0.1
		Status codes: s suppressed, d damped, h history, * valid, > best, i - internal,
		              r RIB-failure, S Stale, m multipath, b backup-path, f RT-Filter,
		              x best-external, a additional-path, c RIB-compressed,
		              t secondary path,
		Origin codes: i - IGP, e - EGP, ? - incomplete
		RPKI validation codes: V valid, I invalid, N Not found
		
		     Network          Next Hop            Metric LocPrf Weight Path
		 * i  0.0.0.0          10.0.0.5                 0    100      0 65001 i	<-- Default route
		 *>                    172.20.0.1                             0 65000 i
		 * i  10.0.0.0         10.0.0.5                 0    100      0 i		<-- AS64512 aggregation
		 *>                    0.0.0.0                  0         32768 i
		 *>   10.2.1.0/24      0.0.0.0                  0         32768 i
		 *>i  10.2.2.0/24      10.0.0.2                 0    100      0 i
		 *>i  10.2.5.0/24      10.0.0.5                 0    100      0 i
		 *>i  10.2.6.0/24      10.0.0.6                 0    100      0 i
		 *>   172.16.0.0/13    172.20.0.1               0             0 65000 i	<-- AS65000 aggregation
		 *>   172.18.1.0/24    172.20.0.1               0             0 65000 i <-- Server S1
		 *>i  172.24.0.0/13    10.0.0.5                 0    100      0 65001 i	<-- AS65001 aggregation
		 *>i  172.26.1.0/24    10.0.0.5                 0    100      0 65001 i	<-- Server S2
		```
	
	- To check IPv6 Unicast BGP table, type `show bgp ipv6 unicast`, the result is shown as below:

    	```powershell-nocode
		R1#show bgp ipv6 unicast
		BGP table version is 12, local router ID is 10.0.0.1
		Status codes: s suppressed, d damped, h history, * valid, > best, i - internal,
		              r RIB-failure, S Stale, m multipath, b backup-path, f RT-Filter,
		              x best-external, a additional-path, c RIB-compressed,
		              t secondary path,
		Origin codes: i - IGP, e - EGP, ? - incomplete
		RPKI validation codes: V valid, I invalid, N Not found
		
		     Network          Next Hop            Metric LocPrf Weight Path
		 *>   ::/0             2406:6400:4::                          0 65000 i	<-- Default route
		 * i                   2001:DB8::5              0    100      0 65001 i
		 * i  2001:DB8::/32    2001:DB8::5              0    100      0 i		<-- AS64512 aggregation
		 *>                    ::                       0         32768 i
		 *>   2001:DB8:2:1::/64
		                       ::                       0         32768 i
		 *>i  2001:DB8:2:2::/64
		                       2001:DB8::2              0    100      0 i
		 *>i  2001:DB8:2:5::/64
		                       2001:DB8::5              0    100      0 i
		 *>i  2001:DB8:2:6::/64
		                       2001:DB8::6              0    100      0 i
		 *>   2406:6400::/32   2406:6400:4::            0             0 65000 i	<-- AS65000 aggregation
		 *>   2406:6400:2:1::/64												<-- Server S1
		                       2406:6400:4::            0             0 65000 i
		 *>i  2406:6401::/32   2001:DB8::5              0    100      0 65001 i	<-- AS65001 aggregation
		 *>i  2406:6401:2:1::/64												<-- Server S2
		                       2001:DB8::5              0    100      0 65001 i
		```
	
	All BGP prefixes appear in the BGP table as they did in previous task (Task 4: eBGP Configuration).

3. Verify routing table

	- To check IPv4 Unicast BGP routes, type `show ip route bgp`, the result is as shown below:

    	```powershell-nocode
		R1#show ip route bgp
		Codes: L - local, C - connected, S - static, R - RIP, M - mobile, B - BGP
		       D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area
		       N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
		       E1 - OSPF external type 1, E2 - OSPF external type 2
		       i - IS-IS, su - IS-IS summary, L1 - IS-IS level-1, L2 - IS-IS level-2
		       ia - IS-IS inter area, * - candidate default, U - per-user static route
		       o - ODR, P - periodic downloaded static route, H - NHRP, l - LISP
		       a - application route
		       + - replicated route, % - next hop override, p - overrides from PfR
		
		Gateway of last resort is 172.20.0.1 to network 0.0.0.0
		
		B*    0.0.0.0/0 [20/0] via 172.20.0.1, 00:02:10							<-- Default route
		      10.0.0.0/8 is variably subnetted, 26 subnets, 4 masks
		B        10.2.2.0/24 [200/0] via 10.0.0.2, 00:02:10
		B        10.2.5.0/24 [200/0] via 10.0.0.5, 00:02:10
		B        10.2.6.0/24 [200/0] via 10.0.0.6, 00:02:06
		B     172.16.0.0/13 [20/0] via 172.20.0.1, 00:02:10						<-- AS65000 aggregation
		      172.18.0.0/24 is subnetted, 1 subnets
		B        172.18.1.0 [20/0] via 172.20.0.1, 00:02:10						<-- Server S1
		B     172.24.0.0/13 [200/0] via 10.0.0.5, 00:02:10						<-- AS65001 aggregation
		      172.26.0.0/24 is subnetted, 1 subnets
		B        172.26.1.0 [200/0] via 10.0.0.5, 00:02:10						<-- Server S2
		```
	
	- To check IPv6 Unicast BGP routes, type `show ipv6 route bgp`, the result is as shown below:

    	```powershell-nocode
		R1#show ipv6 route bgp
		IPv6 Routing Table - default - 34 entries
		Codes: C - Connected, L - Local, S - Static, U - Per-user Static route
				B - BGP, R - RIP, H - NHRP, I1 - ISIS L1
				I2 - ISIS L2, IA - ISIS interarea, IS - ISIS summary, D - EIGRP
				EX - EIGRP external, ND - ND Default, NDp - ND Prefix, DCE - Destination
				NDr - Redirect, RL - RPL, O - OSPF Intra, OI - OSPF Inter
				OE1 - OSPF ext 1, OE2 - OSPF ext 2, ON1 - OSPF NSSA ext 1
				ON2 - OSPF NSSA ext 2, la - LISP alt, lr - LISP site-registrations
				ld - LISP dyn-eid, lA - LISP away, a - Application
		B   ::/0 [20/0]															<-- Default route
				via FE80::253:1FF:FE11:106, GigabitEthernet6
		B   2001:DB8:2:2::/64 [200/0]
				via 2001:DB8::2
		B   2001:DB8:2:5::/64 [200/0]
				via 2001:DB8::5
		B   2001:DB8:2:6::/64 [200/0]
				via 2001:DB8::6
		B   2406:6400::/32 [20/0]												<-- AS65000 aggregation
				via FE80::253:1FF:FE11:106, GigabitEthernet6
		B   2406:6400:2:1::/64 [20/0]											<-- Server S1
				via FE80::253:1FF:FE11:106, GigabitEthernet6
		B   2406:6401::/32 [200/0]												<-- AS65001 aggregation
				via 2001:DB8::5
		B   2406:6401:2:1::/64 [200/0]											<-- Server S2
				via 2001:DB8::5
		```
	
	All BGP routes appear in the routing table as they did in previous task (Task 4: eBGP Configuration).