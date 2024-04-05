<span style="display:block;text-align:center">![](images/apnic_logo.png)</span>
#<center><b>Deploying BGP (Cisco IOS) Lab</b></center>



>###<center>**Task 1: Link Address Configuration**
</center>

- There are 5 steps in this task:

* [Step 1.1: Configuring routers' IPv4 / IPv6 addresses](#step-11-configuring-routers-ipv4--ipv6-addresses)

* [Step 1.2: Pre-configured IPv4 / IPv6 addresses for customer and server hosts](#step-12-pre-configured-ipv4--ipv6-addresses-for-customer-and-server-hosts)

* [Step 1.3: Verifying point-to-point connectivity between routers](#step-13-verifying-point-to-point-connectivity-between-routers)

* [Step 1.4: Verifying connectivity to customers](#step-14-verifying-connectivity-to-customers)

* [Step 1.5: Verifying connectivity to servers](#step-15-verifying-connectivity-to-servers)


##**Step 1.1: Configuring routers' IPv4 / IPv6 addresses**

In this step, we will complete basic address configuration for routers' Loopback interfaces and point-to-point links.

>[!note] By default, IPv6 is disabled in Cisco IOS. Therefore, we have to enable it with `ipv6 unicast-routing` command.

>[!note] Since IPv6 SLAAC (Stateless Address Auto-Configuration) is not being used anywhere in this lab, Router Advertisement is not required on all links, we can disable it by having `ipv6 nd ra suppress all` configured under each interface's configuration of the routers. 


#### **Step 1.1.1: Configure R1's IPv4 / IPv6 addresses** ####

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

- Here is the IPv4 and IPv6 address configuration of **R1**:

	```
	!
	! Enter configuration mode
	configure terminal
	
	!
	! Enable IPv6 Unicast routing
	ipv6 unicast-routing
	
	!
	! Create Loopback interface
	interface Loopback0
	 !
	 ! Set description
	 description *** Loopback for Router ID ***
	 !
	 ! Assign IPv4 address
	 ip address 10.0.0.1 255.255.255.255
	 !
	 ! Assign IPv6 address
	 ipv6 address 2001:DB8::1/128
	
	interface GigabitEthernet1
	 no shutdown
	 description *** To R2 GigabitEthernet1 ***
	 ip address 10.1.0.1 255.255.255.252
	 ipv6 address 2001:DB8:1::/127
	 !
	 ! Disable IPv6 Router Advertisement
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet2
	 no shutdown
	 description *** To R3 GigabitEthernet1 ***
	 ip address 10.1.0.5 255.255.255.252
	 ipv6 address 2001:DB8:1:1::/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet3
	 no shutdown
	 description *** To R4 GigabitEthernet1 ***
	 ip address 10.1.0.9 255.255.255.252
	 ipv6 address 2001:DB8:1:2::/127
	 ipv6 nd ra suppress all

	interface GigabitEthernet6
	 no shutdown
	 description *** To ISP1 GigabitEthernet6 ***
	 ip address 172.20.0.2 255.255.255.252
	 ipv6 address 2406:6400:4::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet7
	 no shutdown
	 description *** To customer H1 ***
	 ip address 10.2.1.1 255.255.255.0
	 ipv6 address 2001:DB8:2:1::1/64
	 ipv6 nd ra suppress all

	!
	! Exit configuration mode
	end
	```


#### **Step 1.1.2: Configure R2's IPv4 / IPv6 addresses** ####

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

- Here is the IPv4 and IPv6 address configuration of **R2**:

	```
	configure terminal
	
	ipv6 unicast-routing
	
	interface Loopback0
	 description *** Loopback for Router ID ***
	 ip address 10.0.0.2 255.255.255.255
	 ipv6 address 2001:DB8::2/128
	
	interface GigabitEthernet1
	 no shutdown
	 description *** To R1 GigabitEthernet1 ***
	 ip address 10.1.0.2 255.255.255.252
	 ipv6 address 2001:DB8:1::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet2
	 no shutdown
	 description *** To R3 GigabitEthernet2 ***
	 ip address 10.1.0.13 255.255.255.252
	 ipv6 address 2001:DB8:1:3::/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet3
	 no shutdown
	 description *** To R4 GigabitEthernet2 ***
	 ip address 10.1.0.17 255.255.255.252
	 ipv6 address 2001:DB8:1:4::/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet7
	 no shutdown
	 description *** To customer H2 ***
	 ip address 10.2.2.1 255.255.255.0
	 ipv6 address 2001:DB8:2:2::1/64
	 ipv6 nd ra suppress all
	 
	end
	```


#### **Step 1.1.3: Configure R3's IPv4 / IPv6 addresses** ####

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

- Here is the IPv4 and IPv6 address configuration of **R3**:

	```
	configure terminal
	
	ipv6 unicast-routing
	
	interface Loopback0
	 description *** Loopback for Router ID ***
	 ip address 10.0.0.3 255.255.255.255
	 ipv6 address 2001:DB8::3/128
	
	interface GigabitEthernet1
	 no shutdown
	 description *** To R1 GigabitEthernet2 ***
	 ip address 10.1.0.6 255.255.255.252
	 ipv6 address 2001:DB8:1:1::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet2
	 no shutdown
	 description *** To R2 GigabitEthernet2 ***
	 ip address 10.1.0.14 255.255.255.252
	 ipv6 address 2001:DB8:1:3::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet3
	 no shutdown
	 description *** To R4 GigabitEthernet3 ***
	 ip address 10.1.0.21 255.255.255.252
	 ipv6 address 2001:DB8:1:5::/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet4
	 no shutdown
	 description *** To R5 GigabitEthernet1 ***
	 ip address 10.1.0.25 255.255.255.252
	 ipv6 address 2001:DB8:1:6::/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet5
	 no shutdown
	 description *** To R6 GigabitEthernet1 ***
	 ip address 10.1.0.29 255.255.255.252
	 ipv6 address 2001:DB8:1:7::/127
	 ipv6 nd ra suppress all
	
	end
	```


#### **Step 1.1.4: Configure R4's IPv4 / IPv6 addresses** ####

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

- Here is the IPv4 and IPv6 address configuration of **R4**:

	```
	configure terminal
	
	ipv6 unicast-routing
	
	interface Loopback0
	 description *** Loopback for Router ID ***
	 ip address 10.0.0.4 255.255.255.255
	 ipv6 address 2001:DB8::4/128
	
	interface GigabitEthernet1
	 no shutdown
	 description *** To R1 GigabitEthernet3 ***
	 ip address 10.1.0.10 255.255.255.252
	 ipv6 address 2001:DB8:1:2::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet2
	 no shutdown
	 description *** To R2 GigabitEthernet3 ***
	 ip address 10.1.0.18 255.255.255.252
	 ipv6 address 2001:DB8:1:4::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet3
	 no shutdown
	 description *** To R3 GigabitEthernet3 ***
	 ip address 10.1.0.22 255.255.255.252
	 ipv6 address 2001:DB8:1:5::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet4
	 no shutdown
	 description *** To R5 GigabitEthernet2 ***
	 ip address 10.1.0.33 255.255.255.252
	 ipv6 address 2001:DB8:1:8::/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet5
	 no shutdown
	 description *** To R6 GigabitEthernet2 ***
	 ip address 10.1.0.37 255.255.255.252
	 ipv6 address 2001:DB8:1:9::/127
	 ipv6 nd ra suppress all
	
	end

	```


#### **Step 1.1.5: Configure R5's IPv4 / IPv6 addresses** ####

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

- Here is the IPv4 and IPv6 address configuration of **R5**:

	```
	configure terminal
	
	ipv6 unicast-routing
	
	interface Loopback0
	 description *** Loopback for Router ID ***
	 ip address 10.0.0.5 255.255.255.255
	 ipv6 address 2001:DB8::5/128
	
	interface GigabitEthernet1
	 no shutdown
	 description *** To R3 GigabitEthernet4 ***
	 ip address 10.1.0.26 255.255.255.252
	 ipv6 address 2001:DB8:1:6::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet2
	 no shutdown
	 description *** To R4 GigabitEthernet4 ***
	 ip address 10.1.0.34 255.255.255.252
	 ipv6 address 2001:DB8:1:8::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet3
	 no shutdown
	 description *** To R6 GigabitEthernet3 ***
	 ip address 10.1.0.41 255.255.255.252
	 ipv6 address 2001:DB8:1:A::/127
	 ipv6 nd ra suppress all

	interface GigabitEthernet6
	 no shutdown
	 description *** To ISP2 GigabitEthernet6 ***
	 ip address 172.28.0.2 255.255.255.252
	 ipv6 address 2406:6401:4::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet7
	 no shutdown
	 description *** To customer H5 ***
	 ip address 10.2.5.1 255.255.255.0
	 ipv6 address 2001:DB8:2:5::1/64
	 ipv6 nd ra suppress all
	
	end
	```


#### **Step 1.1.6: Configure R6's IPv4 / IPv6 addresses** ####

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

- Here is the IPv4 and IPv6 address configuration of **R6**:

	```
	configure terminal
	
	ipv6 unicast-routing
	
	interface Loopback0
	 description *** Loopback for Router ID ***
	 ip address 10.0.0.6 255.255.255.255
	 ipv6 address 2001:DB8::6/128
	
	interface GigabitEthernet1
	 no shutdown
	 description *** To R3 GigabitEthernet5 ***
	 ip address 10.1.0.30 255.255.255.252
	 ipv6 address 2001:DB8:1:7::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet2
	 no shutdown
	 description *** To R4 GigabitEthernet5 ***
	 ip address 10.1.0.38 255.255.255.252
	 ipv6 address 2001:DB8:1:9::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet3
	 no shutdown
	 description *** To R5 GigabitEthernet3 ***
	 ip address 10.1.0.42 255.255.255.252
	 ipv6 address 2001:DB8:1:A::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet7
	 no shutdown
	 description *** To customer H6 ***
	 ip address 10.2.6.1 255.255.255.0
	 ipv6 address 2001:DB8:2:6::1/64
	 ipv6 nd ra suppress all
	
	end
	```


#### **Step 1.1.7: Configure ISP1's IPv4 / IPv6 addresses** ####

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

- Here is the IPv4 and IPv6 address configuration of **ISP1**:

	```
	configure terminal
	
	ipv6 unicast-routing
	
	interface Loopback0
	 description *** Loopback for Router ID ***
	 ip address 172.16.0.1 255.255.255.255
	 ipv6 address 2406:6400::1/128
	
	interface GigabitEthernet1
	 no shutdown
	 description *** To ISP2 GigabitEthernet1 ***
	 ip address 172.20.0.5 255.255.255.252
	 ipv6 address 2406:6400:4:1::/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet6
	 no shutdown
	 description *** To R1 GigabitEthernet6 ***
	 ip address 172.20.0.1 255.255.255.252
	 ipv6 address 2406:6400:4::/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet7
	 no shutdown
	 description *** To server S1 ***
	 ip address 172.18.1.1 255.255.255.0
	 ipv6 address 2406:6400:2:1::1/64
	 ipv6 nd ra suppress all
	
	end
	```


#### **Step 1.1.8: Configure ISP2's IPv4 / IPv6 addresses** ####

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

- Here is the IPv4 and IPv6 address configuration of **ISP2**:


	```
	configure terminal
	
	ipv6 unicast-routing
	
	interface Loopback0
	 description *** Loopback for Router ID ***
	 ip address 172.24.0.1 255.255.255.255
	 ipv6 address 2406:6401::1/128
	
	interface GigabitEthernet1
	 no shutdown
	 description *** To ISP1 GigabitEthernet1 ***
	 ip address 172.20.0.6 255.255.255.252
	 ipv6 address 2406:6400:4:1::1/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet6
	 no shutdown
	 description *** To R5 GigabitEthernet6 ***
	 ip address 172.28.0.1 255.255.255.252
	 ipv6 address 2406:6401:4::/127
	 ipv6 nd ra suppress all
	
	interface GigabitEthernet7
	 no shutdown
	 description *** To server S2 ***
	 ip address 172.26.1.1 255.255.255.0
	 ipv6 address 2406:6401:2:1::1/64
	 ipv6 nd ra suppress all
	
	end
	```




##**Step 1.2: Pre-configured IPv4 / IPv6 addresses for customer and server hosts**

All customer hosts and server hosts have been pre-configured according to the addressing plan, no action is required on end-hosts in this step.

Following information describes network interface configuration of each end-host for your reference:


#### H1 ####

Interface ens32 (Connecting to R1 GigabitEthernet7)
 - IPv4 Address: 10.2.1.2/24
 - IPv4 Gateway: 10.2.1.1
 - IPv6 Address: 2001:DB8:2:1::2/64
 - IPv6 Gateway: 2001:DB8:2:1::1


#### H2  ####

Interface ens32 (Connecting to R2 GigabitEthernet7)
 - IPv4 Address: 10.2.2.2/24
 - IPv4 Gateway: 10.2.2.1
 - IPv6 Address: 2001:DB8:2:2::2/64
 - IPv6 Gateway: 2001:DB8:2:2::1
	

#### H5  ####

Interface ens32 (Connecting to R5 GigabitEthernet7)
 - IPv4 Address: 10.2.5.2/24
 - IPv4 Gateway: 10.2.5.1
 - IPv6 Address: 2001:DB8:2:5::2/64
 - IPv6 Gateway: 2001:DB8:2:5::1


#### H6  ####

Interface ens32 (Connecting to R6 GigabitEthernet7)
 - IPv4 Address: 10.2.6.2/24
 - IPv4 Gateway: 10.2.6.1
 - IPv6 Address: 2001:DB8:2:6::2/64
 - IPv6 Gateway: 2001:DB8:2:6::1
	


#### S1  ####

Interface ens32 (Connecting to ISP1 GigabitEthernet7)
 - IPv4 Address: 172.18.1.2/24
 - IPv4 Gateway: 172.18.1.1
 - IPv6 Address: 2406:6400:2:1::2/64
 - IPv6 Gateway: 2406:6400:2:1::1
	


#### S2 ####

Interface ens32 (Connecting to ISP2 GigabitEthernet7)
 - IPv4 Address: 172.26.1.2/24
 - IPv4 Gateway: 172.26.1.1
 - IPv6 Address: 2406:6401:2:1::2/64
 - IPv6 Gateway: 2406:6401:2:1::1




##**Step 1.3: Verifying point-to-point connectivity between routers**

>[!alert] Please perform this verification step only when you have fully completed previous configuration steps of this task.

Ping to remote point-to-point addresses for verifying router's point-to-point link connectivity.


#### **Test from R1 as example** ####

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

* Ping to IPv4 address on **R2 GigabitEthernet1**, type `ping 10.1.0.2`:

    ```powershell-nocode
	R1#ping 10.1.0.2
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 10.1.0.2, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

* Ping to IPv4 address on **R3 GigabitEthernet1**, type `ping 10.1.0.6`:

    ```powershell-nocode
	R1#ping 10.1.0.6
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 10.1.0.6, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

* Ping to IPv4 address on **R4 GigabitEthernet1**, type `ping 10.1.0.10`:

    ```powershell-nocode
	R1#ping 10.1.0.10
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 10.1.0.10, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

* Ping to IPv4 address on **ISP1 GigabitEthernet6**, type `ping 172.20.0.1`:

    ```powershell-nocode
	R1#ping 172.20.0.1
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 172.20.0.1, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

* Ping to IPv6 address on **R2 GigabitEthernet1**, type `ping 2001:DB8:1::1`:

    ```powershell-nocode
	R1#ping 2001:DB8:1::1
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 2001:DB8:1::1, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

* Ping to IPv6 address on **R3 GigabitEthernet1**, type `ping 2001:DB8:1:1::1`:

    ```powershell-nocode
	R1#ping 2001:DB8:1:1::1
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 2001:DB8:1:1::1, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

* Ping to IPv6 address on **R4 GigabitEthernet1**, type `ping 2001:DB8:1:2::1`:

    ```powershell-nocode
	R1#ping 2001:DB8:1:2::1
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 2001:DB8:1:2::1, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

* Ping to IPv6 address on **ISP1 GigabitEthernet6**, type `ping 2406:6400:4::`:

    ```powershell-nocode
	R1#ping 2406:6400:4::
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 2406:6400:4::, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```



### **Step 1.4: Verifying connectivity to customers** ###

>[!alert] Please perform this verification step only when you have fully completed previous configuration steps of this task.

Ping to customer's host addresses for direct connectivity verification.


#### **Test from R1 as example** ####

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

* Ping to IPv4 address on **H1 ens32**, type `ping 10.2.1.2`:

    ```powershell-nocode
	R1#ping 10.2.1.2
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 10.2.1.2, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

* Ping to IPv6 address on **H1 ens32**, type `ping 2001:DB8:2:1::2`:

    ```powershell-nocode
	R1#ping 2001:DB8:2:1::2
	Type escape sequence to abort.
	Sending 5, 100-byte ICMP Echos to 2001:DB8:2:1::2, timeout is 2 seconds:
	!!!!!
	Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```




##**Step 1.5: Verifying connectivity to servers**

>[!alert] Please perform this verification step only when you have fully completed previous configuration steps of this task.

Ping to server's host addresses for direct connectivity verification.


#### **Test from ISP1 as example** ####

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



* Ping to IPv4 address on **S1 ens32**, type `ping 172.18.1.2`:

    ```powershell-nocode
		ISP1#ping 172.18.1.2
		Type escape sequence to abort.
		Sending 5, 100-byte ICMP Echos to 172.18.1.2, timeout is 2 seconds:
		!!!!!
		Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

* Ping to IPv6 address on **S1 ens32**, type `ping 2406:6400:2:1::2`:

    ```powershell-nocode
		ISP1#ping 2406:6400:2:1::2
		Type escape sequence to abort.
		Sending 5, 100-byte ICMP Echos to 2406:6400:2:1::2, timeout is 2 seconds:
		!!!!!
		Success rate is 100 percent (5/5), round-trip min/avg/max = 1/1/1 ms
    ```

Once Ping test on all links are fine, we can move forward to next step for configuring routing protocols.