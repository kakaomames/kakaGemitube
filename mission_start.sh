#!/bin/bash
# Gemini programming隊 最終錬成スクリプト

# 1. Gitの身分証明（パッチ適用に必須！）
git config --global user.email "kakaomame@gemini-programming.dev"
git config --global user.name "Kakaomame Agent"

# 2. 本陣の設営 (リポジトリ取得)
git clone --recursive https://git.nadeko.net/Fijxu/invidious-companion-patches.git
cd invidious-companion-patches

# 3. 秘伝のパッチ適用
cd ./invidious-companion
ls -l
git am ../patches/*.patch
ls -l
cd ..
ls -l



## ... (前段は同じ)

# 4. 設定ファイルの作成（全ディレクトリにバラ撒く！）
SECRET="GeminiProg123456"
cat <<EOF > config.toml
[server]
port = 8282
host = "127.0.0.1"
verify_requests = false
base_path = ""
secret_key = "$SECRET"

[jobs.youtube_session]
po_token_enabled = false
po_token_check = false

[jobs.gluetun_manager]
enabled = false
EOF

# 読み込みエラーを避けるため、考えられるすべての場所にコピーだ！
cp config.toml invidious-companion/config.toml
cp config.toml invidious-companion/src/config.toml
cp config.toml invidious-companion-patches/config.toml
cp config.toml invidious-companion/config/config.toml
cp config.toml invidious-companion-patches/config/config.toml

# 5. 起動！（--config 引数を使わず、環境変数でパスを直接教え込む！）
echo "Starting Companion with CONFIG_PATH..."
cd invidious-companion/src

# Deno版が参照する可能性のある環境変数もセット
export CONFIG_PATH="../../config.toml"
export SERVER_SECRET_KEY="$SECRET"
export SERVER_BASE_PATH=""

# 直接 main.ts を叩く！
# deno run -A --no-lock main.ts &

# sleep 25
# echo "Companion is awake! 🚀"

# ... (clone後のディレクトリ移動)
cd invidious-companion/src

# 1. ソースコードのデフォルト設定を強制書き換え（外科手術！）
# base_path を "/companion" から "" に
sed -i 's/base_path: "\/companion"/base_path: ""/g' lib/helpers/config.ts
# po_token_enabled を true から false に
sed -i 's/po_token_enabled: true/po_token_enabled: false/g' lib/helpers/config.ts

# 2. 環境変数でも念押し（バックアップ）
export SERVER_SECRET_KEY="GeminiProg123456"
export SERVER_BASE_PATH=""
export JOBS_YOUTUBE_SESSION_PO_TOKEN_ENABLED="false"

# 3. 起動！
echo "Surgery complete. Launching Engine..."
deno run -A --no-lock main.ts &

sleep 25
echo "Companion is awake! 🚀"
