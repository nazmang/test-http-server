import http.server
import ssl
import threading

# Define handler for HTTP and HTTPS
Handler = http.server.SimpleHTTPRequestHandler

# Function to run HTTPS server
def run_https_server():
    https_server = http.server.HTTPServer(('0.0.0.0', 8400), Handler)
    https_server.socket = ssl.wrap_socket(https_server.socket,
                                          certfile='/etc/ssl/certs/server.crt',
                                          keyfile='/etc/ssl/private/server.key',
                                          server_side=True)
    print("HTTPS Server running on port 8400...")
    https_server.serve_forever()

# Function to run HTTP server
def run_http_server():
    http_server = http.server.HTTPServer(('0.0.0.0', 80), Handler)
    print("HTTP Server running on port 80...")
    http_server.serve_forever()

# Start both servers
if __name__ == "__main__":
    # Run HTTPS server in a separate thread
    https_thread = threading.Thread(target=run_https_server)
    https_thread.start()

    # Run HTTP server on the main thread
    run_http_server()
