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
git am ../patches/*.patch
cd ..


# 4. 設定ファイルの作成（invidious-companionの中に直接作る）
SECRET="GeminiProg123456"
# 確実に読み込ませるため、srcがある階層に置く
cat <<EOF > invidious-companion/src/config.toml
[server]
port = 8282
host = "127.0.0.1"
verify_requests = false
base_path = ""
secret_key = "$SECRET"

[jobs.gluetun_manager]
enabled = false

[jobs.youtube_session]
po_token_enabled = false
EOF

# 5. 起動！ディレクトリを移動してから、その場にあるconfigを指定
cd invidious-companion/src
export SERVER_SECRET_KEY="$SECRET"
deno run -A --no-lock main.ts --config config.toml &

# 5. 起動！ (環境変数でも SECRET_KEY を念押しで流し込む)
echo "Starting Companion Engine..."
cd invidious-companion

# 環境変数をセットして起動！
export SERVER_SECRET_KEY="$SECRET"
deno run -A --no-lock src/main.ts --config config.toml &

# 起動待ち (Actionsのスペックを考慮)
sleep 20
echo "Companion is awake on port 8282! 🚀"
