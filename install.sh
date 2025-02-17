#!/bin/sh

#  Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
# DRY_RUN=1 sh ./get-docker.sh

# Clone repo for ODK
if [[ ! -e odk-aggregate ]]; then
    mkdir odk-aggregate
fi
cd odk-aggregate
git clone -b release-4.4.0  https://github.com/samagra-comms/odk.git
cd ..
git clone -b release-4.7.0 https://github.com/samagra-comms/uci-apis.git
docker-compose up -d fa-search fusionauth fa-db
sleep 60s
docker-compose up -d cass kafka schema-registry zookeeper connect akhq
sleep 120s
docker-compose up -d aggregate-db wait_for_db aggregate-server
sleep 60s

docker-compose up -d