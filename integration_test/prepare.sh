#!/bin/sh

sh -c "cd .. && ./prepare.sh localhost"

echo ":80 {" > Caddyfile
sed '1d' ../config/Caddyfile.template >> Caddyfile

