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


# 4. 設定ファイルの作成（複数箇所に配置して逃がさない！）
ls -l
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
EOF
ls -l
# 子ディレクトリにもコピー
cp config.toml invidious-companion/config.toml
cp config.toml invidious-companion/src/config.toml
ls -l

# 5. 起動！（ディレクトリを移動せず、ルートから実行してみる）
echo "Starting Companion Engine from Root..."
export SERVER_SECRET_KEY="$SECRET"
# --config でフルパスを指定！
deno run -A --no-lock invidious-companion/src/main.ts --config config.toml &

sleep 30 # 内部初期化（Innertubeの準備）をじっくり待つ
echo "Companion is awake! 🚀"

