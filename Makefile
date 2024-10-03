# Variables
IMAGE_NAME = test-http-server
CONTAINER_NAME = test_http_server
PORT = 8400
DOCKER_USERNAME = nazman
IMAGE_TAG = latest
REGISTRY_IMAGE = $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)

# Default task
all: certs docker-build run

# Step to create self-signed certificates
certs:
	chmod +x certs/mkcert.sh
	./certs/mkcert.sh

# Step to build the Docker image
docker-build:
	docker build -t $(IMAGE_NAME) .

# Step to tag the image for pushing to Docker Hub or other registry
docker-tag:
	docker tag $(IMAGE_NAME) $(REGISTRY_IMAGE)

# Step to push the image to the Docker registry
docker-push: docker-tag
	docker push $(REGISTRY_IMAGE)

# Step to run the container
run:
	docker run -d -p $(PORT):$(PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME)

# Stop the container
stop:
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true

# Clean up certificates and Docker container/image
clean: stop
	rm -f certs/server.crt certs/server.key certs/server.csr
	docker rmi $(IMAGE_NAME) || true
