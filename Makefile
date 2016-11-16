.PHONY: all build container quick-container push test clean

TAG = $(shell git describe --abbrev=0 --tags HEAD)
PREFIX = wongma7/nfs-provisioner

all: build

build:
	go build

container: build
	cp nfs-provisioner deploy/docker/nfs-provisioner
	docker build -t $(PREFIX):$(TAG) deploy/docker

quick-container:
	cp nfs-provisioner deploy/docker/nfs-provisioner
	docker build -t $(PREFIX):$(TAG) deploy/docker

push: container
	docker push $(PREFIX):$(TAG)

test:
	(gofmt -s -w -l `find . -type f -name "*.go" | grep -v vendor`) || exit 1
	go test `go list ./... | grep -v vendor`

clean:
	rm -f nfs-provisioner
	rm -f deploy/docker/nfs-provisioner
