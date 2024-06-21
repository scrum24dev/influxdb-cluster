#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 {shutdown|startup|update}"
    exit 1
}

# Function to perform the SSH action
do_action() {
    local action=$1

    # Define the operations
    declare -a arr=(
      "ap01;meta01"
      "ap02;meta02"
      "ap03;meta03"
      "db01;data01"
      "db02;data02"
    )
    for arr_item in "${arr[@]}"
    do
        IFS=';' read -r host influxdb_node <<< "${arr_item}"
        echo "host:${host}"
        echo "influxdb_node:${influxdb_node}"
        echo "action:${action}"               
        ssh -i ~/.ssh/itri.pem itri@${host} -l -c "$(eval echo $action)"
    done
}

# Run the build utility via Docker
set -e
# Make sure our working dir is the dir of the script
DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $DIR

# Check if an argument is provided
if [ -z "$1" ]; then
    usage
fi

source_host='ap03'
influxdb_master_dir='influxdb-cluster-master'

case "$1" in
    shutdown)
        echo "Shutting down the system..."
        do_action "cd ~/influxdb-cluster/;docker-compose down;"
	echo "sleep 10"
	sleep 10
        ;;
    startup)
        echo "Starting up the system..."
        do_action "cd ~/influxdb-cluster/;docker-compose up -d;"
	echo "sleep 10"
	sleep 10
        ;;
    update)
        echo "Updating code..."
        do_action "mkdir -p ~/influxdb-cluster; scp ${source_host}:~/${influxdb_master_dir}/docker-compose.yml.\${influxdb_node} ~/influxdb-cluster/;cd ~/influxdb-cluster/;rm ~/influxdb-cluster/docker-compose.yml;ln -s docker-compose.yml.\${influxdb_node} docker-compose.yml"
	echo "sleep 10"
	sleep 10
        ;;
    *)
        usage
        ;;
esac

exit 0

