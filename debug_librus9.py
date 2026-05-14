import urllib.request, http.cookiejar, logging

# Enable debug logging for HTTP
import http.client
http.client.HTTPConnection.debuglevel = 1

logging.basicConfig(level=logging.DEBUG)

cj = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))

print("Step 2: iframe ONLY")
req2 = urllib.request.Request("https://synergia.librus.pl/loguj/portalRodzina", headers={'User-Agent': 'Mozilla/5.0', 'Referer': 'https://portal.librus.pl/'})
res = opener.open(req2)
print(f"Iframe status: {res.status}")
print(f"Iframe body len: {len(res.read())}")
