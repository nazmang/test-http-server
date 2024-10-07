import http.server
import ssl
import threading

# Define the directory you want to serve
SERVE_DIRECTORY = './www'

# Custom handler to serve from the specified directory
Handler = lambda *args, **kwargs: http.server.SimpleHTTPRequestHandler(*args, directory=SERVE_DIRECTORY, **kwargs)

# Function to run HTTPS server
def run_https_server():
    https_server = http.server.HTTPServer(('0.0.0.0', 8400), Handler)
    https_server.socket = ssl.wrap_socket(https_server.socket,
                                          certfile='/etc/ssl/certs/server.crt',
                                          keyfile='/etc/ssl/private/server.key',
                                          server_side=True)
    print(f"HTTPS Server running on port 8400, serving files from {SERVE_DIRECTORY}...")
    https_server.serve_forever()

# Function to run HTTP server
def run_http_server():
    http_server = http.server.HTTPServer(('0.0.0.0', 80), Handler)
    print(f"HTTP Server running on port 80, serving files from {SERVE_DIRECTORY}...")
    http_server.serve_forever()

# Start both servers
if __name__ == "__main__":
    # Run HTTPS server in a separate thread
    https_thread = threading.Thread(target=run_https_server)
    https_thread.start()

    # Run HTTP server on the main thread
    run_http_server()
