FROM alpine:3.10
RUN apk add --no-cache coreutils gcc libc-dev make python3
WORKDIR /opt/test-runner
COPY bin/run.sh bin/
COPY bin/process_results.py bin/
ENTRYPOINT ["/opt/test-runner/bin/run.sh"]
