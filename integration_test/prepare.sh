#!/bin/sh

rm -rf config
mkdir -p config
cp -a ../config/registry config/
sed "s/realm: http:\/\/[^\/]*/realm: http:\/\/proxy\.local/" config/registry/config.yml.template > config/registry/config.yml
