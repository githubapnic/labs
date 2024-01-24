![](images/apnic_logo.png)
#<center><b>Install Akvorado</b></center>

###**Install Akvorado**

Akvorado is a software tool designed for collecting, enriching, and visualizing network flows. It functions by receiving network flows from routers using protocols like NetFlow v9, IPFIX, or sFlow. Once these flows are received, Akvorado enriches them with additional information such as GeoIP and interface names. These enriched flows are then exported to Apache Kafka, a distributed queue system, and subsequently stored in ClickHouse, a column-oriented database. Akvorado also features a web frontend that allows users to run queries and analyze the collected data.

For more detailed information, you can refer to the Akvorado GitHub repository [https://github.com/akvorado/akvorado](https://github.com/akvorado/akvorado) and Vincent Bernat's blog [https://vincent.bernat.ch/en/blog/2022-akvorado-flow-collector](https://vincent.bernat.ch/en/blog/2022-akvorado-flow-collector). 

In this step, we will install the required software to use Akvorado which is a tool to generate per-AS (Autnomous System) traffic graphs from NetFlow/sFlow records. 

The steps to complete this section are:
* Update software
* Install required software
* Installing Java and Zookeeper
* Setting up Kafka
* Installing ClickHouse: Used for storing network flow data.
* Installing Akvorado: Downloading and configuring Akvorado itself.
* Configure BGP on a Cisco device
* Configuring SNMP on Network Devices: Necessary for Akvorado to receive network flow data.
* Enable flows on router
* Generate traffic

- [] OPTIONAL - If not already connected to Group30 server, open a terminal window by pressing **ctrl+alt+t** and ssh to the server that will be used to install AS-Stats.

    ```
    ssh apnic@192.168.30.10
    ```

    NOTE: Type `yes` if asked about wanting to continue connecting

    Password = `training`

- [] Update the software repository for Ubuntu

    ```
    sudo apt-get update && sudo apt-get -y dist-upgrade
    ```

    Password = `training`

- [] Install required software

    ```
    sudo apt install -y wget nano git default-jre tmux screen
    ```

- [] Download and extract Kafka.

    ```
    wget https://www.apache.org/dyn/closer.cgi?path=/kafka/3.6.1/kafka_2.13-3.6.1.tgz
    ```

    NOTE: For the latest version refer to [https://kafka.apache.org/quickstart](https://kafka.apache.org/quickstart)

    ```
    tar -xzf kafka_2.13-3.6.1.tgz
    cd kafka_2.13-3.6.1
    ```

- [] Configure Kafka with ZooKeeper and create a topic to store the events.

    This requires to open 4 terminal windows and run 4 different commands. The easiest way to do this is to create a script that utilises tmux sessions.

    Create the script that will run the commands and open different terminal sessions

    ```
    cat << 'EOF' > ~/configure_kafka.sh
    #!/bin/bash

    # Change into the kafka folder
    cd ~/kafka_2.13-3.6.1
    
    # Start a new tmux session
    tmux new-session -d -s mySession

    # Window 0: Start the ZooKeeper service
    tmux send-keys -t mySession:0 'bin/zookeeper-server-start.sh config/zookeeper.properties' C-m

    # Window 1: Start the Kafka broker service
    tmux new-window -t mySession
    tmux send-keys -t mySession:1 'bin/kafka-server-start.sh config/server.properties' C-m

    # Window 2: Create Kafka topic
    tmux new-window -t mySession
    tmux send-keys -t mySession:2 'bin/kafka-topics.sh --create --topic quickstart-events --bootstrap-server localhost:9092' C-m

    # Window 3: Describe Kafka topic
    tmux new-window -t mySession
    tmux send-keys -t mySession:3 'bin/kafka-topics.sh --describe --topic quickstart-events --bootstrap-server localhost:9092' C-m

    # Attach to the tmux session
    # tmux attach-session -t mySession

    # Detach from the session
    tmux detach -s mySession

    # Background process to wait for 5 seconds and then end the session if last two commadns are completed
    (
    sleep 5

        # Check if the last two commands have completed
        if ! tmux capture-pane -p -t mySession:2 | grep -q '[^[:space:]]' && \
           ! tmux capture-pane -p -t mySession:3 | grep -q '[^[:space:]]'; then
            tmux kill-session -t mySession
        fi
    ) &
    
    EOF
    ```

    Run the script

    ```
    sudo bash ~/configure_kafka.sh
    ```

- [] Create a user to run the Kafka service

    ```
    sudo useradd -r -s /sbin/nologin kafka
    ```

- [] Move the Kafka folder to a different location that the home folder of the current user called apnic

    ```
    cd ~
    sudo mv kafka_*/ /usr/local/kafka
    sudo chown kafka:kafka -R /usr/local/kafka
    ```

- [] Create folders to store the data directory and log files

    ```
    sudo mkdir -p /usr/local/kafka/tmp/zookeeper
    sudo mkdir -p /usr/local/kafka/kafka-logs
    ```
    Change the owner of the kafka folder to the kafka user
  
    ```
    sudo chown kafka:kafka -R /usr/local/kafka
    ```

    ```
    sudo cpan install DBD::SQLite
    ```

- [] Update the dataDir variable in the zookeeper.properties file to the new folder location.

    ```
    sed -i 's/^dataDir=.*$/dataDir=\/usr\/local\/kafka\/tmp\/zookeeper/' /usr/local/kafka/config/zookeeper.properties
    ```

- [] Update the dataDir variable in the zookeeper.properties file to the new folder location.

    ```
    sudo sed -i 's|^log.dirs=.*$|log.dirs=/usr/local/kafka/kafka-logs|' /usr/local/kafka/config/server.properties
    ```
