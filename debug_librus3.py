import urllib.request
import re

url_portal = "https://portal.librus.pl"
url_synergia = "https://synergia.librus.pl"
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

class NoRedirectHandler(urllib.request.HTTPRedirectHandler):
    def redirect_request(self, req, fp, code, msg, headers, newurl):
        return None

opener = urllib.request.build_opener(NoRedirectHandler)
cookies = {}

def extract_cookies(header):
    if not header: return
    for match in re.finditer(r'([^=,\s]+)=([^;]+)', header):
        k, v = match.group(1).strip(), match.group(2).strip()
        lk = k.lower()
        if lk in ['expires', 'path', 'domain', 'samesite', 'secure', 'httponly', 'max-age']: continue
        if k and v and 'deleted' not in v:
            cookies[k] = v

def get_cookie_header():
    return "; ".join([f"{k}={v}" for k, v in cookies.items()])

def fetch(url, ref=None):
    cur_url = url
    for _ in range(7):
        req = urllib.request.Request(cur_url, headers={'User-Agent': user_agent})
        if ref: req.add_header('Referer', ref)
        ch = get_cookie_header()
        if ch: req.add_header('Cookie', ch)
        try:
            res = opener.open(req)
            extract_cookies(res.getheader('set-cookie'))
            return res.status, res.read().decode('utf-8')
        except urllib.error.HTTPError as e:
            res = e
            extract_cookies(res.getheader('set-cookie'))
            if res.code in [301, 302, 303]:
                loc = res.getheader('location')
                if not loc.startswith('http'):
                    loc = "https://" + urllib.request.urlparse(cur_url).netloc + loc
                cur_url = loc
                continue
            return res.code, res.read().decode('utf-8')
    return 0, ""

print("--- Step 1 ---")
status, body = fetch(f"{url_portal}/rodzina/synergia/loguj")
print(f"Status: {status}")
print(f"Cookies: {cookies}")

print("\n--- Step 2 ---")
status, body = fetch(f"{url_synergia}/loguj/portalRodzina", ref=f"{url_portal}/rodzina/synergia/loguj")
print(f"Status: {status}, Body len: {len(body)}")
if len(body) < 100: print(body)
