import urllib.request, http.cookiejar, urllib.parse

# Setup Session
cj = http.cookiejar.CookieJar()
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))
headers = {'User-Agent': 'Mozilla/5.0'}

print("Step 1: Get CSRF")
req1 = urllib.request.Request("https://synergia.librus.pl/loguj/portalRodzina", headers=headers)
res1 = opener.open(req1)
body1 = res1.read().decode('utf-8')

import re
csrf = re.search(r'name="requestkey"\s*value="([^"]+)"', body1).group(1)
print(f"CSRF: {csrf}")

print("Step 2: Login POST")
data = urllib.parse.urlencode({
    'login': '11357437u',
    'passwd': 'Techni_Gargamel2008',
    'requestkey': csrf
}).encode('utf-8')

req2 = urllib.request.Request("https://synergia.librus.pl/loguj/portalRodzina", data=data, headers={
    'User-Agent': 'Mozilla/5.0',
    'Referer': 'https://synergia.librus.pl/loguj/portalRodzina',
    'Content-Type': 'application/x-www-form-urlencoded'
})
res2 = opener.open(req2)
print(f"Login Status: {res2.status}")

print("Step 3: Get Grades")
req3 = urllib.request.Request("https://synergia.librus.pl/przegladaj_oceny/uczen", headers={
    'User-Agent': 'Mozilla/5.0',
    'Referer': 'https://synergia.librus.pl/uczen/index'
})
res3 = opener.open(req3)
body3 = res3.read().decode('utf-8')

print(f"Grades page len: {len(body3)}")
with open('grades_dump.html', 'w', encoding='utf-8') as f:
    f.write(body3)

# Quick check
rows = re.findall(r'<tr[^>]*>.*?</tr>', body3, re.DOTALL | re.IGNORECASE)
print(f"Found {len(rows)} table rows")
