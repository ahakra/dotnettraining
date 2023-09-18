IMAGE_NAME := webapi
VERSION := $(shell docker images -q $(IMAGE_NAME) | head -n1)
NEW_VERSION := $(shell echo $(VERSION) | awk -F: '{print $(NF)}' | awk '{print $$1+1}')
NEW_IMAGE_NAME := $(IMAGE_NAME):$(NEW_VERSION)
CURRENT_TAG := $(shell docker images --format "{{.Tag}}" $(IMAGE_NAME) | head -n1)
NEW_TAG := $(shell expr $(CURRENT_TAG) + 1)


start:
	dotnet publish -c Release -o ./output -r linux-x64 --self-contained
	dotnet  output/webapi.dll
	
buildDocker:
	dotnet publish -c Release -o ./output -r linux-x64 --self-contained
	docker build -t $(IMAGE_NAME):$(NEW_TAG) .
	docker run -d -p 5402:5402 --name  $(IMAGE_NAME)_container_$(NEW_TAG) $(IMAGE_NAME):$(NEW_TAG)

stopContainer:
	docker stop $(IMAGE_NAME)_container_$(CURRENT_TAG)

removeContainer:stopCotainer
	
	docker rm $(IMAGE_NAME)_container_$(CURRENT_TAG)