#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
  read -p "What's your server host: (localhost) " host
else
  host=$1
fi

if [[ -z "${host// }" ]]; then
    host="localhost"
fi

sed "s/realm: http:\/\/[^\/]*/realm: http:\/\/$host/" config/registry/config.yml.template > config/registry/config.yml

command -v openssl >/dev/null 2>&1 || { echo >&2 "Require openssl but it's not installed.  Aborting."; exit 1; }

private_key_pem="config/private_key.pem"
root_crt="config/registry/root.crt"

rm $private_key_pem $root_crt >/dev/null 2>&1

openssl genrsa -out ${private_key_pem} 4096
openssl req -new -x509 -key ${private_key_pem} -out ${root_crt} -days 3650 -subj "/CN=${host}"

secret_key=$(openssl rand -base64 42)
echo "SECRET_KEY_BASE=${secret_key}" > .env
