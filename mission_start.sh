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

# 【最重要】設定のデフォルト値を定義しているファイルを直接書き換える
# ターゲットファイル: lib/helpers/config.ts (または lib/config.ts 等、設定を保持しているファイル)

# 1. base_path を "/companion" から空にする
sed -i 's/base_path: "\/companion"/base_path: ""/g' lib/helpers/config.ts 2>/dev/null || sed -i 's/base_path: "\/companion"/base_path: ""/g' src/lib/helpers/config.ts

# 2. po_token を強制無効化
sed -i 's/po_token_enabled: true/po_token_enabled: false/g' lib/helpers/config.ts 2>/dev/null || sed -i 's/po_token_enabled: true/po_token_enabled: false/g' src/lib/helpers/config.ts

# 3. リクエスト検証を強制無効化
sed -i 's/verify_requests: true/verify_requests: false/g' lib/helpers/config.ts 2>/dev/null || sed -i 's/verify_requests: true/verify_requests: false/g' src/lib/helpers/config.ts

# 4. Gluetunを強制無効化
sed -i 's/enabled: true/enabled: false/g' lib/jobs/gluetun.ts 2>/dev/null

echo "Surgery complete. Forcing configuration in source code. 🚀"

# 起動！
deno run -A --no-lock main.ts &
sleep 30
