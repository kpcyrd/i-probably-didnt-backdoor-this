build:
	docker run --rm -v "$(PWD):/app" -w /app -u "$(shell id -u):$(shell id -g)" \
		rust@sha256:8463cc29a3187a10fc8bf5200619aadf78091b997b0c3941345332a931c40a64
		cargo build --release --locked --target=x86_64-unknown-linux-musl

docker:
	sudo buildah bud --timestamp 0 --tag asdf

src.tgz:
	git archive -o src.tgz HEAD

.PHONY: build docker src.tgz
