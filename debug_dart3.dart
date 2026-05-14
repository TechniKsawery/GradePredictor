import 'dart:io';
import 'dart:convert';

void main() async {
  final client = HttpClient();
  client.userAgent = 'Mozilla/5.0';

  final req2 = await client.getUrl(Uri.parse('https://synergia.librus.pl/loguj/portalRodzina'));
  req2.headers.set('Referer', 'https://portal.librus.pl/');
  
  final res2 = await req2.close();
  print('Status 2: ${res2.statusCode}');

  final body2 = await res2.transform(utf8.decoder).join();
  print('Body 2 len: ${body2.length}');
  if (body2.length < 100) print(body2);

  client.close();
}
