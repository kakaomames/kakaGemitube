import subprocess
import time

def get_video_url(video_id, itag="22"):
    # 設定した 8282 ポートを狙い撃つ
    # local=true でプロキシURLを生成させるぞ
    base_api = f"http://localhost:8282/latest_version?id={video_id}&itag={itag}&local=true"
    
    # Determined value: print each time
    print(f"Targeting Video: {video_id} (itag: {itag})")
    
    # 掟：html以外は絶対にcurlで実行する
    # -w %{url_effective} でリダイレクト後の最終URLだけをスマートに取得！
    cmd = [
        "curl", "-s", "-L", "-o", "/dev/null", "-w", "%{url_effective}",
        base_api
    ]
    
    print(f"Executing: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    
    final_url = result.stdout.strip()
    print(f"final_url:{final_url}")
    
    return final_url

if __name__ == "__main__":
    # テスト用の動画ID (例)
    test_id = "dQw4w9WgXcQ"
    url = get_video_url(test_id)
    if url:
        print(f"MISSION SUCCESS: {url}")
