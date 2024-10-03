# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy the server script
COPY https_server.py .

# Copy the certificate and key to the container
COPY certs/server.crt /etc/ssl/certs/server.crt
COPY certs/server.key /etc/ssl/private/server.key

# Create a large file with random content
RUN base64 /dev/urandom | head -c 35000000 > large_test_file.txt

# Declare a volume to persist data
VOLUME ["/usr/src/app"]

# Expose port 8400 for the HTTPS server
EXPOSE 80 8400

# Run the custom HTTPS server script
CMD ["python3", "https_server.py"]
