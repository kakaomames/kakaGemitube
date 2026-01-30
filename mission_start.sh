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



# 4. 設定ファイルの作成
# po_token 関連を徹底的に false にし、検証もスキップさせる！
SECRET="GeminiProg123456"
cat <<EOF > config.toml
[server]
port = 8282
host = "0.0.0.0"
verify_requests = false
base_path = ""
secret_key = "$SECRET"

[jobs.youtube_session]
po_token_enabled = false
po_token_check = false

[jobs.gluetun_manager]
enabled = false
EOF

# 5. 起動！（環境変数でさらに「PO Tokenを使わない」と念押し！）
cd invidious-companion/src
export SERVER_SECRET_KEY="$SECRET"
export SERVER_BASE_PATH=""
export JOBS_YOUTUBE_SESSION_PO_TOKEN_ENABLED="false"
export JOBS_YOUTUBE_SESSION_PO_TOKEN_CHECK="false"

echo "Launching Engine in NO-PO-TOKEN mode..."
deno run -A --no-lock main.ts --config ../../config.toml &

# サーバーが完全に安定するまで待機
sleep 20
echo "Companion is awake! 🚀"
