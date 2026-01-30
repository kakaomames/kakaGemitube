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

# 4. コンパニオンの設定 (検証をオフにして扱いやすくする)
# config.example.toml を元に、必要な部分だけ書き換える
cat <<EOF > config.toml
[server]
port = 8282
host = "127.0.0.1"
verify_requests = false
base_path = ""

[jobs.gluetun_manager]
enabled = false

[jobs.youtube_session]
po_token_enabled = false
EOF

# 5. 起動！ (Deno環境が必要)
bash compile.sh
./invidious-companion --config config.toml &

echo "Companion is awake on port 8282! 🚀"
sleep 10 # 起動完了まで少し待機
