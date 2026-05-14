import urllib.request, http.cookiejar
cj = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))

print("Step 1: portal")
opener.open(urllib.request.Request("https://portal.librus.pl/rodzina/synergia/loguj", headers={'User-Agent': 'Mozilla/5.0'}))

print("\nStep 2: iframe")
req2 = urllib.request.Request("https://synergia.librus.pl/loguj/portalRodzina", headers={'User-Agent': 'Mozilla/5.0', 'Referer': 'https://portal.librus.pl/rodzina/synergia/loguj'})
res = opener.open(req2)
print(f"Iframe status: {res.status}")
print(f"Iframe body len: {len(res.read())}")

print("\nCookies sent:")
for c in cj:
    # CookieJar doesn't expose the exact string easily before request, 
    # but we can see if it was sent by subclassing.
    pass
