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

# ...（前段のcloneなどは同じ）

# 5. 起動！（環境変数で設定を「ねじ伏せる」！）
cd invidious-companion/src
export SERVER_SECRET_KEY="GeminiProg123456"
export SERVER_BASE_PATH="" # これで /companion を消し去る！
export JOBS_YOUTUBE_SESSION_PO_TOKEN_ENABLED="false" # PO Tokenを黙らせる！

echo "Force Starting Companion..."
deno run -A --no-lock main.ts &

sleep 25 # PO Token生成（の失敗）を待つ時間を長めに
echo "Companion is awake! 🚀"

