IMAGE_NAME := webapi
VERSION := $(shell docker images -q $(IMAGE_NAME) | head -n1)
CURRENT_TAG := $(shell docker images --format "{{.Tag}}" $(IMAGE_NAME) | head -n1)
NEW_TAG := $(shell expr $(CURRENT_TAG) + 1)

build:
	dotnet publish -c Release -o ./output -r linux-x64 --self-contained

start:build
	dotnet  output/webapi.dll
	
buildDocker:build
	docker build -t $(IMAGE_NAME):$(NEW_TAG) .
	docker run -d -p 5402:5402 --name  $(IMAGE_NAME)_container_$(NEW_TAG) $(IMAGE_NAME):$(NEW_TAG)

stopContainer:
	docker stop $(IMAGE_NAME)_container_$(CURRENT_TAG)

removeContainer:stopContainer	
	docker rm $(IMAGE_NAME)_container_$(CURRENT_TAG)