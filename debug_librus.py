import urllib.request
import urllib.parse

url_portal = "https://portal.librus.pl"
url_synergia = "https://synergia.librus.pl"
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

print("--- Step 1: GET iframe ---")
req1 = urllib.request.Request(f"{url_synergia}/loguj/portalRodzina", headers={
    'User-Agent': user_agent,
    'Referer': f"{url_portal}/rodzina/synergia/loguj"
})
try:
    res1 = urllib.request.urlopen(req1)
    body1 = res1.read().decode('utf-8')
    print(f"Iframe status: {res1.status}")
    print(f"Body length: {len(body1)}")
    if len(body1) < 100:
        print(f"Body: {body1}")
except Exception as e:
    print(f"Error GET: {e}")
