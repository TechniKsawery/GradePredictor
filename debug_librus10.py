import urllib.request, http.cookiejar, urllib.parse

cj = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
headers = {'User-Agent': 'Mozilla/5.0'}

req1 = urllib.request.Request("https://synergia.librus.pl/loguj/portalRodzina", headers=headers)
res1 = opener.open(req1)
body1 = res1.read().decode('utf-8')
print(body1)
