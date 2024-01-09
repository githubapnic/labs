![](images/apnic_logo.png)

<center><b>Lab 7 - Configuring a RADIUS IP Intercept</b></center>

RADIUS is a protocol used for managing network access, especially in ISP networks. This part of the lab emphasises the importance of RADIUS in lawful interception for identifying and tracking IP addresses assigned to targets. It guides through configuring OpenLI to recognize RADIUS traffic, setting up intercepts, and details on handling different user identification methods in RADIUS. It also explains generating intercept-related information (IRI) records based on RADIUS session changes.

In this RADIUS IP Intercept Example Scenario, the following details will be used:
* The RADIUS server IPv4 Address is **203.122.255.140**
* Access on UDP port **1645**
* Accounting on UDP port **1646**
* The **User-Name** field will be used for identity in RADIUS.
* Target is the user **b4CPidYn7u8Vesbo**
* The connection is using **ADSL**

###**Adding the Radius Server**

We'll perform a step-by-step configuration for the environment to intercept RADIUS IP information.  

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- Start a new terminal session, by pressing **ctrl+alt+t**. To access the provisioner's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-provisioner /bin/bash
	```

- Add the details about the **RADIUS server** access port **1645** by using curl to POST the server's JSON object.

	```
	curl -X POST -H "Content-Type: application/json" -d '{ "ipaddress": "203.122.255.140", "port": "1645" }' http://172.18.0.2:8080/radiusserver
	```

	>[!Hint] The following is the above command across multiple lines to make it easy to understand.

	```PowerShell-nocode
	curl -X POST -H "Content-Type: application/json"
	-d '{
	"ipaddress": "203.122.255.140",
	"port": "1645"
	}'
	http://172.18.0.2:8080/radiusserver
	```

- Add the details about the **RADIUS server** access port **1646** by using curl to POST the server's JSON object.

	```
	curl -X POST -H "Content-Type: application/json" -d '{ "ipaddress": "203.122.255.140", "port": "1646" }' http://172.18.0.2:8080/radiusserver
	```

	>[!Hint] The following is the above command across multiple lines to make it easy to understand.

	```PowerShell-nocode
	curl -X POST -H "Content-Type: application/json"
	-d '{
	"ipaddress": "203.122.255.140",
	"port": "1646"
	}'
	http://172.18.0.2:8080/radiusserver
	```

- Review the provisioner's logs to confirm it has started correctly

    ```
    tail /var/log/openli/provisioner.log
	```

- To exit the provisioner's command line interface, type the following

    ```
    exit
	```

- Check the collector logs for a successful connection.

    ```
    docker exec -t openli-collector grep 164 /var/log/openli/collector.log
	```

###**Adding the RADIUS IP Intercept**

- Access the provisioner's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-provisioner /bin/bash
	```

- Add the details about the **RADIUS IP Intercept** by using curl to POST the JSON object.

	```
	curl -X POST -H "Content-Type: application/json" -d '{ "liid": "RADIUS003", "authcc": "AU", "delivcc": "AU", "mediator": 1, "agencyid": "testagency", "starttime": 0, "endtime": 0, "user": "b4CPidYn7u8Vesbo", "accesstype": "adsl", "radiusident": "user" }' http://172.18.0.2:8080/ipintercept
	```

	>[!Hint] The following is the above command across multiple lines to make it easy to understand.

	```PowerShell-nocode
	curl -X POST -H "Content-Type: application/json"
	-d '{
	"liid": "RADIUS003",
	"authcc": "AU",
	"delivcc": "AU",
	"mediator": 1,
	"agencyid": "testagency",
	"starttime": 0,
	"endtime": 0,
	"user": "b4CPidYn7u8Vesbo",
	"accesstype": "adsl",
	"radiusident": "user"
	}'
	http://172.18.0.2:8080/ipintercept
	```

	>[!Hint] To retrieve the configured RADIUS IP intercepts with GET, try this command `curl -X GET http://172.18.0.2:8080/ipintercept/RADIUS003`

- Review the provisioner's logs to confirm it has started correctly

    ```
    grep RADIUS003 /var/log/openli/provisioner.log
	```

- To exit the provisioner's command line interface, type the following

    ```
    exit
	```

