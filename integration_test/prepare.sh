#!/bin/sh

sh -c "cd .. && ./prepare.sh localhost"

echo ":80 {" > config/Caddyfile
sed '1d' ../config/Caddyfile.template >> config/Caddyfile

