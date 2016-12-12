#!/bin/sh

if [ "$1" == "" ]
then
  host="localhost"
else
  host=$1
fi

docker pull larrow/shelter
docker pull larrow/shelter:worker
docker run -it --rm -v `pwd`:/tmp larrow/shelter config $host
