FROM alpine:3.5

RUN apk add --no-cache tar wget ca-certificates
RUN wget "https://caddyserver.com/download/build?os=linux&arch=amd64&features=${plugins}" -O - | tar -C /usr/bin/ -xz caddy \
    && chmod 0755 /usr/bin/caddy \
    && /usr/bin/caddy -version

WORKDIR /srv
EXPOSE 80 443
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]

