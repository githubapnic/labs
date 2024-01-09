![](images/apnic_logo.png)

#<center><b>Lab 2 - Mediator Configuration</b></center>

Credits to **Shane Alcock** and the **University of Waikato New Zealand**, for more detail refer to [https://www.openli.nz/tutorials/](https://www.openli.nz/tutorials/)


The Mediator plays a crucial role in the OpenLI lawful interception architecture. It acts as the exit point of the deployment, collecting encoded intercept records from the collectors and delivering them to the law enforcement agencies that requested them. The provisioner informs the mediator about which intercepts belong to which agency. The mediator ensures these records are sent to the correct agency via encrypted tunnels. Most deployments typically have one mediator, but more can be added if needed, for example, in cases of high intercept volumes or to distribute workload across multiple devices​

The steps to complete this section are:
* Access the mediator's docker image.
* Confirm the container’s IP address.
* Update the variables in the configuration file.
* Configure logging location.
* Start the services.

###**Setup the mediator to listen for connections**

We'll perform a step-by-step configuration on the mediator to allow it to listen for connections.  

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- Start a new terminal session, by pressing **ctrl+alt+t**. To access the mediator's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-mediator /bin/bash
	```

- Confirm the IPv4 address of the mediator. 

    ```
    ip -br addr list eth1 | cut -d / -f 1
	```

	What is the IP address?  

- Review the mediator's configuration file.

    ```
    cat /etc/openli/mediator-config.yaml
	```

- Replace the mediator's IP address for the variable called **MEDIP** 

    ```
    sed -i 's/<MEDIP>/172.18.0.3/g' /etc/openli/mediator-config.yaml
	```

- Replace the provisioner's IP address for the variable called **PROVIP** 

    ```
    sed -i 's/<PROVIP>/172.18.0.2/g' /etc/openli/mediator-config.yaml
	```

- Replace the variable called **MEDLISTENPORT** with port 12009

    ```
    sed -i 's/<MEDLISTENPORT>/12009/' /etc/openli/mediator-config.yaml
	```

	>[!Hint] The ports for listening services for the **MEDLISTENPORT**, can be any number above 1024.

- Replace the variable called **MEDIATORPORT** with port 9002 (this will be to same port number the provisioner used)

    ```
    sed -i 's/<MEDIATORPORT>/9002/' /etc/openli/mediator-config.yaml
	```

- Replace the  variable called **MEDIDNUM** with the number 1

    ```
    sed -i 's/<MEDIDNUM>/1/' /etc/openli/mediator-config.yaml
	```

	>[!Hint] The **MEDIDNUM** (Mediator ID), is a number between 0 and 1,000,000 that uniquely identifies this mediator in your deployment.

- Replace the  variable called **OPID** with the string APNICTraining

    ```
    sed -i 's/<OPID>/APNICTraining/' /etc/openli/mediator-config.yaml
	```

	>[!Hint] The **OPID** (Operator ID), is a string that uniquely identifies your network to the agencies. It is a string with a maximum length of 16 characters.

- View the changes to the mediator's configuration file.

    ```
    cat /etc/openli/mediator-config.yaml
	```

- Copy the provided rsyslog config to the **/etc/rsyslog.d/** folder

    ```
    cp /etc/openli/rsyslog.d/10-openli-mediator.conf /etc/rsyslog.d/
	```	

	Stop the logging service
	```
	stop_rsyslog.sh
	```

	Start the rsyslog service
	```
	service rsyslog restart
	```

- Start the mediator

    ```
    service openli-mediator start
	```

	Check the status of the service

	```
	service openli-mediator status
	```

- Review the mediator's logs to confirm it has started correctly

    ```
    tail /var/log/openli/mediator.log
	```

- To exit the mediator's command line interface, type the following

    ```
    exit
	```

- Check provisioner logs for a successful connection.

	Start a new terminal session, by pressing **ctrl+alt+t**. To access the provisioner's command line interface, type the following docker command: 

    ```
    docker exec -t openli-provisioner grep mediator /var/log/openli/provisioner.log
	```

- Close provisioner's terminal window.


>[!Hint] For more detail on configuring the mediator watch the video at: [https://youtu.be/C6JfVSfu6FA](https://youtu.be/C6JfVSfu6FA)
