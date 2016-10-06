all: push

VERSION = 0.1

BUILD_DATE = $(shell date +"%Y%m%d")

TAG = $(VERSION)-$(BUILD_DATE)
PREFIX = quay.io/widen/converter

build:
	docker build --pull -t $(PREFIX):$(TAG) .

tag: build
	docker tag $(PREFIX):$(TAG) $(PREFIX):$(VERSION)

push: tag
	docker push $(PREFIX):$(TAG)
	docker push $(PREFIX):$(VERSION)

clean:
	docker rmi -f $(PREFIX):$(TAG) || true
	docker rmi -f $(PREFIX):$(VERSION) || true
