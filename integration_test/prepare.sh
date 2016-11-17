#!/bin/sh

sh -c "cd .. && ./prepare.sh localhost"

rm -rf config
mkdir config
cp -a ../config/registry config/
sed "s/realm: http:\/\/[^\/]*/realm: http:\/\/proxy\.local/" config/registry/config.yml.template > config/registry/config.yml

