![](images/apnic_logo.png)

<center><b>Lab 4 - Testing the Setup</b></center>

###**Setup the agent to receive intercepted information**

We'll perform a step-by-step configuration on the agent to allow it to receive the intercepted information.  

Login to the Lubuntu desktop and use the terminal for the following exercise. 

- Start a new terminal session, by pressing **ctrl+alt+t**. To access the agent's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-agency /bin/bash
	```

- Confirm the IPv4 address of the Test Agent. 

    ```
    ip -br addr list eth1 | cut -d / -f 1
	```

	What is the IP address? 
    

- Before starting the trace, rename the tab window title to **HI2**, to make it easier for later in the lab when you need to inspect the traffic for the HI2 capture. Press **Alt+Shift+S** or right mouse click on the tab and click on **Rename Session**.

![](https://github.com/githubapnic/labs/blob/main/openli/images/rename%20tab%20to%20HI2.gif)

- Run tracepktdump as the HI2 handover. HI2 is for receiving IRI records from the mediator

    ```
    tracepktdump etsilive:172.19.0.3:41002 | less
	```

	>[!Knowledge] This interface is designated for receiving Intercept Related Information (IRI) records from the mediator. IRI records typically include metadata about the communication sessions, such as session start and end times, parties involved, and communication type.

- Start a new terminal session, by pressing **ctrl+alt+t**.  To access the agent's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-agency /bin/bash
	```

- Before starting the trace, rename the tab window title to **HI3**, to make it easier for later in the lab when you need to inspect the traffic for the HI3 capture. Press Alt+Shift+S or right mouse click on the tab and click on Rename Session.	

- Run tracepktdump as the HI3 handover. HI3 is for receiving CC records from the mediator

    ```
    tracepktdump etsilive:172.19.0.3:41003 | less
	```

	>[!Knowledge] This interface is used for receiving Content of Communication (CC) records from the mediator. CC records contain the actual content of the intercepted communications, such as voice recordings, text messages, or data packets.

- Start a new terminal session, by pressing **ctrl+alt+t**. To access the provisioner's command line interface, type the following docker command: 

    ```
    docker exec -i -t openli-provisioner /bin/bash
	```

- Add the details about the **Test Agency** by using curl to POST the agency JSON object.

	```
	curl -X POST -H "Content-Type: application/json" -d '{ "agencyid": "testagency", "hi2address": "172.19.0.3", "hi3address": "172.19.0.3", "hi2port": "41002", "hi3port": "41003",  "keepalivefreq": 60, "keepalivewait": 30 }' http://172.18.0.2:8080/agency
	```

	>[!Hint] The following is the above command across multiple lines to make it easy to understand

	```PowerShell-nocode
	curl -X POST -H "Content-Type: application/json" 
	-d '{ 
	"agencyid": "testagency", 
	"hi2address": "172.19.0.3", 
	"hi3address": "172.19.0.3", 
	"hi2port": "41002", 
	"hi3port": "41003", 
	"keepalivefreq": 60, 
	"keepalivewait": 30 
	}' 
	http://172.18.0.2:8080/agency
	```

- Review the provisioner's logs to confirm it has started correctly

    ```
    grep testagency /var/log/openli/provisioner.log
	```

- To exit the provisioner's command line interface, type the following

    ```
    exit
	```

- Check mediator logs for a successful connection.

    ```
    docker exec -t openli-mediator grep testagency /var/log/openli/mediator.log
	```

- Close the terminal window.	

>[!Hint] For more detail on testing the openli setup as an Agency watch the video at: [https://youtu.be/eGw1MT3g6_k](https://youtu.be/eGw1MT3g6_k)
