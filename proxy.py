import socketserver
import http.server
import urllib.request

class Proxy(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        url = 'https://synergia.librus.pl' + self.path
        print(f"\n--- GET {url} ---")
        req = urllib.request.Request(url)
        for k, v in self.headers.items():
            if k.lower() not in ['host', 'accept-encoding']:
                req.add_header(k, v)
                print(f"Header: {k}: {v}")
        
        try:
            res = urllib.request.urlopen(req)
            self.send_response(res.status)
            for k, v in res.getheaders():
                self.send_header(k, v)
                print(f"Resp Header: {k}: {v}")
            self.end_headers()
            body = res.read()
            self.wfile.write(body)
            print(f"Body length: {len(body)}")
        except Exception as e:
            print(f"Error: {e}")
            if hasattr(e, 'code'):
                self.send_response(e.code)
                self.end_headers()

    def do_POST(self):
        url = 'https://synergia.librus.pl' + self.path
        print(f"\n--- POST {url} ---")
        length = int(self.headers.get('content-length', 0))
        body_in = self.rfile.read(length) if length > 0 else None
        
        req = urllib.request.Request(url, data=body_in)
        for k, v in self.headers.items():
            if k.lower() not in ['host', 'accept-encoding', 'content-length']:
                req.add_header(k, v)
                print(f"Header: {k}: {v}")
        
        try:
            res = urllib.request.urlopen(req)
            self.send_response(res.status)
            for k, v in res.getheaders():
                self.send_header(k, v)
            self.end_headers()
            body = res.read()
            self.wfile.write(body)
        except Exception as e:
            print(f"Error: {e}")

httpd = socketserver.ThreadingTCPServer(('', 8080), Proxy)
print("Proxy serving on port 8080")
httpd.serve_forever()
