![](images/apnic_logo.png)

#<center><b>Lab 3 - Collector Configuration</b></center>

Credits to **Shane Alcock** and the **University of Waikato New Zealand**, for more detail refer to [https://www.openli.nz/tutorials/](https://www.openli.nz/tutorials/)


The Collector is a component of the OpenLI lawful interception system that performs the actual interception of communications to and from the intercept targets. It receives intercept instructions from the Provisioner, which describe how to recognize communications for the targets. The Collector must be fed potentially interceptable communications by the network operator, often via a mirrored copy of data at a router. The Collector then checks these communications, and if required, copies, encodes them into European Telecommunications Standards Institute​ (ETSI) record format, and passes them to the Mediator for delivery to law enforcement agencies. Multiple Collectors can be deployed in different physical locations for load balancing and supporting multiple separate collectors is a key feature of OpenLI architecture.

The steps to complete this section are:
* Access the collector's docker image.
* Update the variables in the configuration file.
* Configure logging location.
* Start the services.

###**Setup the collector to listen for connections**

We'll perform a step-by-step configuration on the collector to allow it to listen for connections.  

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- Start a new terminal session, by pressing **ctrl+alt+t**. To access the collector's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-collector /bin/bash
	```

- Review the collector's configuration file.

    ```
    cat /etc/openli/collector-config.yaml
	```

- Replace the provisioner's IP address for the variable called **PROVIP** 

    ```
    sed -i 's/<PROVIP>/172.18.0.2/g' /etc/openli/collector-config.yaml
	```

- Replace the variable called **COLLECTORPORT** with port 9001 (this will be to same port number the provisioner used)

    ```
    sed -i 's/<COLLECTORPORT>/9001/' /etc/openli/collector-config.yaml
	```

- Replace the  variable called **OPID** with the string APNICTraining

    ```
    sed -i 's/<OPID>/APNICTraining/' /etc/openli/collector-config.yaml
	```

	>[!Hint] The **OPID** (Operator ID), is a string that uniquely identifies your network to the agencies. It is a string with a maximum length of 16 characters.


>[!Warning] Notice the following **Network Element ID**, **Interception Point ID**, **uri**, **threads** and **hasher** already have values. For more detail refer to [files.openli.nz/tutorial/chapter009.pdf#page=11](files.openli.nz/tutorial/chapter009.pdf#page=11)

- View the changes to the collector's configuration file.

    ```
    cat /etc/openli/collector-config.yaml
	```

	
- Copy the provided rsyslog config to the **/etc/rsyslog.d/** folder

    ```
    cp /etc/openli/rsyslog.d/10-openli-collector.conf /etc/rsyslog.d/
	```	

	Stop the logging service
	```
	stop_rsyslog.sh
	```

	Start the rsyslog service
	```
	service rsyslog restart
	```

- Start the collector

    ```
    service openli-collector start
	```

	Check the status of the service

	```
	service openli-collector status
	```

- Review the collector's logs to confirm it has started correctly

    ```
    tail /var/log/openli/collector.log
	```

	Search for messages about mediator and provisioner

	```
    grep mediator /var/log/openli/collector.log
	```

- To exit the collector's command line interface, type the following

    ```
    exit
	```

- Check provisioner logs for a successful connection.

    ```
    docker exec -t openli-provisioner grep collector /var/log/openli/provisioner.log
	```

- Close provisioner's terminal window.	


>[!Hint] For more detail on configuring the collector watch the video at: [https://youtu.be/ltljYlTawT0](https://youtu.be/ltljYlTawT0)
