import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  client.userAgent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
  
  print('Step 1: iframe');
  final req1 = await client.getUrl(Uri.parse('https://synergia.librus.pl/loguj/portalRodzina'));
  req1.headers.set('Referer', 'https://portal.librus.pl/');
  
  final res1 = await req1.close();
  print('Status: ${res1.statusCode}');
  
  final body1 = await res1.transform(utf8.decoder).join();
  print('Body length: ${body1.length}');
  
  final csrfMatch = RegExp(r'name="requestkey"\s*value="([^"]+)"').firstMatch(body1);
  final csrfToken = csrfMatch?.group(1) ?? '';
  print('CSRF Token: ${csrfToken.isNotEmpty ? "FOUND" : "MISSING"}');
  
  if (csrfToken.isEmpty) {
    print('Body excerpt:');
    print(body1.length > 500 ? body1.substring(0, 500) : body1);
  }
}
