import urllib.request, http.cookiejar
cj = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))

print("Step 1: portal")
opener.open(urllib.request.Request("https://portal.librus.pl/rodzina/synergia/loguj", headers={'User-Agent': 'Mozilla/5.0'}))
for c in cj: print(f"Set: {c.name}")

print("\nStep 2: iframe")
req2 = urllib.request.Request("https://synergia.librus.pl/loguj/portalRodzina", headers={'User-Agent': 'Mozilla/5.0', 'Referer': 'https://portal.librus.pl/rodzina/synergia/loguj'})
opener.open(req2)
for c in cj: print(f"After iframe: {c.name}")

print("\nWhat headers were sent to iframe?")
print(req2.unredirected_hdrs)
