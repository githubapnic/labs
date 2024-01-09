![](images/apnic_logo.png)

#<center><b>Lab 5 - Configuring a VoIP Intercept</b></center>

In this VoIP Intercept Example Scenario, the following details will be used:
* The network name **example.com**
* Session Initiation Protocol (SIP) server IPv4 address and port number **10.100.50.65:5060**
* Received a VoIP intercept warrant for **User: 12345678910**

###**Adding the SIP Server**

We'll perform a step-by-step configuration for the environment to intercept VoIP information.  

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- Start a new terminal session, by pressing **ctrl+alt+t**. To access the provisioner's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-provisioner /bin/bash
	```

- Add the details about the **SIP server** by using curl to POST the server's JSON object.

	```
	curl -X POST -H "Content-Type: application/json" -d '{ "ipaddress": "10.100.50.65", "port": "5060" }' http://172.18.0.2:8080/sipserver 
	```

	>[!Hint] The following is the above command across multiple lines to make it easy to understand.

	```PowerShell-nocode
	curl -X POST -H "Content-Type: application/json" 
	-d '{ 
	"ipaddress": "10.100.50.65", 
	"port": "5060" 
	}' 
	http://172.18.0.2:8080/sipserver 
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
    docker exec -t openli-collector grep 5060 /var/log/openli/collector.log
	```

###**Adding the VoIP Intercept**

- Access the provisioner's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-provisioner /bin/bash
	```

- Add the details about the **VoIP Intercept** by using curl to POST the JSON object.

	```
	curl -X POST -H "Content-Type: application/json" -d '{ "liid": "TESTVOIP001", "authcc": "AU", "delivcc": "AU", "mediator": 1, "agencyid": "testagency", "starttime": 0, "endtime": 0, "siptargets": [ { "username": "12345678910" } ] }' http://172.18.0.2:8080/voipintercept
	```

	>[!Hint] The following is the above command across multiple lines to make it easy to understand.

	```PowerShell-nocode
	curl -X POST -H "Content-Type: application/json" 
	-d '{ 
	"liid": "TESTVOIP001", 
	"authcc": "AU", 
	"delivcc": "AU", 
	"mediator": 1, 
	"agencyid": "testagency", 
	"starttime": 0, 
	"endtime": 0, 
	"siptargets": [ 
	{ "username": "12345678910" } 
	] 
	}' 
	http://172.18.0.2:8080/voipintercept
	```

	>[!Hint] To retrieve the configured VoIP intercepts with GET, try this command `curl -X GET http://172.18.0.2:8080/voipintercept/TESTVOIP001`

- Review the provisioner's logs to confirm it has started correctly

    ```
    grep TESTVOIP001 /var/log/openli/provisioner.log
	```

- To exit the provisioner's command line interface, type the following

    ```
    exit
	```

- Check the collector logs for a successful connection.

    ```
    docker exec -t openli-collector grep TESTVOIP001 /var/log/openli/collector.log
	```

###**Testing the VoIP Intercept**

- Access the mediator's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-mediator /bin/bash
	```

- Confirm connectivity to the **Test Agent**.

	Confirm IP address of eth2
	
	```
	ip -br add list
	```

	Ping the Test Agent

	```
	ping -c 2 172.19.0.3
	```

- To exit the mediator's command line interface, type the following

    ```
    exit
	```

- View details about the replay bridged network

    ```
    docker network inspect openli-lab-replay | more
	```	

- Access the collector's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-collector /bin/bash
	```

- View the list of packet capture (PCAP) files stored on the collector.

	```
	ls -lash pcaps
	```

- Use tracereplay to replay the **tcpsip_voip.pcap** traffic on to interface **eth2**.

	```
	tracereplay pcaps/tcpsip_voip.pcap ring:eth2
	```

	>[!Alert] This will take some time to complete. While waiting review the open terminal sessions for HI2 and HI3.

- To exit the collector's command line interface, type the following

    ```
    exit
	```

- Close the terminal window.		

- Return to the Test Agency terminal that has the HI2 intercept. This will be the last display record, we will need to confirm the following information is part of the record:

* Timestamp and when it was captured.
* Lawful Intercept Identification (LIID).
* Authorization Country Code (AUTHCC).
* Delivery Country Code (DELIVCC).
* Operater ID.
* Network Element ID.
* Interception Point ID.
* Communication Identity Number (CIN).
* Sequence Number.

Also we will review the Intercept Related Information (IRI) Payload to confirm the following information was captured:

* Source IP Address.
* Destination IP address.

- Look at the first line to find the timestamp of when the intercept was captured. 

- To locate the LIID **TESTVOIP001** from the screen output, use the **less** command search function. Notice the double colon **:** at the bottom of the screen, similar to the **vi** command. This allows for a search command using the forward slash **/** and the string to search for.

    ```
    /TESTVOIP001
	```

	>[!Hint] The first occurance of the string will now be on the first line of the screen.

- To locate the AUTHCC and DELIVCC from the screen output, use the less command search function. 

    ```
    /AU
	```

	>[!Hint] Notice all occurrances of the string have been highlighted in the screen output.

- To locate the Operator ID from the screen output, use the less command search function. 

    ```
    /APNIC
	```

- To locate the Network Element ID from the screen output, use the less command search function. 

    ```
    /network
	```

- To locate the Interception Point ID from the screen output, use the less command search function. 

    ```
    /interception
	```

- To locate the Communication Identity Number (CIN) from the screen output, use the less command search function. 

    ```
    /communication
	```

- To locate the Sequence Number from the screen output, use the less command search function. 

    ```
    /sequence
	```

- To locate the  Source and Destination IP Address from the screen output, use the less command search function. 

	```
	/iPBinary
	```

- To continue scrolling the screen output use the space bar or press **q** to quit the less command.

- Return to the Test Agency terminal that has the HI3 intercept. This will be the last display record, we will need to confirm the following information is part of the record:

* Timestamp and when it was captured.
* Communication Identity Number (CIN).
* Sequence Number.

Also we will review the Content of Communication (CC) Payload to confirm the following information was captured:

* Direction.
* Packet Type.

>[!Hint] The captured Real-time Transport Protocol (RTP) content includes IP/UDP headers. However the RTP is binary encoded, so that won’t be able to be interpreted.

- Look at the first line to find the timestamp of when the intercept was captured. 

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

- To locate the Packet Type from the screen output, use the less command search function. 

    ```
    /frameType
	```

	>[!Knowledge] For more detail about the HI2 and HI3 screen outputs refer to [https://youtu.be/TuVQFCLEWGw](https://youtu.be/TuVQFCLEWGw)

- Before continuing to the next part of the lab. Reset the HI2 and HI3 listeners.

- Return to the Test Agency terminal that has the HI2 intercept. Press `q` to quit the less command.

- Run tracepktdump as the HI2 handover. HI2 is for receiving IRI records from the mediator

    ```
    tracepktdump etsilive:172.19.0.3:41002 | less
	```

- Return to the Test Agency terminal that has the HI3 intercept. Press `q` to quit the less command.

- Run tracepktdump as the HI3 handover. HI3 is for receiving CC records from the mediator

    ```
    tracepktdump etsilive:172.19.0.3:41003 | less
    ```
