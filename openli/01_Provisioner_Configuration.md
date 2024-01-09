![](images/apnic_logo.png)

#<center><b>Lab 1 - Provisioner Configuration</b></center>

Credits to **Shane Alcock** and the **University of Waikato New Zealand**, for more detail refer to [https://www.openli.nz/tutorials/](https://www.openli.nz/tutorials/)


The Provisioner is integral to the OpenLI system, serving as the hub for initiating and managing lawful interception processes, ensuring compliance with ETSI standards, and maintaining the security and integrity of the interception process. Some of the key functions and features are:

**Central Controller**: The Provisioner acts as the centralized controller for the entire OpenLI system. It is the primary interface through which network operators interact during normal operation of OpenLI.

**Intercept Management**: It manages and configures lawful intercepts. When a law enforcement agency issues a warrant for interception, the network operator uses the Provisioner to commence the intercept by updating the running configuration.

**Web UI**: The OpenLI team has developed a web-based graphical user interface (GUI) for the Provisioner. This UI is a ReactJS application that interfaces with the OpenLI Provisioner's REST API, allowing users to easily add, remove, or browse interceptions.

The steps to complete this section are:
* Access the provisioner's docker image.
* Confirm the container’s IP address.
* Update the variables in the configuration file.
* Configure logging location.
* Start the services.

###**Setup the provisioner to listen for client connections**

We'll perform a step-by-step configuration on the provisioner to allow it to listen for client connections.  

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- Start a new terminal session, by pressing **ctrl+alt+t**. Display the openli docker images that are downloaded.

	```
	docker images
	```

- Run the setup script.

	```
	cd openli-training-lab
    ./setup.sh
	```

- Confirm the openli docker images are running.

	```
	docker ps
	```

- Confirm the openli docker networks are running.

	```
	docker network ls | grep open
	```

- To access the provisioner's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-provisioner /bin/bash
	```

- Confirm the IPv4 address of the provisioner. 

    ```
    ip -br addr list eth1 | cut -d / -f 1
	```

	What is the IP address? 
    

- View the provisioner's configuration file.

    ```
    cat /etc/openli/provisioner-config.yaml
	```

- Replace the provisioner's IP address for the variable called **PROVIP**. 

    ```
    sed -i 's/<PROVIP>/172.18.0.2/g' /etc/openli/provisioner-config.yaml
	```

- Replace the variable called **COLLECTORPORT** with port 9001.

    ```
    sed -i 's/<COLLECTORPORT>/9001/' /etc/openli/provisioner-config.yaml
	```

- Replace the variable called **MEDIATORPORT** with port 9002.

    ```
    sed -i 's/<MEDIATORPORT>/9002/' /etc/openli/provisioner-config.yaml
	```

- Replace the  variable called **RESTAPIPORT** with port 8080.

    ```
    sed -i 's/<RESTAPIPORT>/8080/' /etc/openli/provisioner-config.yaml
	```

	>[!Hint] The 3 distinct ports for listening services for the **REST API**, **collectors** and **mediators**, can be any number above 1024.

- View the provisioner's configuration file, and confirm the variables have been updated correctly.

    ```
    cat /etc/openli/provisioner-config.yaml
	```	

- Copy the provided rsyslog config to the **/etc/rsyslog.d/** folder

    ```
    cp /etc/openli/rsyslog.d/10-openli-provisioner.conf /etc/rsyslog.d/
	```	

	Stop the logging service
	```
	stop_rsyslog.sh
	```

	Start the rsyslog service
	```
	service rsyslog restart
	```

- Start the provisioner

    ```
    service openli-provisioner start
	```

	Check the status of the service

	```
	service openli-provisioner status
	```

- Review the provisioner's logs to confirm it has started correctly

    ```
    tail /var/log/openli/provisioner.log
	```

- To exit the provisioner's command line interface, type the following

    ```
    exit
	```	

>[!Hint] For more detail on configuring the provisioner watch the video at: [https://youtu.be/ahFNtyw9s_c](https://youtu.be/ahFNtyw9s_c)
