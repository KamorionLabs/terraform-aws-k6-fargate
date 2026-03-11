# Stage 1: Build custom k6 binary with statsd extension
FROM grafana/xk6:latest AS builder

RUN xk6 build \
  --with github.com/LeonAdato/xk6-output-statsd \
  --output /tmp/k6

# Stage 2: Runtime image
FROM alpine:3.19

RUN apk add --no-cache aws-cli ca-certificates bash

COPY --from=builder /tmp/k6 /usr/local/bin/k6
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
