# Variables
IMAGE_NAME = test-http-server
CONTAINER_NAME = test_http_server
HTTP_PORT = 80
HTTPS_PORT = 8400
DOCKER_USERNAME = nazman
IMAGE_TAG = latest
REGISTRY_IMAGE = $(DOCKER_USERNAME)/$(IMAGE_NAME):$(IMAGE_TAG)

# Declare certs as a PHONY target to always run
.PHONY: certs help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

all: certs docker-build run ## Make everything and run the container.

certs: ## Create self-signed certificates.
	chmod +x certs/mkcert.sh
	./certs/mkcert.sh
	mv server.* ./certs/

docker-build: ## Build the Docker image.
	docker build -t $(IMAGE_NAME) .

docker-tag: ## Tag the image for pushing to Docker Hub or other registry.
	docker tag $(IMAGE_NAME) $(REGISTRY_IMAGE)

docker-push: docker-tag ## Push the image to the Docker registry.
	docker push $(REGISTRY_IMAGE)

run: ## Run the container.
	docker run -d -p $(HTTP_PORT):$(HTTP_PORT) -p $(HTTPS_PORT):$(HTTPS_PORT) --name $(CONTAINER_NAME) $(IMAGE_NAME)

stop: ## Stop the container.
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true


clean: stop ## Clean up certificates and Docker container/image.
	rm -f certs/server.crt certs/server.key certs/server.csr
	docker rmi $(IMAGE_NAME) || true
