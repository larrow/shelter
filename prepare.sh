#!/usr/bin/env bash

if [[ "$1" == "" ]]; then
  read -p "What's your server host: (localhost) " host
else
  host=$1
fi

if [[ -z "${host// }" ]]; then
    host="localhost"
fi

mkdir -p config

app_config=${APP_CONFIG:-'/usr/src/app/config'}

# copy config files
if [ -d 'config/nginx' ]
then
  echo 'has nginx conf, ignore'
else
  cp -r $app_config/nginx config/
fi

if [ -d 'config/registry' ]
then
  echo 'has registry conf, ignore'
else
  cp -r $app_config/registry config/
fi

# check for openssl
command -v openssl >/dev/null 2>&1 || { echo >&2 "Require openssl but it's not installed.  Aborting."; exit 1; }

# build key-pair for web and registry
private_key_pem="config/private_key.pem"
root_crt="config/registry/root.crt"

rm $private_key_pem $root_crt >/dev/null 2>&1

openssl genrsa -out ${private_key_pem} 4096
openssl req -new -x509 -key ${private_key_pem} -out ${root_crt} -days 3650 -subj "/CN=${host}"

# generate secret key and service token
secret_key=$(openssl rand -base64 42)
echo "SECRET_KEY_BASE=${secret_key}" > config/env_file

service_token=$(openssl rand -hex 42)
echo "SERVICE_TOKEN=${service_token}" >> config/env_file

# generate https files for nginx
cd config/nginx/cert

openssl req -subj "/C=CN/ST=Hangzhou/O=company/CN=$host" -newkey rsa:4097 -nodes -sha256 -keyout ca.key -x509 -days 365 -out ca.crt
openssl req -subj "/C=CN/ST=Hangzhou/O=company/CN=$host" -newkey rsa:4096 -nodes -sha256 -keyout server.key -out server.csr

mkdir demoCA
cd demoCA
touch index.txt
echo '01' > serial
cd ..

openssl ca -batch -in server.csr -out server.crt -cert ca.crt -keyfile ca.key -outdir .
rm -rf demoCA server.csr

cd ../../..
# make nginx.conf
sed -i '' "s/server_name .*;/server_name $host;/g" config/nginx/http.conf
sed -i '' "s/server_name .*;/server_name $host;/g" config/nginx/https.conf

# make registry config.yml
sed "s/realm: http:\/\/[^\/]*/realm: http:\/\/$host/" config/registry/config.yml.template \
  | sed "s/Bearer/Bearer ${service_token}/" > config/registry/config.yml


