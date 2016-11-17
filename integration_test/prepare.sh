#!/bin/sh

sh -c "cd .. && ./prepare.sh localhost"

mkdir -p config/registry
sed "s/realm: http:\/\/[^\/]*/realm: http:\/\/proxy\.local/" ../config/registry/config.yml.template > config/registry/config.yml

