![](images/apnic_logo.png)

<center><b>Lab 6 - Configuring a Static IP Intercept</b></center>

In this Static IP Intercept Example Scenario, the following details will be used:
* The intercept target is **Shane Alcock**
* The target has the username **salcock**
* It is a fiber optic connection
* Assigned a static IPv4 address of **10.1.18.217**

###**Adding the Static IP Intercept**

We'll perform a step-by-step configuration for the environment to intercept the Static IP information.  

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- [] Start a new terminal session, by pressing **ctrl+alt+t**. To access the provisioner's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-provisioner /bin/bash
	```

- [] Add the details about the **Static IP Intercept** by using curl to POST the JSON object.

	```
	curl -X POST -H "Content-Type: application/json" -d '{"liid": "STATIC002", "authcc": "AU", "delivcc": "AU", "mediator": 1, "agencyid": "testagency", "starttime": 0, "endtime": 0, "user": "salcock", "accesstype": "fiber", "staticips": [ { "iprange": "10.1.18.217", "sessionid": 101 } ] }' http://172.18.0.2:8080/ipintercept
	```

	>[!Hint] The following is the above command across multiple lines to make it easy to understand.

	```PowerShell-nocode
	curl -X POST -H "Content-Type: application/json"
	-d '{
	"liid": "STATIC002",
	"authcc": "AU",
	"delivcc": "AU",
	"mediator": 1,
	"agencyid": "testagency",
	"starttime": 0,
	"endtime": 0,
	"user": "salcock",
	"accesstype": "fiber",
	"staticips": [
	{ "iprange": "10.1.18.217", "sessionid": 101 }
	]
	}' http://172.18.0.2:8080/ipintercept
	```

	>[!Knowledge] You can specify a subnet instead of a single address and IPv6 is supported. For example:

	```PowerShell-nocode
	curl -X POST -H "Content-Type: application/json"
	-d '{
	"liid": "STATIC002",
	"authcc": "AU",
	"delivcc": "AU",
	"mediator": 1,
	"agencyid": "testagency",
	"starttime": 0,
	"endtime": 0,
	"user": "salcock",
	"accesstype": "fiber",
	"staticips": [
	{ "iprange": "10.1.18.208/28", "sessionid": 101 },
	{ "iprange": "2001:db8:abcd:0012::/64", "sessionid": 888 }
	]
	}' http://172.18.0.2:8080/ipintercept
	```

- [] Review the provisioner's logs to confirm it has started correctly

    ```
    grep STATIC002 /var/log/openli/provisioner.log
	```

- [] To exit the provisioner's command line interface, type the following

    ```
    exit
	```

- [] Check the mediator logs for a successful connection.

    ```
    docker exec -t openli-mediator grep STATIC002 /var/log/openli/mediator.log
	```

- [] Check the collector logs for a successful connection.

    ```
    docker exec -t openli-collector grep STATIC002 /var/log/openli/collector.log
	```

###**Testing the Static IP Intercept**

- [] Access the collector's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-collector /bin/bash
	```

- [] View the list of packet capture (PCAP) files stored on the collector.

	```
	ls -lash pcaps
	```

- [] Use tracereplay to replay the **staticip.pcap** traffic on to interface **eth2**.

	```
	tracereplay pcaps/staticip.pcap ring:eth2
	```

	>[!Alert] This will take some time to complete. While waiting review the open terminal sessions for HI2 and HI3.

- [] To exit the collector's command line interface, type the following

    ```
    exit
	```

- [] Close the terminal window.

- [] Return to the Test Agency terminal that has the HI3 intercept. This will be the last display record, we will need to confirm the following information is part of the record:

* Lawful Intercept Identification (LIID).
* Communication Identity Number (CIN).
* Sequence Number.

Also we will review the Content of Communication (CC) Payload to confirm the following information was captured:

* Direction.
* The Target IP address.

- [] To locate the LIID **STATIC002** from the screen output, use the **less** command search function.

    ```
    /STATIC002
	```

- [] To locate the Communication Identity Number (CIN) from the screen output, use the less command search function. 

    ```
    /communication
	```

- [] To locate the Direction from the screen output, use the less command search function. 

    ```
    /Direction
	```

- [] To locate the Target IP from the screen output, use the less command search function. 

    ```
    /10.1.18.217
	```

- [] Return to the Test Agency terminal that has the HI2 intercept. HI2 records are sparse for a static IP intercept and the session is continuous, so no state changes to report. We will review the Intercept Related Information (IRI) Payload to confirm the following information was captured:

* Event Type.
* Username.
* Access Type.
* IP Address.
* Subnet mask.
* Whether it is a a Static or dynamic assignment.

- [] To locate the Event Type from the screen output, use the less command search function. 

    ```
    /accessEventType
	```

- [] To locate the Username from the screen output, use the less command search function. 

    ```
    /targetUsername
	```

- [] To locate the Access Type from the screen output, use the less command search function. 

    ```
    /internetAccessType
	```

- [] To locate the IP Address from the screen output, use the less command search function. 

    ```
    /iPBinaryAddress
	```

- [] To locate the Subnet mask from the screen output, use the less command search function. 

    ```
    /iPv4SubnetMask
	```

- [] To locate the Assignment type from the screen output, use the less command search function. 

    ```
    /iP-assignment
	```

	>[!Knowledge] For more detail about the HI2 and HI3 screen outputs refer to [https://youtu.be/uX5cK-pZe68](https://youtu.be/uX5cK-pZe68)

- [] Remove the Static IP intercept, so it doesn't cause confusion (extra screen output) for the next part of the lab.

	```
	curl -X DELETE http://172.18.0.2:8080/ipintercept/STATIC002
	```

- [] Before continuing to the next part of the lab. Reset the HI2 and HI3 listeners.

- [] Return to the Test Agency terminal that has the HI2 intercept. Press `q` to quit the less command.

- [] Run tracepktdump as the HI2 handover. HI2 is for receiving IRI records from the mediator

    ```
    tracepktdump etsilive:172.19.0.3:41002 | less
	```

- [] Return to the Test Agency terminal that has the HI3 intercept. Press `q` to quit the less command.

- [] Run tracepktdump as the HI3 handover. HI3 is for receiving CC records from the mediator

    ```
    tracepktdump etsilive:172.19.0.3:41003 | less
    ```
