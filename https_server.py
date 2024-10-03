import http.server
import ssl
import sys

# Define handler and directory to serve files from
Handler = http.server.SimpleHTTPRequestHandler
server_address = ('', 8400)

# Create an HTTP server instance
httpd = http.server.HTTPServer(server_address, Handler)

# Wrap the socket with SSL for HTTPS
httpd.socket = ssl.wrap_socket(httpd.socket,
                               keyfile='/etc/ssl/private/server.key',
                               certfile='/etc/ssl/certs/server.crt',
                               server_side=True)

print("Serving on port 8400 over HTTPS...")
httpd.serve_forever()
