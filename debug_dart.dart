import 'dart:io';

void main() async {
  final client = HttpClient();
  client.userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';

  print('--- Step 1 ---');
  final req1 = await client.getUrl(Uri.parse('https://portal.librus.pl/rodzina/synergia/loguj'));
  final res1 = await req1.close();
  print('Status 1: ${res1.statusCode}');
  
  // Collect cookies automatically via dart:io's cookie jar? No, we have to handle them manually if we want to pass them across domains.
  // Actually, dart:io HttpClient manages cookies automatically IF they share the same domain.
  // portal.librus.pl and synergia.librus.pl are different domains, but cookies might be set for '.librus.pl'.
  
  List<Cookie> allCookies = [];
  allCookies.addAll(res1.cookies);
  print('Cookies 1: ${res1.cookies}');

  // drain body
  await res1.drain();

  print('\n--- Step 2 ---');
  final req2 = await client.getUrl(Uri.parse('https://synergia.librus.pl/loguj/portalRodzina'));
  req2.headers.set('Referer', 'https://portal.librus.pl/rodzina/synergia/loguj');
  
  // Add cookies
  for (var c in allCookies) {
    req2.cookies.add(c);
  }

  final res2 = await req2.close();
  print('Status 2: ${res2.statusCode}');
  allCookies.addAll(res2.cookies);
  print('Cookies 2: ${res2.cookies}');

  final body2 = await res2.transform(SystemEncoding().decoder).join();
  print('Body 2 len: ${body2.length}');
  if (body2.length < 100) print(body2);

  client.close();
}
