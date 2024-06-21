#!/bin/bash
# Run the build utility via Docker
set -e
# Make sure our working dir is the dir of the script
DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $DIR

declare -a arr=(
  "ap01;meta01:meta-01"
  "ap02;meta02:meta-02"
  "ap03;meta03:meta-03"
  "db01;data01:data-01"
  "db02;data02:data-02"
)
source_host='ap03'
for arr_item in "${arr[@]}"
do
  IFS=';' read -r host influxdb_node influxdb_service <<< "${arr_item}"
  echo "host:${host}"
  echo "influxdb_node:${influxdb_node}"
  #echo "sleep 10 ..."
  #sleep 10

  ssh -i ~/.ssh/itri.pem itri@$host -l -c "cd ~/influxdb-cluster; docker-compose stop ${influxdb_service} "
  #echo "sleep 10 ..."
  #sleep 10

done


