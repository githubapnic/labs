![](images/apnic_logo.png)
# LAB : IPTable rule creation

**Lab Overview** <br>
In this lab you will be utilising tshark to analyse packet capture (PCAP) files and capture network traffic. Preferably this lab will be done locally on your own machine, but you can access the lab environment during the tutorial.

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

<style>
code {
  white-space : pre-wrap !important;
  word-break : break-word;
}
</style>

### Part 1. Installation and rule creation

1. Download the latest version of iptables.

		sudo apt update && sudo apt install -y iptables
			
2. Try to ping **127.0.0.1**

   ping -c 2 127.0.0.1
   
3. Add a rule to drop (block) icmp traffic from the ip address of 127.0.0.1

   sudo iptables -A INPUT -s 127.0.0.1 -p icmp -j DROP

3. Try to ping **127.0.0.1**

   ping -c 2 127.0.0.1
   
7. Review the rules in the iptables list.

   sudo iptables -L --line-numbers

8. Delete the rule that is dropping icmp.

    sudo iptables -D INPUT 1
   
9. 3. Try to ping **127.0.0.1**

   ping -c 2 127.0.0.1

10. If the machine reboots, the rules will be deleted. To ensure the rules remain after a reboot, extra software is needed.

    sudo apt-get install -y iptables-persistent netfilter-persistent
    sudo netfilter-persistent save
    sudo netfilter-persistent reload

11. The following rule will block all IPv6 traffic trying to connect to Secure SHell (SSH)

    sudo ip6tables -t filter -A INPUT -p tcp -s ::/0 --dport 22 -j DROP

12. The following rule will allow IPv4 traffic from 192.168.30.0/24 network to connect to Secure SHell (SSH)

    sudo iptables -t filter -A INPUT -p tcp -s 192.168.30.0/24 --dport 22 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

For further information refer to:

* [https://www.hostinger.com/tutorials/iptables-tutorial](https://www.hostinger.com/tutorials/iptables-tutorial)
* [https://www.cyberciti.biz/faq/ubuntu-start-stop-iptables-service/](https://www.cyberciti.biz/faq/ubuntu-start-stop-iptables-service/)
					
***END OF EXERCISE***
