![](images/apnic_logo.png)
# LAB : Firewall exercises using IPTables

**Lab Overview** <br>
In this lab you will be utilising iptables to create complex rules and explore some of the options. You can access the lab environment during the tutorial.

**Prerequisites** <br> 
Knowledge of Ubuntu, linux commands, and network protocols.

## Lab Tasks
Step 1: Update or install iptables software<br>
Step 2: Review filter policy <br>
Step 3: Build packet filtering rules to restrict access to certain applications depending on the target audience <br>
Step 4: Confirm the rules are working <br>
Step 5: Learn how to permanently save the iptables rules <br>

**Login Details**
 
* Username `apnic` and password `training`.

Login to the server (SSH using the username and password given above), where **XX** is the group number:

	ssh apnic@192.168.30.XX
	
NOTE: Type `yes` if asked about wanting to continue connecting

Password = `training`

## Part 1: Installation (We do not have to do this step)
You can check if iptables is installed in your system by doing:

```bash
$ sudo iptables -V
```
If it is not installed:
```bash
$ sudo apt-get install iptables
```

## Filtering policy
- Host must be able to access all of its own applications (localhost)
- Host must allow SMTP connections from anywhere
- Host must allow SSH access only from the campus network
- Host must allow access to the web server only from the local network
- Host must allow access to SNMP only from the local network
- All incoming TCP/UDP traffic must be blocked, except for established connections
- ICMP must be rate-limited to 3 packets per second

For that, we are going to create a text file, which will help us build the ruleset more easily. Make sure to replace “X” with your group number when necessary:
```bash
$ nano /home/apnic/iptables.sh
```
Type the following information into the text editor:

```bash
# Flush any existing rules
iptables -F

# Permit any incoming packet on the loopback interface
iptables -A INPUT -i lo -j ACCEPT 

# SMTP must be open so that we can accept mail from the world
iptables -A INPUT -p tcp --dport 25 -j ACCEPT

# SSH restricted to the campus network
iptables -A INPUT -s 192.168.30.0/24 -p tcp --dport 22 -j ACCEPT

# HTTP and HTTPS restricted to the local network only
iptables -A INPUT -s 192.168.30.0/24 -p tcp --dport 80 -j ACCEPT 
iptables -A INPUT -s 192.168.30.0/24 -p tcp --dport 443 -j ACCEPT 

# SNMP restricted to the local network only
iptables -A INPUT -s 192.168.30.0/24 -p udp --dport 161 -j ACCEPT 

# Rate-limit ICMP traffic to 3 packets per second
iptables -A INPUT -p icmp -m recent --set
iptables -A INPUT -p icmp -m recent --update --seconds 1 --hitcount 3 -j DROP

# Then, permit all traffic initiated from this machine to come back
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT 

# And finally, block all incoming TCP traffic
iptables -A INPUT -s 0/0 -p tcp --tcp-flags SYN,RST,ACK SYN -j REJECT

# and all UDP traffic
iptables -A INPUT -s 0/0 -p udp -j REJECT 
```
Save this file and exit. Now, let's apply those rules:
```bash
sudo sh /home/apnic/iptables.sh
```
And verify that the rules are there:
```bash
sudo iptables -L
```
You should see the rules you have created. If you'd rather see numeric output, do the following:
```bash
sudo iptables -L -n
```
Now, let's test to make sure that the rules are working. Check that you can connect to services on localhost (if you have not installed Apache, do so now):
```bash
telnet localhost 80
```
You should see something like this:
```plaintext
# telnet localhost 80
Trying 127.0.0.1...
Connected to localhost.
Escape character is '^]'.
To exit, type 'Ctrl-]', and then 'quit'
```
Now, ask the members of your group to check connectivity against your web server:
```plaintext
apnic@group2:~$ telnet group1 80
```
They should be able to connect. Now, ask someone from ANOTHER group, to test:
```plaintext
telnet group1 8080
```
(If they are able to connect, then you did something wrong. Go back to your file, fix the rules, and run the sh command again).

Now, test the ICMP rate limiting. Ask one of your classmates to do the following against your pc:
```bash
sudo ping -f group1
```
What is that `-f`? It stands for “flood”, which means that pc2 will try to send as many ICMP echo request packets as possible. Ask your classmate to run that for about 5 seconds, and then stop with Ctrl-C. Then, ask them to check the statistics. There should be a high “packet loss” value, and the number of packets received should not be greater than 3 per second (15 packets total if they ran it for 5 secs)

If all the tests look good, you could save those rules in order to have Linux re-apply them when it reboots:
```bash
sudo apt-get install -y iptables-persistent netfilter-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload
```

Issue the following command to flash all rules for the next exercise

```bash
sudo iptables -F
```

For further information refer to:

* [https://gist.github.com/jirutka/3742890](https://gist.github.com/jirutka/3742890)
					
***END OF EXERCISE***
