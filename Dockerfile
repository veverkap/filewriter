FROM docker.mirror.hashicorp.services/alpine:3.11
RUN apk add --no-cache ca-certificates
ADD "./bin/filewriter" "/"

COPY nsswitch.conf /etc/nsswitch.conf

STOPSIGNAL SIGINT
ENTRYPOINT ["/filewriter"]
