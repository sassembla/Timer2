import http.server
import socketserver
import logging

PORT = 8000

class RequestHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        logging.info(f"Received GET request from {self.client_address}")
        logging.info(f"Request path: {self.path}")
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(b"Hello, world!")

    def log_message(self, format, *args):
        logging.info(f"{self.client_address[0]} - - [{self.log_date_time_string()}] {format % args}")

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    handler = RequestHandler

    with socketserver.TCPServer(("", PORT), handler) as httpd:
        logging.info(f"Serving HTTP on port {PORT}")
        httpd.serve_forever()