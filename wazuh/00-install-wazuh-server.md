![](images/apnic_logo.png)

  
## Installing the Wazuh Software ##

In this step, we will install the Wazuh software which has three central components: the Wazuh server, the Wazuh indexer, and the Wazuh dashboard. Wazuh is a security platform that provides unified XDR and SIEM protection for endpoints and cloud workloads. 

The steps to complete this section are:
* Log into the virtual lab
* SSH to the server
* Update software
* Install required software
* Install Wazuh software

Wazuh is free and open source, for more information refer to [https://documentation.wazuh.com/current/quickstart.html](https://documentation.wazuh.com/current/quickstart.html)

1. Log into the RPKI Lab (Sandbox) virtual lab on the APNIC Academy - [https://academy.apnic.net/virtual-labs?labId=146763](https://academy.apnic.net/virtual-labs?labId=146763)

2. To install the required files open a terminal window and ssh to the server that will be used to install Wazuh.

    ```
    ssh apnic@192.168.30.97
    ```

    NOTE: Type `yes` if asked about wanting to continue connecting

    Password = `training`


3. Update the software and install required software
    ```
    sudo apt-get update && sudo apt-get -y apt-transport-https
    ```

    Password = `training`

4. Download and run the Wazuh installation assistant.

    ```
    curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh && sudo bash ./wazuh-install.sh -a -i
    ```

    **NOTE:** Make sure to remember the displayed admin password. Or continue to the next to step to reset the password.

    ### Reset the Admin password ###

5. Navigate to Wazuh OpenSearch Security Tools Directory:

    ```
    cd /usr/share/wazuh-indexer/plugins/opensearch-security/tools
    ```

6. List Files in the Directory:

    ```
    ls -lash
    ```

7. Run Wazuh Password Tool to Set Admin Password:

    ```
    sudo bash ./wazuh-passwords-tool.sh -u admin -training
    ```
    Note: `training` will be the new password.

8. Restart Wazuh Dashboard Service.

    ```
    systemctl restart wazuh-dashboard
    ```

9. Restart Filebeat Service.

    ```
    systemctl restart filebeat
    ```

