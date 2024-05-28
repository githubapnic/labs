<span style="display:block;text-align:center">[apnic_logo.png](apnic_logo.png)</span>

  
###**Installing the Wazuh Software**

In this step, we will install the Wazuh software which has three central components: the Wazuh server, the Wazuh indexer, and the Wazuh dashboard. Wazuh is a security platform that provides unified XDR and SIEM protection for endpoints and cloud workloads. 

The steps to complete this section are:
* Log into the virtual lab
* SSH to the server
* Update software
* Install required software
* Install Wazuh software

Wazuh is free and open source, for more information refer to [https://documentation.wazuh.com/current/quickstart.html](https://documentation.wazuh.com/current/quickstart.html)

- Log into the RPKI Lab (Sandbox) virtual lab on the APNIC Academy - [https://academy.apnic.net/virtual-labs?labId=146763](https://academy.apnic.net/virtual-labs?labId=146763)

- To install the required files open a terminal window and ssh to the server that will be used to install Wazuh.

    ```
    ssh apnic@192.168.30.97
    ```

    NOTE: Type `yes` if asked about wanting to continue connecting

    Password = `training`


- Update the software and install required software
    ```
    sudo apt-get update && sudo apt-get -y apt-transport-https
    ```

    Password = `training`

- Download and run the Wazuh installation assistant.

    ```
    curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh && sudo bash ./wazuh-install.sh -a -i
    ```
