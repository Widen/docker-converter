all: push

VERSION = 0.1
EXIFTOOL_VERSION = 9.88
GS_VERSION = 9.16

BUILD_DATE = $(shell date +"%Y%m%d")

TAG = $(VERSION)-$(BUILD_DATE)
PREFIX = quay.io/widen/converter

build:
	docker build --pull \
		--build-arg EXIFTOOL_VERSION=$(EXIFTOOL_VERSION) \
		--build-arg GS_VERSION=$(GS_VERSION) \
		-t $(PREFIX):$(TAG) .

tag: build
	docker tag $(PREFIX):$(TAG) $(PREFIX):$(VERSION)

push: tag
	docker push $(PREFIX):$(TAG)
	docker push $(PREFIX):$(VERSION)

clean:
	docker rmi -f $(PREFIX):$(TAG) || true
	docker rmi -f $(PREFIX):$(VERSION) || true
