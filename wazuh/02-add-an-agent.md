![](images/apnic_logo.png)

## Lab 2 - Add an Agent ##

In this lab we will add the Wazuh agent on the Ubuntu server (FORT). The server will send alerts to the Wazuh Manager.

The steps to complete this section are:
* Log into the Wazuh Dashboard
* Run the add Agent Wizard
* Log into Client
* Install the Wazuh Agent
* Connect the Wazuh Agent to the Wazuh Manager

### Access the Wazuh Dashboard ###

1. Use Firefox and browse to the Wazuh HTTP server `https://192.168.30.97`

    ```
    https://192.168.30.97
    ```

2. Log into the dashboard using the following credentials:

    * User: `admin`<br>
    * Password: `Training1+`

3. Click on the `Add Agent` hyperlink on the main page, to open the wizard. Or use the following link:

    ```
    https://192.168.30.97/app/wazuh#/agents-preview/
    ```

4. Use the following information to complete the `Deploy new agent` form:

   Package to download: `DEB amd64` <br>
   Server address: `192.168.30.97` <br>
   Leave the `Optional settings` blank <br>
   Display the password

   ![](images/add_agent.png)

   **NOTE:** Copy the code to the clipboard

5. To install the required files open a terminal window and ssh to the server that will be used to install Wazuh Agent.

    ```
    ssh apnic@fort
    ```

    NOTE: Type `yes` if asked about wanting to continue connecting

    Password = `training`


6. Update the software repository.

    ```
    sudo apt-get update 
    ```

    Password = `training`

7. Download, install and connect the Wazuh Agent to the Wazuh Manager.

    ```
    wget https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.7.4-1_amd64.deb && sudo WAZUH_MANAGER="192.168.30.97" WAZUH_REGISTRATION_PASSWORD=$"please123" dpkg -i ./wazuh-agent_4.7.4-1_amd64.deb
    ```

    >[!Alert] Make sure to use the correct IP address of the Wazuh Manager.

    View the **authd.pass** file.

    ```
    sudo cat /var/ossec/etc/authd.pass
    ```


8. Enable and start wazuh agent service.

    ```
    sudo systemctl daemon-reload
    sudo systemctl enable wazuh-agent
    ```

9. Start wazuh agent service.

    ```
    sudo systemctl start wazuh-agent
    ```

10. Confirm the status of the agent service.

    ```
    sudo grep status /var/ossec/var/run/wazuh-agentd.state
    ```

    >[!Hint] **Note**: alternatively, you can use run `netstat -nat | grep ESTABLISHED`

11. Another way is to use the `Check agent` controls. Refer to the online help [https://documentation.wazuh.com/current/user-manual/reference/tools/agent-control.html](https://documentation.wazuh.com/current/user-manual/reference/tools/agent-control.html)

    ```
    sudo /var/ossec/bin/agent_control -l
    ```

12. Go to the Wazuh Dashboard, by returning to FireFox.

13. Refresh the web page that is open in the Firefox browser. It should show 1 Active Agent.

    UserName = `admin`

    Password = `Training1+`

14. Explore the Wazuh Dashboard.

    Go to Wazuh -> Agents (from the menu) you can see details of the agent

## Discussion ###
<ul>
<li>Research how Wazuh works, and describe the backend technology?
<li>Create a list of advantages and disadvantages for Agentless vs Agent?
<li>What other alternative software is there for Wazuh?    
</ul>

### Question 1
Research how Wazuh works, and describe the backend technology?

<details>
  <summary>Show Answer</summary>
  Wazuh is an open-source security monitoring and log management platform that leverages several backend technologies to provide comprehensive security solutions. It works by collecting, indexing, and analyzing security data from various sources, including operating systems, applications, and network devices.

  **Backend Technology:**
  - **Wazuh Manager**: The core of Wazuh, which processes data from the agents, analyzes logs, and generates alerts. It includes built-in rules for detecting threats and managing events.
  - **Wazuh Agent**: Deployed on monitored endpoints to collect security-related data, perform integrity checks, and send the information to the Wazuh Manager.
  - **Elastic Stack**: Consists of Elasticsearch, Logstash, and Kibana (ELK Stack). Wazuh uses Elasticsearch for storing and searching security data, Logstash for data processing and enrichment, and Kibana for visualizing data and creating dashboards.
  - **Filebeat**: Used to forward and centralize logs, making it easier to process and analyze log data.
  - **Integration with Cloud Services**: Wazuh can integrate with various cloud services like AWS, Azure, and Google Cloud for extended monitoring and compliance checks.

  This combination of technologies allows Wazuh to provide real-time security monitoring, threat detection, compliance management, and detailed reporting.
</details>

### Question 2
Create a list of advantages and disadvantages for Agentless vs Agent?

<details>
  <summary>Show Answer</summary>
  **Agent-based Monitoring:**

  **Advantages:**
  - **Real-time Monitoring**: Agents provide real-time data collection and monitoring.
  - **Comprehensive Data**: Agents can collect detailed system information, including logs, metrics, and security events.
  - **Offline Capability**: Agents can store data locally and send it when the connection is reestablished.

  **Disadvantages:**
  - **Resource Consumption**: Agents consume system resources, which might affect the performance of the host system.
  - **Deployment Complexity**: Requires installation and maintenance on each monitored endpoint.
  - **Scalability Issues**: Managing a large number of agents can be complex and resource-intensive.

  **Agentless Monitoring:**

  **Advantages:**
  - **Minimal Resource Usage**: Does not consume resources on the monitored systems, making it lightweight.
  - **Easy Deployment**: No need to install and maintain software on each endpoint.
  - **Scalability**: Easier to scale as it reduces the overhead of managing numerous agents.

  **Disadvantages:**
  - **Limited Data**: May not provide as detailed information as agent-based monitoring.
  - **Network Dependency**: Relies on network connectivity to gather data, which can be a limitation in case of network issues.
  - **Delayed Monitoring**: May not offer real-time monitoring capabilities as effectively as agent-based solutions.
</details>

### Question 3
What other alternative software is there for Wazuh?

<details>
  <summary>Show Answer</summary>
  There are several alternatives to Wazuh for security monitoring, log management, and SIEM (Security Information and Event Management) solutions:

  - **Splunk**: A popular platform for searching, monitoring, and analyzing machine-generated data via a web-style interface.
  - **Elastic Security**: Part of the Elastic Stack, it offers SIEM capabilities, endpoint security, and threat detection.
  - **Graylog**: An open-source log management tool that provides real-time search and analysis of log data.
  - **OSSEC**: The open-source HIDS (Host-based Intrusion Detection System) that Wazuh is based on, providing log analysis, integrity checking, and alerting.
  - **AlienVault OSSIM**: An open-source SIEM that combines event collection, normalization, and correlation.
  - **Sentry**: A performance monitoring and error tracking tool for applications.
  - **Nagios**: An open-source monitoring system for networks, systems, and infrastructure, providing alerting and reporting.

  Each of these alternatives has its own set of features, strengths, and use cases, making them suitable for different security and monitoring needs.
</details>


Continue to the next lab [Vulnerability Management](05-vulnerability-management.md)
