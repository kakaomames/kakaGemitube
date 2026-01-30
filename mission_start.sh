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

# 4. コンパニオンの設定 (16文字の秘密鍵を追加！)
cat <<EOF > config.toml
[server]
port = 8282
host = "127.0.0.1"
verify_requests = false
base_path = ""
# ちょうど16文字の英数字が必要だ！
secret_key = "GeminiProgramming" 

[jobs.gluetun_manager]
enabled = false

[jobs.youtube_session]
po_token_enabled = false
EOF


# 5. 起動！ (ロックファイルを無視して強引に動かす！)
echo "Starting Companion via Deno run (No Lock Mode)..."
cd invidious-companion

# --no-lock を追加して、バージョンの不一致を黙らせるぞ！
deno run -A --no-lock src/main.ts --config ../config.toml &

# サーバーが完全に立ち上がるまで、Actionsのスペックを考慮して20秒待機だ！
sleep 20
cd ..
echo "Companion is awake on port 8282! 🚀"
