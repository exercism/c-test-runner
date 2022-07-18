FROM alpine:3.16.1
RUN apk add --no-cache coreutils gcc libc-dev make python3
WORKDIR /opt/test-runner
COPY . .
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
