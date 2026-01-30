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

# 5. 起動！ (コンパイルせず、Denoで直接ソースを叩く！)
# --allow-all (-A) で権限を全開放して確実に動かすぞ
# 引数の順番を Deno の仕様に合わせて調整した

echo "Starting Companion via Deno run..."
cd invidious-companion
deno run -A src/main.ts --config ../config.toml &

# サーバーが完全に立ち上がるまで少し長めに待機（15秒）
sleep 15
cd ..
echo "Companion is awake on port 8282! 🚀"
