# HTTPS Server with Docker and Self-Signed Certificate

This project creates a simple HTTPS server using Python and Docker. It includes a self-signed certificate generated using OpenSSL and serves files over HTTPS from port 8400. It also contains a 35 MB "big file" filled with random data.

## Project Structure

- `certs/`: Contains the `mkcert.sh` script to generate self-signed certificates.
- `https_server.py`: A Python script that runs the HTTPS server using `http.server` and `ssl`.
- `Dockerfile`: Docker configuration to build the image.
- `Makefile`: Automates the build, run, and push process using Make.
- `README.md`: Instructions on how to use the project.

## Prerequisites

- Docker installed on your machine.
- Make installed on your machine.

## Steps to Run

1. **Generate SSL Certificates:**

   Run the following command to generate the SSL certificates using the `certs/mkcert.sh` script:

   ```bash
   make certs
   ```

    This will generate the `server.crt` and `server.key` files.

2. **Build the Docker Image:**

    Build the Docker image using the `Makefile`:

    ```bash
    make docker-build
    ```

    This builds the Docker image named test-https-server.

3. **Run the Docker Container:**

    Start the HTTPS server using the built Docker image:

    ```bash
    make run
    ```

    The server will start and listen on port 8400. You can access the server at <https://localhost:8400>.

    **Note:** Since a self-signed certificate is used, your browser will show a security warning. You can bypass this warning to proceed to the site.

4. **Stop the Docker Container:**

    To stop the running container:

    ```bash
    make stop
    ```

5. **Push the Docker Image to Docker Hub:**

    To push the Docker image to Docker Hub, you need to set the DOCKER_USERNAME in the Makefile. After that, push the image:

    ```bash
    make docker-push
    ```

    Ensure you are logged into Docker Hub before running this command:

    ```bash
    docker login
    ```

6. **Clean Up:**

    To clean up the generated certificates, stop the running container, and remove the Docker image:

    ```bash
    make clean
    ```

## Persistent Volume

The Docker container uses a volume at /usr/src/app. This volume ensures that the files inside the container (e.g., large files and certificates) persist, even if the container is stopped.

To mount a specific host directory as the volume, you can run:

```bash
docker run -d -p 8400:8400 -p 80:80 -v /path/to/host/directory:/usr/src/app/www --name test_https_server test-https-server
```

This will mount the host directory /path/to/host/directory to /usr/src/app/www inside the container.

## Speed test

To measure download speed from container, you can run:

```bash
curl -k https://localhost:8400/large_test_file.txt -w '\nResponse size:\t%{size_download} bytes\nDownload speed:\t%{speed_download} bps\nTotal Time:\t%{time_total} s\n' -o /dev/null
```

## Troubleshooting

- Certificate Warnings: Since a self-signed certificate is used, your browser or client may show a security warning. This is expected in a development environment.
- Permissions Issues: Ensure the `mkcert.sh` script is executable by running `chmod +x certs/mkcert.sh`.

### Summary of Changes

- **`Dockerfile`** now includes a `VOLUME` directive to persist the app's working directory.
- **`README.md`** provides detailed instructions for building, running, and pushing the image, along with usage of the volume and handling common issues.

This should cover the entire workflow from generating certificates to pushing the image to a Docker registry.
