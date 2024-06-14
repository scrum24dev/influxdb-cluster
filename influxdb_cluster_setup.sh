#!/bin/bash
# Run the build utility via Docker
set -e
# Make sure our working dir is the dir of the script
DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
cd $DIR

declare -a arr=(
  "ap01;meta01"
  "ap02;meta02"
  "ap03;meta03"
  "db01;data01"
  "db02;data02"
)
source_host='ap03'
for arr_item in "${arr[@]}"
do
  IFS=';' read -r host influxdb_node <<< "${arr_item}"
  echo "host:${host}"
  echo "influxdb_node:${influxdb_node}"
  #echo "sleep 10 ..."
  #sleep 10

  ssh -i ~/.ssh/itri.pem itri@$host -l -c "mkdir -p ~/influxdb-cluster; scp ${source_host}:~/influxdb-cluster/docker-compose.yml.${influxdb_node} ~/influxdb-cluster/;cd ~/influxdb-cluster/;rm ~/influxdb-cluster/docker-compose.yml;ln -s docker-compose.yml.${influxdb_node} docker-compose.yml"
  #echo "sleep 10 ..."
  #sleep 10

done


