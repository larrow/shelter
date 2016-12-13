#!/bin/sh

if [ "$1" == "" ]
then
  host="localhost"
else
  host=$1
fi

docker run --rm -v `pwd`:/tmp larrow/shelter config $host
docker-compose up -d
