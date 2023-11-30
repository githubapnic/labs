
![](images/apnic_logo.png)<

#<center><b>Memory Analysis</b></center>

##**About this Hands-On Session**
This lab has been designed for you to learn live system forensic and memory analysis. The lab exercises are part of a workshop. 

<b>Prerequisites:</b> Knowledge of Ubuntu, linux commands, Intrusion Detection Systems, packet capture, security and ransomware concepts. 

 
###**Lab Contents - Memory Analysis (on Lubuntu desktop)** 

####**Duration:** This Lab can be completed within 3 hours.

This session is broken-down into following labs:

* [Lab 0 - Setup Docker](#centerblab-0---setup-dockerbcenter)
* [Lab 1 - Live Forensics](#centerblab-1---live-forensicsbcenter)
* [Lab 2 - Introduction to Volatility](#centerblab-2---introduction-to-volatilitybcenter)
* [Lab 3 - Introduction to Volatility part 2](#centerblab-3---introduction-to-volatility-part-2bcenter)
* [Lab 4 - Windows Memory Dump](#centerblab-4---windows-memory-dumpbcenter)

#<center><b>Lab 0 - Setup Docker</b></center>

This section, is a step-by-step guide on installing Docker, a powerful platform for building, deploying, and managing containerised applications. Once Docker is set up, we'll proceed to configure the blacktop/volatility Docker image, an essential tool for forensic analysis which integrates Volatility for memory forensics and YARA for malware detection. 

This lab will highlight the convenience and efficiency of using Docker containers for forensic analysis, enabling you to perform sophisticated memory and malware investigations with ease. The containerised approach ensures a consistent and isolated environment, crucial for the integrity and repeatability of forensic analysis.

>[!Warning] As this system is not connected to the internet, all the below steps have been completed for you.

###**Install docker**

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- [X] Install dependencies that are required for docker.

	```PowerShell-nocode
	sudo apt-get update && sudo apt-get install -y ca-certificates curl gnupg lsb-release
	```

- [X] Add Docker's gpg public key to the trusted store.

	```PowerShell-nocode
	sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	```

- [X] Add Docker's repo to the list of sources that Ubuntu can install software from.

	```PowerShell-nocode
	echo \
	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	```

- [X] Install Docker.

	```PowerShell-nocode
	sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
	```

- [X] Add the current user to the Docker group.

	```PowerShell-nocode
	sudo groupadd docker &&  sudo usermod -aG docker $USER
	```

- [X] Log off and back on or restart to make the new group active or can use **su - apnic**

	```PowerShell-nocode
	su - apnic
	```

- [X] Confirm docker is installed.

	```PowerShell-nocode
	docker compose version
	```

	>[!Knowledge] For more detail refer to [https://docs.docker.com/engine/install/ubuntu/](https://docs.docker.com/engine/install/ubuntu/)

###**Download a volatility and yara docker image**	

- [X] Download the docker image from [https://hub.docker.com/r/blacktop/volatility](https://hub.docker.com/r/blacktop/volatility)

	```PowerShell-nocode
	docker pull blacktop/volatility
	```

	>[!Hint] Here is a list of docker images that have volatility installed [https://hub.docker.com/search?q=volatility](https://hub.docker.com/search?q=volatility)

- [X] Download the memory dumps required for the lab and extract.

	```PowerShell-nocode
	cd ~
	wget https://training-wiki.s3.ap-southeast-1.amazonaws.com/2023/11+November/20231127+Practical+Cybersecurity+PACNOG32/memoryanalysis.zip
	unzip memoryanalysis.zip
	cd memoryanalysis
	unzip memUbuntu.zip
	unzip stuxnet.vmem.zip
	```

- [X] Confirm the docker image works.

	```PowerShell-nocode
	docker run --rm -v /home/apnic/memoryanalysis:/data:ro blacktop/volatility -h
	```	



| Command Part                       | Description                                                                                                                                                                     |
|------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| docker run                       | Runs a Docker container.                                                                                                                                                        |
| --rm                             | Automatically removes the container when it stops. This is useful for keeping the system clean of unused containers.                                                           |
| -v /home/apnic/memoryanalysis:/data:ro | Mounts a volume from the host system into the Docker container. Mounts **/home/apnic/memoryanalysis** from the host to **/data** in the container as read-only.                     |
| blacktop/volatility              | Specifies the Docker image to use, which in this case is **blacktop/volatility**, containing the Volatility tool.                                                                 |
| -h                               | An argument passed to the Volatility tool, typically meaning "help". Displays the help information for Volatility.                                                             |

- [X] Create a permanent alias/shortcut to use **volatility** to run the above command, by adding it the bash profile.

	```PowerShell-nocode
	echo "alias volatility='docker run -it --rm -v \$(pwd):/data:ro blacktop/volatility \$@'" >> ~/.bash_aliases
	```

	>[!Knowledge] An alias simplifies complex commands into short, memorable keywords, enhancing efficiency and reducing typing errors.


To learn more about Docker refer to:

1. **Docker Official Documentation**  
   [Docker Docs](https://docs.docker.com)  
   The official Docker documentation provides comprehensive guides, tutorials, and reference materials for all Docker features and commands.

2. **Docker Get Started Guide**  
   [Docker Get Started](https://www.docker.com/get-started)  
   This guide from Docker's official website is great for beginners, offering a step-by-step introduction to Docker concepts and usage.

3. **Docker Tutorial by Docker Labs**  
   [Docker Labs](https://github.com/docker/labs)  
   Docker Labs offers a variety of tutorials and labs, hosted on GitHub, which are great for practical, hands-on learning of Docker.	


>[!Hint] Ensuring the safety of a Docker image involves several steps and considerations:

1. **Use Official or Verified Images**: Prefer images from Docker's official library or those verified by Docker. These images are typically maintained by the software's developers or Docker, ensuring a certain level of trust and security.

2. **Check the Image's Source**: Always know where your Docker images are coming from. Trusted sources like Docker Hub often have user reviews and ratings that can give you an idea of the image's reliability.

3. **Review the Dockerfile**: If available, inspect the Dockerfile used to build the image. This can give you insights into what the image contains and how it is configured.

4. **Look for Recent Updates**: Regularly updated images are more likely to have current security patches. Check when the image was last updated and whether it is actively maintained.

5. **Scan for Vulnerabilities**: Use tools like Docker's own scanning tool, Trivy, Clair, or others to scan the image for known vulnerabilities.

6. **Understand the Layers**: Docker images are built in layers. Understanding these layers and what each adds to the final image can be crucial in assessing its safety.

7. **Check Image Digests**: Docker images have a digest (a SHA256 hash). Ensure that the digest matches what you expect, especially when pulling images from registries.

8. **Consider Image Size**: Larger images might contain unnecessary software, increasing the attack surface. Leaner images are generally preferable from a security standpoint.

9. **Community and Support**: For open-source images, check the community and support around it. A strong community can be a good indicator of a reliable and safe image.

10. **Be Wary of Outdated Software**: Make sure the software within the Docker image is not outdated or end-of-life, as these can contain unpatched security vulnerabilities.

Remember, while these steps can significantly reduce the risk, no method guarantees 100% safety. It's always a balance between usability, performance, and security.   





#<center><b>Lab 1 - Live Forensics</b></center>

This lab provides a practical guide to conducting live forensics on a compromised Linux system, emphasising the importance of investigating suspicious processes in real-time to gather evidence and identify potential security threats. 

For more information refer to the cheatsheet: [https://www.sandflysecurity.com/blog/compromised-linux-cheat-sheet/](https://www.sandflysecurity.com/blog/compromised-linux-cheat-sheet/)

The steps to complete this section are:
* Simulating an attack using Netcat to open a bind shell backdoor.
* Identifying and monitoring suspicious processes.
* Exploring information related to running processes in the /proc directory.
* Recovering deleted binary files of suspicious processes.
* Validating the integrity of recovered binaries.
* Investigating process names, parameters, and environments.
* Examining file descriptors, process maps, and stack information.
* Reviewing overall process details using /proc/$PID/status.

###**Basic Linux Malware Forensics**

We'll perform a step-by-step analysis of a _bind shell backdoor_ waiting for a connection on an Ubuntu Server. In this section, you'll understand the significance of running processes for investigation. These information are volatile as well, such that they will be gone if the computer is turned off. In other words, you will not get some of these information from the physical disk imaging. 

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- [] Simulating an attack. In this case we will use Netcat (nc) to open a TCP shell on port 31337. We'll make it send data to /dev/null instead of giving shell. 

    ```
    cd /tmp 
    cp /bin/nc /tmp/x7
	```

	Use the x7 file to open a TCP shell on port 31337

	``` 
    ./x7 -vv -k -w 1 -l 31337 > /dev/null & 
	```

	Delete the **x7** file

	```
    rm x7 
    ```
    
    In the above we made a copy of the netcat binary, renamed it to x7 and made it listen on port 31337. Then deleted x7 file.

- [] Verify that x7 is running. Please take note of the process id (number)

	```
	ps aux | grep x7 
	```

    ![](images/image00%20ps%20aux.png)

    What is the process ID? 
    
    @lab.TextBox(processId) 

- [] Check for the network activities 

    ```
    netstat -punat
    ```

    netstat shows a process named 'x7' PID with a listening port that of **31337**.
    
    ![image01 netstat.png](images/image01%20netstat.png)

- [] When doing live forensics on Linux, /proc is your best friend! A lot of information related to running processes are kept in /proc/$PID
	
    ```
    ls -al /proc/@lab.Variable(processId)
	```

    ![image02 procID.png](images/image02%20procID.png)

	

	```
    ls -al /proc/@lab.Variable(processId) | grep -E "tmp|x7"
	```

    This will show a few interesting things: 
    - The current working directory (cwd) is /tmp 
    - The binary was in /tmp but was deleted 

	>[!Hint] A lot of exploits work out of /tmp and /dev/shm on Linux. These are both world writable directories on almost all Linux systems and many malware and exploits will drop their payloads there to run. A process that is making its home in /tmp or /dev/shm is suspicious.

- [] Now we will try to recover the deleted binary. As long process is still running, it is very easy to recover a deleted process binary on Linux:
	
    ```
    cp /proc/@lab.Variable(processId)/exe /tmp/recovered_bin 
    ```

	**Note**: Basically /proc/@lab.Variable(processId)/exe is a copy of the running executable. This makes it worthwhile to recover the binary and save it somewhere before you kill the process or shutdown the machine. Of course, we need to be careful 

- [] Now we will validate the copied file with the original binary (Netcat)
	
    ```
    md5sum recovered_bin /bin/nc
    ```

	Compare the hash. In addition to md5sum, you can also use sha256sum. If both hashes are the same then we are looking at the same binaries/files  

	```
	sha256sum recovered_bin /bin/nc
	```

	![image03 compare hash.png](images/image03%20compare hash.png)

- [] We will now explore the commands (name & full parameters) of the process. Some malware will give itself a vague or closely to legit process names (i.e. apache or sshd), so we can check both /proc/$PID/comm and /proc/$PID/cmdline 

	```
    cat /proc/@lab.Variable(processId)/comm
    ```

	```
    cat /proc/@lab.Variable(processId)/cmdline && echo "\n"
    ```
	
    Both results are x7 but we can see the parameters that was used when issuing the command 
    
    ![image04 commands typed.png](images/image04%20commands%20typed.png)


- [] Malware process environment. Now let’s take a look at the environment our malware inherited when it started. This can often reveal information about who or what started the process. Here we see the process was started with sudo by another user:

	```
    strings /proc/@lab.Variable(processId)/environ 
    ```

	Have a look at the output as it provides information on users, location, directory path, etc 
    
    ![image05 strings.png](images/image05%20strings.png)

- [] We can also see the file descriptors that the malware has open. This can often show you hidden files and directories that the malware is using to stash things along with open sockets:

	```
    ls -al /proc/@lab.Variable(processId)/fd
    ```

	- This shows that the open file descriptors that process has 
	- You can see that 0,1,2 stdin/stdout/stderr and there is also an open socket
    
    ![image06 fd.png](images/image06%20fd.png)

- [] Another area to look into is the Linux process maps. This shows libraries the malware is using and again can show links to malicious files it is using as well.
	
	```
    cat /proc/@lab.Variable(processId)/maps 
    ```

	The /proc/$PID/maps file will show libraries and other data the binary has open. It can help reveal hidden areas where the process is stashing data or libraries that are malicious. 
    
    ![image07 maps.png](images/image07%20maps.png)

- [] The /proc/$PID/stack area can sometimes reveal more details. We’ll look at that like this:

	```
    sudo cat /proc/@lab.Variable(processId)/stack
    ```

	This file provides additional insights on what the malware/process might be doing. These accept() calls indicate that it is waiting for an inbound network connection. If a process is hiding the network port from netstat, you can still see what it is doing here. 
    
    ![image08 stack.png](images/image08%20stack.png)

- [] Finally, let’s look at /proc/$PID/status for overall process details. This can reveal parent PIDs and so forth.

	```
    cat /proc/@lab.Variable(processId)/status 
    ```

	This file gives information on parent PIDs (if any), memory usage, etc
    
    ![image09 status.png](images/image09%20status.png)

- [] Discussion / Let's Recap 
	
    @lab.Activity(Question1)
	
    @lab.Activity(Question2)

    @lab.Activity(Question3)

    For more information refer to the cheatsheet: [https://www.sandflysecurity.com/blog/compromised-linux-cheat-sheet/](https://www.sandflysecurity.com/blog/compromised-linux-cheat-sheet/)

Please click the Next button to continue.



#<center><b>Lab 2 - Introduction to Volatility</b></center>

For this lab, we will be analysing a linux memory dump from a binary that was obtained from the honeypot. 

The process that is associated with the malware is "krn".

All of the artefacts are located in the the folder memoryanalysis. 

The steps to complete this section are:

* Analysis with Volatility
* Extract information about the system build and kernel version
* Explore Available Linux Commands
* Enumerate Active Processes
* Gather Network Interface Information
* Retrieve Command History
* List and Extract Open Files

####**Analysis with Volatility**

Volatility is an open-source memory forensics framework used by cybersecurity professionals to analyse and extract valuable information from computer memory dumps. It allows investigators to examine running processes, network connections, and other system data to uncover evidence of malicious activity or security breaches.

With the memory acquired, we will explore Volatility 

- [] Basic usage is as follows: **volatility --plugins=.  -f "memory-dump" --profiles="profile of OS kernel" OScommands**. Let's try to find the linux banner first. 

	```
	cd ~/memoryanalysis 
	volatility --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_banner
	```

	| Command Part          | Description                                                                                      |
	|-----------------------|--------------------------------------------------------------------------------------------------|
	| volatility           | Main Volatility command for memory analysis.                                                      |
	| --plugins=.        | Specifies the directory for plugins (current directory in this case).                               |
	| -f memUbuntu.raw    | Indicates the input file, which is "memUbuntu.raw," the memory dump for analysis.                 |
	| --profile=LinuxUbuntu_4_4_0-21x64 | Specifies the profile for analysis, tailored to the Linux system with a specific kernel version. |
	| linux_banner        | The Volatility plugin used to extract information about the Linux system, including the kernel version and build details. |
	
- [] You can find other commands that are available to Linux profile. 
	
	```
	volatility --info | grep -i Linux 
	```

	>[!Hint] Think about which commands could be useful? 


- [] The **linux_pslist** enumerates all the active processes in the system.
	
	```
	volatility --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_pslist 
	```

	@lab.Activity(Question4) 
	
	Try using **linux_pstree** to get a better understanding of the parent-child relationships between various processes.

	
	```
	volatility --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_pstree
	```	


- [] The **linux_ifconfig** plugin shows information about all the active interfaces, associated IPs in the system.
	
	```
	volatility --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_ifconfig
	```

	@lab.Activity(Question5)

- [] Retrieving history of executed commands is always a valuable forensic artefact. It can give us an insight into what the adversary might’ve executed on the system. When analysing windows memory dumps, we use the plugin **cmdscan** for retrieving command history. In the case of Linux memory dumps, use **linux_bash** command
	
	```
	volatility --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_bash 
	```

    >[!Hint] For this exercise this command has no output

- [] Listing & extracting open files from a memory dump is always necessary. The attacker might open text documents, word documents, images or PDFs etc… These files may contain extremely valuable information and help us get a better idea about the scenario. Use the **linux_enumerate_files** command 

	```
	volatility --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_enumerate_files 
	```

	This plugin gives the inode address (which is the base address of the file), the inode number and the full path to file.

	>[!Hint] The **linux_find_file** plugin is used to extract the files based on their inode address and dump them to disk.

	@lab.Activity(Question6)

	@lab.Activity(Question7)	

Please click the Next button to continue.



#<center><b>Lab 3 - Introduction to Volatility part 2</b></center>

In this lab, you will be exploring Volatility and see how to use some features for further analysis. 

Analysis begins with questions. For example: 

* What is this malware doing? 
* What is it modifying? 
* Are there any network activities? 
* Did it create more process? 
* Where is it hiding (if it has been deleted)

Let's explore the above	questions with our Memory dump called **memUbuntu.raw**.



- [] What is the process id of **krn** and when was it launched? Try using the Linux Plugins such as linux_pslist , linux_pstree, linux_pidhashtable 
	

	``` 
	cd ~/memoryanalysis
	volatility  --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_pidhashtable
	```

	>[!Hint] Try adding **| less** or **| grep -E "Pid|krn"** to the end of the command

	@lab.Activity(Question8)

- [] Some plugins allow passing of paramaters (i.e. pid or file path). Let's find where _krn_ is executed from, by using the Linux Plugin called **linux_proc_maps** and **1351** will be used as the PID for the krn process in the memory dump. 
	

	```
	volatility --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_proc_maps -p 1351
	```

	@lab.Activity(Question9)	

- [] Now we would like extract the file in memory, to do that we will need Inode information using the **linux_find_file** command to find the Inode number & inode (in memory) for a file 

	```
	volatility  --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_find_file -F "/home/analyst/workspace/malware/._lul/krn"
	```

	The above commands doesn't work as expected using the docker image. Instead add **/lib64/lib64** to the beginnning of the path.

	```
	volatility  --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_find_file -F "/lib64/lib64/home/analyst/workspace/malware/._lul/krn"
	```

	It should  look similar to the following, take note of the Inode because we will need it. Your Inode number will be different than the example below if you use your own memory capture. 


	![image10 lib64.png](images/image10%20lib64.png)


- [] Volatility can be used to "dump" the file from memory using the information from above using the plugin **linux_find_file** and pass the parameter -O $filelame

	```
	volatility  --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_find_file -i 0xffff88003d1004c8 -O dump.elf 
	```

	>[!Warning] There will be an error about permissions, because the docker command mounts the file system as read only

	Update the permissions for **/home/apnic/memoryanalysis** to allow anyone to write to the directory

	```
	sudo chmod 777 /home/apnic/memoryanalysis
	```

	Run the docker command, mount the folder as read/write enabled and run as a root user.

	```
	docker run --rm -v /home/apnic/memoryanalysis:/data:rw --user root blacktop/volatility --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_find_file -i 0xffff88003d1004c8 -O dump.elf
	```

	![image11 dump elf.png](images/image11%20dump%20elf.png)

- [] To extract the binary from memory for our _krn_ process use another plugin called **linux_procdump**. We need to specify the folder for dumping the processes with -D.

	```
	mkdir dump 
	volatility  --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_procdump -D dump -p 1351 
	```

	>[!Hint] If you don't pass a specific process id, it will try to dump everything. 

	>[!Warning] There will be an error about permissions, because the docker command mounts the file system as read only.

	![image12 dump error.png](images/image12%20dump%20error.png)

	Update the permissions for **/home/apnic/memoryanalysis/dump** to allow anyone to write to the directory

	```
	sudo chmod 777 /home/apnic/memoryanalysis/dump
	```

	Run the docker command, mount the folder as read/write enabled and run as a root user.

	```
	docker run --rm -v /home/apnic/memoryanalysis:/data:rw --user root blacktop/volatility --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_procdump -D dump -p 1351
	```

	Check that it is a binary file? (hint: Use file)

	```
	file dump/krn.1351.0x400000
	```

	![image13 dump 1351.png](images/image13%20dump%201351.png)

- [] To confirm any network activities from _krn_, use the plugin **linux_netstat**

	```
	volatility  --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_netstat -p 1351
	```

	@lab.Activity(Question10)

	@lab.Activity(Question11)

	>[!Hint] Use virustotal and check if the IP address is malicious. [https://www.virustotal.com/](https://www.virustotal.com/gui/ip-address/131.153.76.130)

- [] Yara is an open source tool for malware researchers. It uses pattern matching to identify and classify malware. Volatility has Yara integration and we can use it to scan the memory dump for signs of malware. 

	View the first 10 lines of the yara rules file.

	```
	head malware_rules.yar
	```

	How many lines of code is in the malware_rules.yar file?

	```
	wc -l malware_rules.yar
	```

	>[!Hint] **malware_rules.yar** file contains signatures related to malware 

	Scan the memory dump for signs of malware.

	```
	volatility  --plugins=. -f memUbuntu.raw --profile=LinuxUbuntu_4_4_0-21x64 linux_yarascan  -y malware_rules.yar
	```
	
	>[!Note] This may take a while.

	@lab.Activity(Question12)


- [] Discussion 
	- What do you like about Volatility? 
	- What are its limitation? 
	- How would you use this in a real scenario, what preparation would you have to make? 
	- What can be said about this cryptominer? [https://attack.mitre.org/techniques/T1496/](https://attack.mitre.org/techniques/T1496/)
	- What threat information from our analysis can we use to mitigate further and how? 


- [] Resources
	
	To learn more about Volatility and YaraScan:

	1. **Volatility Foundation**  
	[Volatility GitHub Repository](https://github.com/volatilityfoundation/volatility)  
	The official GitHub repository of the Volatility Foundation offers comprehensive resources, including documentation, community-contributed plugins, and source code for learning and using Volatility.

	2. **The Volatility Framework: Volatile memory artifact extraction utility framework**  
	[Volatility Documentation](https://www.volatilityfoundation.org/26)  
	This is the official website of the Volatility Foundation, providing detailed documentation, case studies, and tutorials on how to use Volatility for memory forensics.

	3. **YARA: The pattern matching swiss knife for malware researchers**  
	[YARA Documentation](https://yara.readthedocs.io/en/stable/)  
	The official documentation for YARA, a tool aimed at helping malware researchers identify and classify malware samples, provides in-depth guidance on writing YARA rules and using YaraScan effectively.
	
	CheatSheets 
	* [https://downloads.volatilityfoundation.org/releases/2.4/CheatSheet_v2.4.pdf](https://downloads.volatilityfoundation.org/releases/2.4/CheatSheet_v2.4.pdf)

Please click the Next button to continue.



#<center><b>Lab 4 - Windows Memory Dump</b></center>

For this lab, use volatility to analyse the memory dump obtained from a Stuxnet infected Microsoft Windows computer. 

Stuxnet is a highly sophisticated computer worm discovered in 2010. It was designed to target specific industrial control systems, particularly Siemens' supervisory control and data acquisition (SCADA) systems, used in infrastructure like power plants. Notably, Stuxnet is believed to have been developed to disrupt Iran's nuclear program. What makes Stuxnet unique is its complexity and the fact that it exploits multiple zero-day vulnerabilities, making it one of the first instances of a cyberweapon actively used to cause physical, real-world damage.

In the context of Stuxnet detection, lsass can be examined for anomalies or signs of tampering, as Stuxnet and similar malware often interact with security processes. The Local Security Authority Subsystem Service (lsass) in Windows manages security policies and local security accounts.

[https://en.wikipedia.org/wiki/Stuxnet](https://en.wikipedia.org/wiki/Stuxnet)

- [] Identify the profile to use 

	```
	cd ~/memoryanalysis 
	volatility -f stuxnet.vmem imageinfo
	```

	![image14 profile.png](images/image14%20profile.png)

- [] Use the suggested profile of **WinXPSP2x86** for the analysis.

	```
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 pstree 
	```

	>[!Knowledge] The commands for Windows memory dump is different from Linux.

	What are the process IDs for the lsass.exe?

	```
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 pstree | grep -E "Name|lsass"
	```

- [] The malicious process in this memory dump is pid 680, 868, and 1928. Can you identify it with pslist? 

	```
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 pslist | more
	```

	When was the process started for pid 680?

	```
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 pslist | grep -E "Name|680"
	```

	@lab.Activity(Question13)

- [] Scan the memory with Yara 

	```
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 yarascan -y malware_rules.yar
	```

	To view just the rules and owner

	```
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 yarascan -y malware_rules.yar | grep Rule -A 1
	```

	@lab.Activity(Question14)

- [] Use the **malfind** plugin to identify hidden and injected code in those processes (pid 680, 868, and 1928).

	```
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 malfind -p 1928 
	```

	>[!Knowledge] Typically, memory sections shouldn't be executable and writable simultaneously.

	```
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 malfind -p 1928 | grep -i write -B 1 -A 1
	```

	You can scan for multiple pid at the same time. Seperate each pid with a comma.

	```
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 malfind -p 1928,868,680 | grep -i write -B 1 -A 1
	```

	@lab.Activity(Question15)

- [] Bonus, can you dump the process to a file. Then calculate the hash of the file and check the hash on Virustotal? 

	>[!Hint] Try using the command **procdump** with volatility.


	```
	mkdir stux_dump 
	volatility -f stuxnet.vmem --profile=WinXPSP2x86 procdump -D stux_dump -p 1928,868 
	```

	>[!Hint] If you don't pass a specific process id, it will try to dump everything. 

	>[!Warning] There will be an error about permissions, because the docker command mounts the file system as read only.

	Update the permissions for **/home/apnic/memoryanalysis/stux_dump** to allow anyone to write to the directory

	```
	sudo chmod 777 /home/apnic/memoryanalysis/stux_dump
	```

	Run the docker command, mount the folder as read/write enabled and run as a root user.

	```
	docker run --rm -v /home/apnic/memoryanalysis:/data:rw --user root blacktop/volatility -f stuxnet.vmem --profile=WinXPSP2x86 procdump -D stux_dump -p 1928,868 
	```

	Check that it is a binary file? (hint: Use file)

	```
	file stux_dump/*
	```	

	Calculate the hash values
	
    ```
    md5sum stux_dump/*
    ```

	In addition to md5sum, you can also use sha256sum. 

	```
	sha256sum stux_dump/*
	```

	>[!Hint] Use virustotal and check if the hash value is recognised as malicious file. [https://www.virustotal.com/](https://www.virustotal.com/gui/file/e97d61f7393ac5838a1800f3e9aa22c6205f4d7e2bde494573d35c57bc9b7819/detection)

	Try to dump files using malfind

	```
	rm stux_dump/*
	docker run --rm -v /home/apnic/memoryanalysis:/data:rw --user root blacktop/volatility -f stuxnet.vmem --profile=WinXPSP2x86 malfind -D stux_dump -p 1928,868 
	file stux_dump/*
	```		



For more detail refer to:

* [http://www.behindthefirewalls.com/2013/12/stuxnet-trojan-memory-forensics-with_16.html](http://www.behindthefirewalls.com/2013/12/stuxnet-trojan-memory-forensics-with_16.html)
* [https://medium.com/@neerajcysec/memory-analysis-of-stuxnet-with-volatility-57369ca29b1c](https://medium.com/@neerajcysec/memory-analysis-of-stuxnet-with-volatility-57369ca29b1c)
* [https://apps.dtic.mil/sti/pdfs/AD1003980.pdf](https://apps.dtic.mil/sti/pdfs/AD1003980.pdf)
* [http://www.malwarecookbook.com](http://www.malwarecookbook.com)
* [https://code.google.com/archive/p/malwarecookbook/](https://code.google.com/archive/p/malwarecookbook/)
* [http://mnin.blogspot.com/2011/06/examining-stuxnets-footprint-in-memory.html](http://mnin.blogspot.com/2011/06/examining-stuxnets-footprint-in-memory.html)
* [https://github.com/abhisek/reverse-engineering-and-malware-analysis/blob/master/gitbook/chapters/solutions/stuxnet_memory_image.md](https://github.com/abhisek/reverse-engineering-and-malware-analysis/blob/master/gitbook/chapters/solutions/stuxnet_memory_image.md)
* [https://www.computersecuritystudent.com/FORENSICS/VOLATILITY/VOLATILITY2_2/lesson2/](https://www.computersecuritystudent.com/FORENSICS/VOLATILITY/VOLATILITY2_2/lesson2/)

You have reached the end of this lab. 
