#!/bin/bash

full_path=$(realpath "$0")
base_dir=$(dirname "$full_path")
cd "$base_dir"

touch .env

source default.env
source .env

# =================================================================

CLOUDFLARED_FILE="./cloudflared"
CLOUDFLARED_OUT="./.cloudflared.out"

setupCloudflare() {
  if [ ! -f "$CLOUDFLARED_FILE" ]; then
    wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O "${file}"
    chmod a+x "${CLOUDFLARED_FILE}"
  fi
}

runCloudflare() {
  port="$1"
  file_path="$2"

  #echo "p ${port} ${file_path}"

  rm -rf "${file_path}"
  #nohup /tmp/.cloudflared --url "http://127.0.0.1:${port}" > "${file_path}" 2>&1 &
  
  ${CLOUDFLARED_FILE} --url "http://127.0.0.1:${port}" > "${file_path}" 2>&1 &
}

getCloudflarePublicURL() {
  #stopCloudflare
  setupCloudflare

  port="$1"

    # File path
  

  runCloudflare "${port}" "${CLOUDFLARED_OUT}" &

  sleep 30

  # Retry logic
  max_retries=5  # Set max retries to avoid infinite loops
  retry_count=0

  while [[ $retry_count -lt $max_retries ]]; do
    # Extracting the URL using grep and awk
    url=$(grep -o 'https://[^ ]*\.trycloudflare\.com' "$CLOUDFLARED_OUT" | awk '/https:\/\/[^ ]*\.trycloudflare\.com/{print; exit}')

    if [[ -n "$url" ]]; then
      echo "$url"
      return 0
    fi

    # If URL is empty, wait 5 seconds and retry
    echo "URL not found, retrying in 5 seconds... (Attempt $((retry_count + 1))/$max_retries)"
    sleep 5
    ((retry_count++))
  done

  echo "Failed to retrieve Cloudflare URL after $max_retries attempts." >&2
  return 1
}

stopCloudflare() {
  if pgrep -f "./cloudflared" > /dev/null; then
    echo "Stopping cloudflared..."
    pkill -f "./cloudflared"
  else
      echo "cloudflared is not running."
  fi
}

getCloudflarePublicURL "${DIFY2OPENAI_EXPOSE_PORT}" > "./cloudflare.url"
