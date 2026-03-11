#!/bin/bash
set -euo pipefail

# Download k6 scripts from S3
if [ -n "${K6_SCRIPTS_BUCKET:-}" ]; then
  echo "Downloading k6 scripts from s3://${K6_SCRIPTS_BUCKET}/${K6_SCRIPTS_PREFIX:-scripts/}..."
  aws s3 cp "s3://${K6_SCRIPTS_BUCKET}/${K6_SCRIPTS_PREFIX:-scripts/}" /scripts/ --recursive
fi

# Set default script if not specified
K6_SCRIPT="${K6_SCRIPT:-/scripts/test.js}"

echo "Running k6 test: ${K6_SCRIPT}"

# Use extra args if provided, otherwise run with default output
if [ $# -gt 0 ]; then
  k6 "$@"
else
  k6 run -o output-statsd "${K6_SCRIPT}"
fi

# Allow CW Agent time to flush remaining metrics
echo "Waiting for metrics flush..."
sleep 3
