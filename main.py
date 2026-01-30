import subprocess
import time

# Determined value: print each time
def mission_execute(target_url):
    print(f"Targeting: {target_url}")
    
    # -i でヘッダーを確認し、-L で追いかける
    # 最終的な有効URL（url_effective）だけを抜き出す
    cmd = [
        "curl", "-s", "-L", 
        "-o", "/dev/null", 
        "-w", "%{url_effective}", 
        target_url
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    final_url = result.stdout.strip()
    print(f"final_url:{final_url}")
    return final_url

if __name__ == "__main__":
    video_id = "dQw4w9WgXcQ" # ターゲットID
    
    # サーバーのログにある「正しいパス」を指定！
    # local=true を入れることで直リンクを生成させる
    api_path = f"http://localhost:8282/companion/latest_version?id={video_id}&itag=22&local=true"
    
    print("--- Mission Start ---")
    result_url = mission_execute(api_path)
    
    if "videoplayback" in result_url:
        print(f"🏆 MISSION ACCOMPLISHED! 🏆")
        print(f"Your direct link is: {result_url}")
    else:
        print("🚩 Target missed. Checking raw response...")
        # 失敗した場合は理由を探るためにヘッダーだけ表示
        raw_check = subprocess.run(["curl", "-I", "-s", api_path], capture_output=True, text=True)
        print(f"Raw Header:\n{raw_check.stdout}")

    print("--- Mission End ---")
