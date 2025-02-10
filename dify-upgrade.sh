#!/bin/bash

cd $(dirname "$0")

# 定義檔案路徑
env_file="./dify/docker/.env"
env_example="./dify/docker/.env.example"

# 檢查 .env 是否存在
if [ ! -f "$env_file" ]; then
    if [ -f "$env_example" ]; then
        cp "$env_example" "$env_file"
        echo ".env 不存在，已成功從 .env.example 複製"
    else
        echo "錯誤：找不到 $env_example，無法複製"
        exit 1
    fi
else
    echo ".env 已存在，無需複製"
fi

# =================================================================

sed -i 's/^SANDBOX_WORKER_TIMEOUT=15$/SANDBOX_WORKER_TIMEOUT=1500/' ./dify/docker/.env
sed -i 's/^NGINX_CLIENT_MAX_BODY_SIZE=15M$/NGINX_CLIENT_MAX_BODY_SIZE=1500M/' ./dify/docker/.env
sed -i 's/^UPLOAD_FILE_SIZE_LIMIT=15$/UPLOAD_FILE_SIZE_LIMIT=1500/' ./dify/docker/.env

sed -i 's/^CODE_EXECUTION_CONNECT_TIMEOUT=10$/CODE_EXECUTION_CONNECT_TIMEOUT=100/' ./dify/docker/.env
sed -i 's/^CODE_EXECUTION_READ_TIMEOUT=60$/CODE_EXECUTION_READ_TIMEOUT=600/' ./dify/docker/.env
sed -i 's/^CODE_EXECUTION_WRITE_TIMEOUT=10$/CODE_EXECUTION_WRITE_TIMEOUT=100/' ./dify/docker/.env

sed -i 's/^TEXT_GENERATION_TIMEOUT_MS=60000$/TEXT_GENERATION_TIMEOUT_MS=600000/' ./dify/docker/.env

sed -i 's/^NGINX_KEEPALIVE_TIMEOUT=65$/NGINX_KEEPALIVE_TIMEOUT=650/' ./dify/docker/.env
sed -i 's/^FILES_ACCESS_TIMEOUT=300$/FILES_ACCESS_TIMEOUT=3000/' ./dify/docker/.env

sed -i 's/^API_TOOL_DEFAULT_CONNECT_TIMEOUT=10$/API_TOOL_DEFAULT_CONNECT_TIMEOUT=100/' ./dify/docker/.env
sed -i 's/^API_TOOL_DEFAULT_READ_TIMEOUT=60$/API_TOOL_DEFAULT_READ_TIMEOUT=600/' ./dify/docker/.env

sed -i 's/^EXPOSE_NGINX_PORT=80$/EXPOSE_NGINX_PORT=38080/' ./dify/docker/.env
sed -i 's/^EXPOSE_NGINX_SSL_PORT=443$/EXPOSE_NGINX_SSL_PORT=38443/' ./dify/docker/.env


# =================================================================

# 定義目標檔案
file="./dify/docker/docker-compose.yaml"

# # 檢查檔案是否存在
# if [ -f "$file" ]; then
#     # 使用 sed 進行替換，將相對路徑替換為絕對路徑
#     sed -i 's|- ./volumes/|- /mnt/dify/Dify/0.15.2/volumes/|g' "$file"
#     echo "替換完成：$file"
# else
#     echo "錯誤：找不到文件 $file"
# fi

# ==============

# Define the target file
GITIGNORE_FILE="./dify/.gitignore"

# Check if the file exists
if [ -f "$GITIGNORE_FILE" ]; then
    # Check if .env exists in the file
    if grep -q "^.env$" "$GITIGNORE_FILE"; then
        # Comment out the .env entry if it exists
        sed -i 's/^\.env$/# .env/' "$GITIGNORE_FILE"
        echo "Commented out '.env' in $GITIGNORE_FILE"
    else
        echo "'.env' is not found in $GITIGNORE_FILE"
    fi
else
    echo "Error: File $GITIGNORE_FILE does not exist."
    exit 1
fi