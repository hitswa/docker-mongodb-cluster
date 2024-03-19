#!/bin/bash

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null
then
    echo "Docker Compose is not installed. Please install it first."
    exit 1
fi

# Check if Docker is running
if ! docker info &> /dev/null
then
    echo "Docker is not running. Please start Docker daemon."
    exit 1
fi

# Validate the Docker Compose file
if ! docker-compose -f docker-compose.yml config &> /dev/null
then
    echo "Docker Compose configuration is invalid. Please check docker-compose.yml."
    exit 1
fi

# Run Docker Compose to deploy the image
docker compose up -d

# Wait for containers to be created
echo "Waiting for containers to be created..."
while [[ $(docker ps --filter "status=running" --format "{{.Names}}" | wc -l) -lt 6 ]]; do
    sleep 5
done
echo "Containers are now available."


docker exec configsvr1 ln -s /usr/bin/mongosh /usr/bin/mongo
docker exec configsvr2 ln -s /usr/bin/mongosh /usr/bin/mongo
docker exec configsvr3 ln -s /usr/bin/mongosh /usr/bin/mongo
docker exec shard1rs1 ln -s /usr/bin/mongosh /usr/bin/mongo
docker exec shard1rs2 ln -s /usr/bin/mongosh /usr/bin/mongo
docker exec mongos ln -s /usr/bin/mongosh /usr/bin/mongo

# Execute MongoDB initialization commands
docker exec configsvr1 mongo --eval '
    rs.initiate(
        {
            _id: "configReplSet",
            configsvr: true,
            members: [
                { _id : 0, host : "configsvr1:27017" },
                { _id : 1, host : "configsvr2:27017" },
                { _id : 2, host : "configsvr3:27017" }
            ]
        }
    )
'

docker exec shard1rs1 mongo --eval '
    rs.initiate(
        {
            _id: "shard1rs",
            members: [
                { _id : 0, host : "shard1rs1:27017" },
                { _id : 1, host : "shard1rs2:27017" }
            ]
        }
    )
'
