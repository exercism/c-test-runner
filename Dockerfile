FROM alpine:3.10
RUN apk add --no-cache coreutils gcc libc-dev make python3
WORKDIR /opt/test-runner
COPY run.sh bin/
COPY process_results.py ./
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
