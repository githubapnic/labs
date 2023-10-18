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
sudo iptables -V
```
If it is not installed:
```bash
sudo apt-get install iptables
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
nano /home/apnic/iptables.sh
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

## Part 2: Uncomplicated Firewall (ufw)

Most Linux system comes with iptables – sophisticated software firewall – which is somewhat difficult to configure. Luckily, Ubuntu, as user-friendly community, decided to simplify this task, and so ufw was born.

UFW, or Uncomplicated Firewall, is a user-friendly front-end for managing iptables firewall rules on Ubuntu systems. Its main goal is to make managing iptables easier for users while maintaining the flexibility of iptables.

### Key Features of UFW:
- **User-Friendly Interface**: UFW provides a straightforward CLI (Command Line Interface) that simplifies the process of managing firewall rules.
- **Pre-configured Rules**: UFW comes with a set of pre-configured rules which can be used to quickly set up common firewall configurations.
- **Application Profiles**: Users can create profiles for different applications, making it easy to manage firewall rules for specific applications.
- **Logging**: UFW provides built-in logging to monitor and analyze traffic, which is a feature that can be customized to meet the user's needs.

### Basic Commands:
- **Installing UFW**:
  ```bash
  sudo apt install -y ufw
  ```
  
- **Enabling/Disabling Firewall**:
  ```bash
  sudo ufw enable
  sudo ufw disable
  ```
- **Allowing/Denying Traffic**:
  ```bash
  sudo ufw allow 80/tcp
  sudo ufw deny 80/tcp
  ```
- **Checking Firewall Status**:
  ```bash
  sudo ufw status
  ```
- **Checking help information**:
  ```bash
  sudo ufw -help
  ```  

### Comparison with iptables:
- **Ease of Use**: UFW is designed to be much easier to use than iptables, especially for those who are not familiar with firewall configurations. The syntax is simpler, and common tasks require fewer commands.
- **Abstraction**: UFW abstracts the complexity of iptables rules, providing a more user-friendly interface. However, this abstraction can be a limitation if very fine-grained control over firewall rules is required.
- **Pre-configured Rules**: UFW provides pre-configured rules for common use-cases, which can save time and reduce the likelihood of configuration errors.
- **Application Profiles**: The application profile feature of UFW can be a significant advantage when managing firewall rules for specific applications.



To work with ufw, you need to have administrative permissions. So, we append word sudo – stands for super user do(es) – so that command like `ufw status` turns into `sudo ufw status`. If you don’t do this, you’ll get the message **ERROR: You need to be root to run this script**.

Service commands
sudo ufw status – displays status of uncomplicated firewall. 
sudo ufw enable – turns firewall on. 
sudo ufw disable – turns firewall off. 
sudo ufw reload – applies rules to firewall.

Syntax
Syntax for ufw rules is as follows: ufw allow|deny|reject|limit in|out port/protocol

Where
Allow – accepts packets
Deny – drops packets
Reject – refuses packets
Limit – moderates packets
In – sets direction to incoming packets
Out – sets direction to outgoing packets
Port – defines target port. It can be: Numeric as 80 or Service name as http (see Services file) List as 80,110 (separated by comma, no space allowed) Range 8000:8080 (all ports from 8000 to 8080) Note! If you define list of ports, you can define maximum 15 items per rule. Range considered as 2 items.
Protocol – can be any, tcp or udp, depending on what you’re planning to filter.

Advanced syntax
This is also an advanced syntax, which allows you to define interface, manage entries in rule set, configure logging or define custom behavior for specific applications. For example: sudo ufw deny in on eth0 – drop all incoming packets on eth0 interface. 
sudo ufw allow out on eth0 to any port 25 proto tcp – allow all outgoing traffic on eth0 interface, to any address, at port 25 with protocol tcp.

NOTE To define protocol in complex rule, you should use append word proto and space. So, instead of 25/tcp, you should write 25 proto tcp.
sudo ufw insert 1 allow 80 – places “allow all traffic on port 80” rule at first place in rule set.
sudo ufw delete 1 – removes rule number 1 from rules list. 
sudo ufw show user-rules – displays user-defined rule set.

Can be also
raw – for displaying of all sets
builtins – for internal rule set
before-rules – for rules appended before main rule set
user-rules – for rules defined by user (you)
after-rules – for rules appended after main rule set
logging-rules – for rules with logging enabled
listening – for displaying listening tcp and open udp ports
sudo ufw delete deny out 8080 – removes rule “deny all outbound traffic on port 8080” from the rule set \\  sudo ufw allow log 80/tcp – allows all traffic on tcp port 80, logging new connections only
sudo ufw allow log-all 80/tcp – allows all traffic on tcp port 80, logging all connections
NOTE Always place log command between allowance mode and port.
sudo ufw logging off – turns off logging. Can be also low, medium, high and full. Defaults to low.

NOTE Higher logging modes generate more logging information, which can overload your disk with time (especially on busy or overloaded system).
sudo ufw app list – display application profiles list
 sudo ufw app info CUPS – display detailed profile for program named CUPS
sudo ufw allow 631 app CUPS – adds “allow all traffic on port 631” to CUPS application profile 
sudo ufw app update CUPS – flushes firewall rules, related to CUPS application profile
NOTE Profiles are generally used by software, essentially for remote management.
Default policy
Ufw is based on principle – check against all rules, and if no rule is applicable, follow default policy. This is common principle of iptables firewall, which sometimes causing confusion for new users. For example, computer receives incoming packet from remote host for port 80. There is no rule defining what to do with incoming packets for port 80, so computer follows default policy.

Policies, by default, are set to deny for incoming and accept for outgoing, which seems reasonable enough.

See, there are few cases when we need to allow inbound connections, so, naturally, it’s easier to define “what to allow”, instead of defining everything denied. Same applies for outbound connections, since all networking application need remote access. In rare case, when you would like to change default policy, you can issue one of the following commands:
sudo ufw default allow incoming – sets default policy to “allow inbound packets”
sudo ufw default reject outgoing – sets default policy to “refuse outbound packets”

Exercise these Rules for testing
NOTE Adding new rules require firewall to be running, or changes will be lost. To do this, type in sudo ufw enable.
sudo ufw allow 22 – permits all traffic on port 22
sudo ufw deny 110 – drops all traffic on port 110
sudo ufw reject http – refuses (notifying the other side) all traffic on http service port (which is 80)
sudo ufw allow in 21 – allows all incoming traffic on port 21
sudo ufw deny out 8080 – denies all outgoing traffic on port 8080
sudo ufw allow from 123.45.67.89 – allows any traffic coming from 123.45.67.89
sudo ufw limit 22/tcp – drops all connections on tcp port 22, if there were over 6 connections to this port with-in last 30 seconds
sudo ufw reset – clears all rules (equivalent to iptables –F command that we used
Now we like to implement our own ruleset with UFW that we used in iptables exercise. For example convert this command to the following:
iptables -A INPUT -i lo -j ACCEPT convert it to sudo ufw allow in on lo
Or
iptables -A INPUT -p tcp –dport 25 -j ACCEPT to sudo ufw allow in 25/tcp
					
***END OF EXERCISE***
