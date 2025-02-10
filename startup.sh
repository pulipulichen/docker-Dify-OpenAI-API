#!/bin/bash

full_path=$(realpath "$0")
base_dir=$(dirname "$full_path")
cd "$base_dir"

git clean -f -d
git fetch origin
git reset --hard origin/main

# ===========

cd "$base_dir"
cd ./dify/docker

docker-compose down
docker-compose up --build -d > /dev/null 2>&1 &

# ===========

sleep 5

echo $base_dir
cd "$base_dir"
# pwd
cd ./dify2openai/

./startup.sh
