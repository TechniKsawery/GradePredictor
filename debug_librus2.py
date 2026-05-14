import urllib.request
import urllib.parse
import http.cookiejar

url_portal = "https://portal.librus.pl"
url_synergia = "https://synergia.librus.pl"
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"

cj = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))

print("--- Step 1: GET portal ---")
req0 = urllib.request.Request(f"{url_portal}/rodzina/synergia/loguj", headers={'User-Agent': user_agent})
res0 = opener.open(req0)
print("Cookies after portal:")
for cookie in cj:
    print(f"{cookie.name}={cookie.value} (domain: {cookie.domain})")

print("\n--- Step 2: GET iframe ---")
req1 = urllib.request.Request(f"{url_synergia}/loguj/portalRodzina", headers={
    'User-Agent': user_agent,
    'Referer': f"{url_portal}/rodzina/synergia/loguj"
})
res1 = opener.open(req1)
print(f"Iframe status: {res1.status}")
print("Cookies after iframe:")
for cookie in cj:
    print(f"{cookie.name}={cookie.value} (domain: {cookie.domain})")
