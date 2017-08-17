#!/bin/sh

if [ "$SHELTER_HOST" == "" ]
then
  host="localhost"
else
  host=$SHELTER_HOST
fi

docker run --rm -v `pwd`:/tmp larrow/shelter config $host
docker-compose up -d
