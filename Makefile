.PHONY: clone
clone:
	git clone git@github.com:googleapis/googleapis.git ../googleapis
	git clone git@github.com:lightstep/lightstep-tracer-common.git ../lightstep-tracer-common

.PHONY: proto
proto:
	protoc -I"$(PWD)/../googleapis/:$(PWD)/../lightstep-tracer-common/" \
		--js_out=import_style=commonjs,binary:packages/dd-trace/src/generated_proto \
		metrics.proto collector.proto \
		google/api/annotations.proto google/api/http.proto

.PHONY: release
release:
	@if [ $(shell git symbolic-ref --short -q HEAD) != "master" ]; then exit 0; else \
		echo "Current git branch is 'master'. Please prepare a PR and then merge to master, Refusing to publish."; exit 1; \
	fi
	npm version $(RELEASE_TYPE)
	npm run release:prepare
	@echo
	@echo "Version and tag created. The publish will be done automatically from circleCI."
	@echo

