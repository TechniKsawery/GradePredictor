import urllib.request, http.cookiejar

url = "https://synergia.librus.pl/loguj/portalRodzina"

# Test 1: Chrome UA
req1 = urllib.request.Request(url, headers={
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Referer': 'https://portal.librus.pl/'
})
res1 = urllib.request.urlopen(req1)
print(f"Chrome UA body len: {len(res1.read())}")

# Test 2: Simple UA
req2 = urllib.request.Request(url, headers={
    'User-Agent': 'Mozilla/5.0',
    'Referer': 'https://portal.librus.pl/'
})
res2 = urllib.request.urlopen(req2)
print(f"Simple UA body len: {len(res2.read())}")
