#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
  read -p "What's your server host: (localhost) " host
else
  host=$1
fi

if [[ -z "${host// }" ]]; then
    host="localhost"
fi

dst_config=`pwd`/config
mkdir -p $dst_config

# check if it run in container
if [ -d '/usr/src/app/config' ]
then
  src_config='/usr/src/app/config'
else
  # src and dst config is same folder when developing
  src_config=$dst_config
fi

if [ -d "$dst_config/registry" ]
then
  echo 'has registry config, ignore'
else
  cp -r $src_config/registry $dst_config/
fi

if [ -d "$dst_config/caddy" ]
then
  echo 'has caddy config, ignore'
else
  cp -r $src_config/caddy $dst_config/
  cp -a $src_config/Caddyfile $dst_config/
fi

# check for openssl
command -v openssl >/dev/null 2>&1 || { echo >&2 "Require openssl but it's not installed.  Aborting."; exit 1; }

# build key-pair for web and registry
private_key_pem="$dst_config/private_key.pem"
root_crt="$dst_config/registry/root.crt"

rm $private_key_pem $root_crt >/dev/null 2>&1

openssl genrsa -out ${private_key_pem} 4096
openssl req -new -x509 -key ${private_key_pem} -out ${root_crt} -days 3650 -subj "/CN=${host}"

# generate secret key and service token
secret_key=$(openssl rand -base64 42)
echo "SECRET_KEY_BASE=${secret_key}" > $dst_config/env_file

service_token=$(openssl rand -hex 42)
echo "SERVICE_TOKEN=${service_token}" >> $dst_config/env_file

# set caddy config file
echo "http://$host {" > $dst_config/Caddyfile
sed '1d' $src_config/Caddyfile.template >> $dst_config/Caddyfile

# make registry config.yml
sed "s/realm: http:\/\/[^\/]*/realm: http:\/\/$host/" $src_config/registry/config.yml.template \
  | sed "s/Bearer/Bearer ${service_token}/" > $dst_config/registry/config.yml


