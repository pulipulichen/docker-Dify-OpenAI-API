#!/bin/bash

full_path=$(realpath "$0")
base_dir=$(dirname "$full_path")
cd "$base_dir"

docker-compose down
docker-compose up --build -d > /dev/null 2>&1 &
