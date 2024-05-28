![](images/apnic_logo.png)

## Lab 1 - Setup Wazuh Manager ##

The steps to complete this section are:
* Log into Wazuh server
* Setup Wazuh Manager to allow (agent) self registration

- To install the required files open a terminal window and ssh to the server that has the Wazuh Manager installed.

    ```
    ssh apnic@192.168.30.97
    ```

    Password = `training`


- View the Wazuh Manager configuration options.

    ```
    sudo less /var/ossec/etc/ossec.conf
    ```

    Password = `training`

    >[!Hint] Press `q` to return to the command prompt.

- Update the password to be used for agents to register with the Wazuh Manager.

    View the current setting

    ```
    sudo grep "<use_password>" -B7 -A8 /var/ossec/etc/ossec.conf
    ```
    
    Enable the password
    
    ```
    sudo sed -i 's/<use_password>no/<use_password>yes/' /var/ossec/etc/ossec.conf
    ```

    Create the password file
    
    ```
    echo "please123" | sudo tee /var/ossec/etc/authd.pass
    ```

- Restart the Wazuh Manger

    ```
    sudo systemctl restart wazuh-manager
    ```

- Confirm port 1514 and 1515 or listening.

    ```
    sudo lsof -Pi | grep LISTEN
    ```

  Continue to the next lab [Add An Agent](02-add-an-agent.md)
