![](images/apnic_logo.png)
# LAB : IPTable rule creation

**Lab Overview** <br>
In this lab you will be utilising iptables to create a simple rule and explore some of the options. You can access the lab environment during the tutorial.

**Prerequisites** <br> 
Knowledge of Ubuntu, linux commands, and network protocols.

## Lab Tasks
Step 1: Update or install iptables software<br>
Step 2: Test ping works <br>
Step 3: Create iptable rule <br>
Step 4: Confirm ping is blocked <br>

**Login Details**
 
* Username `apnic` and password `training`.

Login to the server (SSH using the username and password given above), where **XX** is the group number:

	ssh apnic@192.168.30.XX
	
NOTE: Type `yes` if asked about wanting to continue connecting

Password = `training`

### Part 1. Installation and rule creation

1. Download the latest version of iptables.

	```
	sudo apt update && sudo apt install -y iptables
	```
			
2. Try to ping **127.0.0.1**

	```
	ping -c 2 127.0.0.1
   	```
 
3. Add a rule to drop (block) icmp traffic from the ip address of 127.0.0.1

	```
	sudo iptables -A INPUT -s 127.0.0.1 -p icmp -j DROP
	```
 
| Option         | Command        | Description                                                                                                   |
|----------------|----------------|---------------------------------------------------------------------------------------------------------------|
| `-A INPUT`     | Append Rule    | Appends a new rule to the `INPUT` chain, which processes packets entering the system.                         |
| `-s 127.0.0.1` | Source Address | Specifies that the rule applies to traffic coming from the IP address `127.0.0.1`, the loopback address.      |
| `-p icmp`      | Protocol       | Specifies that the rule applies to ICMP (Internet Control Message Protocol) traffic.                          |
| `-j DROP`      | Jump Target    | Specifies the action to take if a packet matches the rule. In this case, `DROP` discards the packet.         |


5. Try to ping **127.0.0.1**

	```
	ping -c 2 127.0.0.1
   	```
 
6. Review the rules in the iptables list.

	```
	sudo iptables -L --line-numbers
	```
 
7. Delete the rule that is dropping icmp.

	```
	sudo iptables -D INPUT 1
	```
    
8. Try to ping **127.0.0.1**

	```
	ping -c 2 127.0.0.1
	```
 
9. If the machine reboots, the rules will be deleted. To ensure the rules remain after a reboot, extra software is needed.

	```
	sudo apt-get install -y iptables-persistent netfilter-persistent
	sudo netfilter-persistent save
	sudo netfilter-persistent reload
	```
 
10. The following rule will block all IPv6 traffic trying to connect to Secure SHell (SSH)

	```
 	sudo ip6tables -t filter -A INPUT -p tcp -s ::/0 --dport 22 -j DROP
	```
 
| Option        | Command           | Description                                                                                                         |
|---------------|-------------------|---------------------------------------------------------------------------------------------------------------------|
| `-t filter`   | Table Selection   | Specifies the table to which the rule should be added. In this case, it's the `filter` table.                       |
| `-A INPUT`    | Append Rule       | Appends a new rule to the `INPUT` chain, which processes packets coming into the system.                           |
| `-p tcp`      | Protocol          | Specifies that the rule applies to TCP traffic.                                                                     |
| `-s ::/0`     | Source Address    | Specifies that the rule applies to traffic coming from all IPv6 addresses (the equivalent of `0.0.0.0/0` in IPv4). |
| `--dport 22`  | Destination Port  | Specifies that the rule applies to traffic destined for port `22`, typically used for SSH connections.             |
| `-j DROP`     | Jump Target       | Specifies the action to take if a packet matches the rule. In this case, `DROP` discards the packet.               |


12. The following rule will allow IPv4 traffic from 192.168.30.0/24 network to connect to Secure SHell (SSH)

	```
 	sudo iptables -t filter -A INPUT -p tcp -s 192.168.30.0/24 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
	```
 
| Option                     | Command        | Description                                                                                                       |
|----------------------------|----------------|-------------------------------------------------------------------------------------------------------------------|
| `-t filter`                | Table Selection| Specifies the table to which the rule should be added. In this case, it's the `filter` table.                     |
| `-A INPUT`                 | Append Rule    | Appends a new rule to the `INPUT` chain, which processes packets coming into the system.                         |
| `-p tcp`                   | Protocol       | Specifies that the rule applies to TCP traffic.                                                                   |
| `-s 192.168.30.0/24`       | Source Address | Specifies that the rule applies to traffic coming from the IP address range `192.168.30.0` to `192.168.30.255`.  |
| `--dport 22`               | Destination Port| Specifies that the rule applies to traffic destined for port `22`, typically used for SSH connections.           |
| `-m conntrack`             | Match Extension| Employs the `conntrack` module to track the state of connections.                                                  |
| `--ctstate NEW,ESTABLISHED`| Connection State| The rule applies to new connections (`NEW`) and already established connections (`ESTABLISHED`).                  |
| `-j ACCEPT`                | Jump Target    | Specifies the action to take if the packet matches the rule. In this case, `ACCEPT` allows the packet to continue|

**Hint: ** This rule allows incoming TCP traffic from the IP range 192.168.30.0/24 to port 22 (typically used for SSH) on the local machine, for both new and established connections. This is useful for managing SSH access to your system from a specific network range, which can be a part of network security and access control strategies.

For further information refer to:

* [https://www.hostinger.com/tutorials/iptables-tutorial](https://www.hostinger.com/tutorials/iptables-tutorial)
* [https://www.cyberciti.biz/faq/ubuntu-start-stop-iptables-service/](https://www.cyberciti.biz/faq/ubuntu-start-stop-iptables-service/)
					
***END OF EXERCISE***
