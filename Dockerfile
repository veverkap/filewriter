FROM arm32v6/golang:1.16-alpine3.13
RUN apk add --no-cache ca-certificates
ADD "./bin/filewriter" "/"

COPY nsswitch.conf /etc/nsswitch.conf

STOPSIGNAL SIGINT
ENTRYPOINT ["/filewriter"]
