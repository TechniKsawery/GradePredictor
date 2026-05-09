import http.server
import socketserver

class Handler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers['Content-Length'])
        post_data = self.rfile.read(length)
        with open('librus_dump.html', 'wb') as f:
            f.write(post_data)
        self.send_response(200)
        self.end_headers()
        print("HTML DUMP RECEIVED AND SAVED!")

with socketserver.TCPServer(("", 8080), Handler) as httpd:
    print("Serving on port 8080. Waiting for dump...")
    httpd.handle_request() # Handles exactly ONE request and stops
