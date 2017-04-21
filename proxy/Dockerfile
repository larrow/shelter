FROM alpine:3.5

RUN apk add --no-cache tar wget ca-certificates
RUN wget "https://caddyserver.com/download/linux/amd64?plugins=${plugins}" -O - | tar -C /usr/bin/ -xz caddy \
    && chmod 0755 /usr/bin/caddy \
    && /usr/bin/caddy -version

WORKDIR /srv
EXPOSE 80 443
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["--conf", "/etc/Caddyfile", "--log", "stdout"]

