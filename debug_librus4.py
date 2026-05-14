import urllib.request, http.cookiejar
url_portal = "https://portal.librus.pl"
url_synergia = "https://synergia.librus.pl"
user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
cj = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
req0 = urllib.request.Request(f"{url_portal}/rodzina/synergia/loguj", headers={'User-Agent': user_agent})
try:
    res0 = opener.open(req0)
    print("Cookies after portal:")
    for c in cj: print(f"{c.name}={c.value} ({c.domain})")
except Exception as e:
    print(e)
