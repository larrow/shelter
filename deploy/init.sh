#!/bin/sh

docker pull larrow/shelter
docker run -it --rm -v `pwd`:/tmp larrow/shelter config localhost
