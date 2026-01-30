import subprocess
import time

def get_video_url(video_id, itag="22"):
    # 設定した 8282 ポートを狙い撃つ
    # local=true でプロキシURLを生成させるぞ
    # main.py の base_api を修正
# サーバーのログに合わせて /companion を足してみる
    base_api2 = f"http://localhost:8282/companion/latest_version?id={video_id}&itag={itag}&local=true"
    base_api = f"http://localhost:8282/latest_version?id={video_id}&itag={itag}&local=true"
    
    # Determined value: print each time
    print(f"Targeting Video: {video_id} (itag: {itag})")
    
    # 掟：html以外は絶対にcurlで実行する
    # -w %{url_effective} でリダイレクト後の最終URLだけをスマートに取得！
    cmd = [
        "curl", "-s", "-L", "-o", "/dev/null", "-w", "%{url_effective}",
        base_api
    ]
    cmd2 = [
        "curl", "-s", "-L", "-o", "/dev/null", "-w", "%{url_effective}",
        base_api2
    ]
    
    print(f"Executing: {' '.join(cmd)}")
    result = subprocess.run(cmd, capture_output=True, text=True)
    result2 = subprocess.run(cmd2, capture_output=True, text=True)
    
    final_url = result.stdout.strip()
    final_url2 = result2.stdout.strip()
    final_urls = final_url + "と" + final_url2
    print(f"final_url:{final_url}")
    
    return final_urls

if __name__ == "__main__":
    # テスト用の動画ID (例)
    test_id = "dQw4w9WgXcQ"
    url = get_video_url(test_id)
    if url:
        print(f"MISSION SUCCESS: {url}")
