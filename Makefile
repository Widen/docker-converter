all: push
.phony: build tag push clean

EXIFTOOL_VERSION = 9.88
GS_VERSION = 9.20
GS_VERSION_NUM_ONLY = 920

VERSION = $(shell git rev-parse --abbrev-ref HEAD)
BUILD_DATE = $(shell date +"%Y%m%d")

TAG = $(VERSION)-$(BUILD_DATE)
PREFIX = quay.io/widen/converter

build:
	docker build --pull \
		--build-arg EXIFTOOL_VERSION=$(EXIFTOOL_VERSION) \
		--build-arg GS_VERSION=$(GS_VERSION) \
		--build-arg GS_VERSION_NUM_ONLY=$(GS_VERSION_NUM_ONLY) \
		-t $(PREFIX):$(TAG) .

tag: build
	docker tag $(PREFIX):$(TAG) $(PREFIX):$(VERSION)

push: tag
	docker push $(PREFIX):$(TAG)
	docker push $(PREFIX):$(VERSION)

clean:
	docker rmi -f $(PREFIX):$(TAG) || true
	docker rmi -f $(PREFIX):$(VERSION) || true
