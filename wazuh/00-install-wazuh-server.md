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
    sudo apt-get update && sudo apt-get install -y apt-transport-https
    ```

    Password = `training`

4. Download and run the Wazuh installation assistant.

    ```
    curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh && sudo bash ./wazuh-install.sh -a -i
    ```

    **NOTE:** Make sure to remember the displayed admin password. Or continue to the next to step to reset the password.

    | Command  | Description |
    |--------------|-------------|
    | curl       | A command-line tool to transfer data from or to a server. |
    | -s        | makes the curl output silent. |
    | -O         | saves the file with the same name as in the URL. |
    | https://packages.wazuh.com/4.7/wazuh-install.sh | The URL from which the Wazuh installation script is downloaded. |
    | &&         | Logical AND operator to run the next command only if the previous one succeeds. |
    | sudo       | Executes the following command with superuser (root) privileges. |
    | bash       | The shell to interpret the script. |
    | ./wazuh-install.sh | The downloaded Wazuh installation script to be executed. |
    | -a         | Option to install all the components including the Wazuh manager, indexer and dashboard. |
    | -i         | Option to ignore hardware requirement checks. |


    ### Reset the Admin password ###

6. Switch to Superuser (root).

    ```
    sudo su
    ```

7. Navigate to Wazuh OpenSearch Security Tools Directory:

    ```
    cd /usr/share/wazuh-indexer/plugins/opensearch-security/tools
    ```

8. List Files in the Directory:

    ```
    ls -lash
    ```

9. Run Wazuh Password Tool to Set Admin Password:

    ```
    ./wazuh-passwords-tool.sh -u admin -p Training1+
    ```
    Note: `Training1+` will be the new password.

10. Switch to normal user (apnic).

    ```
    exit
    ```

11. Restart Wazuh Dashboard Service.

    ```
    sudo systemctl restart wazuh-dashboard
    ```

12. Restart Filebeat Service.

    ```
    sudo systemctl restart filebeat
    ```

    ### Access the Wazuh Dashboard ###

13. Use Firefox and browse to the Wazuh dashboard server `https://192.168.30.97`

    ```
    https://192.168.30.97
    ```

15. Log in using the following credentials:

    * User: `admin`<br>
    * Password: `Training1+`
   

Continue to the next lab [Setup Wazuh Manager](01-Setup-Wazuh-Manager.md)

