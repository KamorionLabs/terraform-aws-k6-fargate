# Stage 1: Build custom k6 binary with statsd extension
# renovate: datasource=docker depName=grafana/xk6
ARG XK6_VERSION=0.13.4
FROM grafana/xk6:${XK6_VERSION} AS builder

RUN xk6 build \
  --with github.com/LeonAdato/xk6-output-statsd \
  --output /tmp/k6

# Stage 2: Runtime image
# renovate: datasource=docker depName=alpine
ARG ALPINE_VERSION=3.21
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache aws-cli ca-certificates bash

COPY --from=builder /tmp/k6 /usr/local/bin/k6
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
