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

# ... (git clone 後の cd invidious-companion/src にて)

# 【最優先】Gluetun(IP回転)をソースコードレベルで抹殺する！
sed -i 's/enabled: true/enabled: false/g' lib/helpers/config.ts

# 他の設定も念押しで書き換え
sed -i 's/base_path: "\/companion"/base_path: ""/g' lib/helpers/config.ts
sed -i 's/po_token_enabled: true/po_token_enabled: false/g' lib/helpers/config.ts

# 環境変数でも「これでもか！」と叩き込む
export SERVER_SECRET_KEY="GeminiProg123456"
export SERVER_BASE_PATH=""
export JOBS_GLUETUN_MANAGER_ENABLED="false"
export JOBS_YOUTUBE_SESSION_PO_TOKEN_ENABLED="false"

echo "Surgery complete. Gluetun and PO-Token disabled. 🚀"
deno run -A --no-lock main.ts &

sleep 30

sleep 25
echo "Companion is awake! 🚀"