- Check the mediator logs for a successful connection.

    ```
    docker exec -t openli-mediator grep RADIUS003 /var/log/openli/mediator.log
	```

- Check the collector logs for a successful connection.

    ```
    docker exec -t openli-collector grep RADIUS003 /var/log/openli/collector.log
	```

###**Testing the RADIUS IP Intercept**

- Access the collector's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-collector /bin/bash
	```

- View the list of packet capture (PCAP) files stored on the collector.

	```
	ls -lash pcaps
	```

- Use tracereplay to replay the **radiuswithip.pcap** traffic on to interface **eth2**.

	```
	tracereplay -X 5 pcaps/radiuswithip.pcap ring:eth2
	```

	>[!Alert] This will take some time to complete. Using the -X flag will replay the pcap faster. While waiting review the open terminal sessions for HI2 and HI3.

- To exit the collector's command line interface, type the following

    ```
    exit
	```

- Close the terminal window.		

- Return to the Test Agency terminal that has the HI2 intercept. This will be the last display record, we will need to confirm the following information is part of the record:

* Lawful Intercept Identification (LIID).
* Communication Identity Number (CIN).

Review the Intercept Related Information (IRI) Payload to confirm the following information was captured:

* IRI Type for IRI Report
* Event Type.
* Username.
* Access Type.
* RADIUS Network Access Server (NAS) details
* Sequence Number.
* IRI Type for IRI Begin.
* Assigned IP address.
* Session Start Time.
* Usage Counters.
* Session End Time.
* Cause of session end.

- To locate the LIID **RADIUS003** from the screen output, use the less command search function.

    ```
    /RADIUS003
	```

- To locate the Communication Identity Number (CIN) from the screen output, use the less command search function. 

    ```
    /communication
	```

- To locate the IRI Type with the value of **IRI-Report** from the screen output, use the less command search function. 

    ```
    /IRI-Report
	```

- To locate the Event Type from the screen output, use the less command search function. 

    ```
    /accessAttempt
	```

- To locate the Username from the screen output, use the less command search function. 

    ```
    /targetUsername
	```

- To locate the Access Type from the screen output, use the less command search function. 

    ```
    /internetAccessType
	```

- To locate the RADIUS NAS details from the screen output, use the less command search function. 

    ```
    /pOP
	```

- To locate the IRI Type with the value of **IRI-Begin** from the screen output, use the less command search function. 

    ```
    /IRI-Begin
	```

- To locate the Assigned IP Address from the screen output, use the less command search function. 

	```
	/iPBinary
	```

- To locate the Session Start Time from the screen output, use the less command search function. 

	```
	/startTime
	```

- To locate the Session End Time from the screen output, use the less command search function. 

	```
	/endTime
	```

- To locate the Usage Counters from the screen output, use the less command search function. 

	```
	/octets
	```

- To locate the Cause of session end from the screen output, use the less command search function. 

	```
	/endReason
	```

	>[!Hint] There will be multiple Intercept Related Information (IRI) with all the above fields. The sequence number will increase per IRI.

- To continue scrolling the screen output use the space bar or press **q** to quit the less command.

- Return to the Test Agency terminal that has the HI3 intercept. This will be the last display record, we will need to confirm the following information is part of the record:

* Communication Identity Number (CIN) should change to match the concurrent IRIs
* Sequence Numbering will restart from zero.

Also we will review the Content of Communication (CC) Payload to confirm the following information was captured:

* Direction.
* Assigned IP address.

- To locate the Communication Identity Number (CIN) from the screen output, use the less command search function. 

    ```
    /communication
	```

- To locate the Sequence Number from the screen output, use the less command search function. 

    ```
    /sequence
	```

- To locate the Direction from the screen output, use the less command search function. 

    ```
    /Direction
	```

- To locate the Assigned IP Address from the screen output, use the less command search function. 

    ```
    /Destination
	```

	>[!Knowledge] For more detail about the HI2 and HI3 screen outputs refer to [https://youtu.be/TIT4Lv6ava8](https://youtu.be/TIT4Lv6ava8)

Refer to the [https://www.openli.nz/tutorials/](https://www.openli.nz/tutorials/) for other labs like:

* Integration with Vendor Mirroring
* Adding TLS to OpenLI
* Adding TLS to OpenLI Part 2
* REST API Authentication
* Combining RabbitMQ with OpenLI
