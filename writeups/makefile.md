# `Makefile`

This is likely the most complicated file in this repository, we're going to
explain this in depth.

```make
build:
	docker run --rm -v "$(PWD):/app" -w /app -u "$(shell id -u):$(shell id -g)" \
		rust@sha256:8463cc29a3187a10fc8bf5200619aadf78091b997b0c3941345332a931c40a64 \
		cargo build --release --locked --target=x86_64-unknown-linux-musl

docker:
	sudo buildah bud --timestamp 0 --tag asdf

src.tgz:
	git archive -o src.tgz HEAD

.PHONY: build docker src.tgz
```

## `build:`

This builds the ELF binary.

- `docker run` This means we're going to run a [docker
  container](https://www.docker.com/resources/what-container)
- `--rm` This means the container should be temporary and is going to be
  deleted after our command completes.
- `-v "$(PWD):/app"` This means we're going to make the current directory
  available in the container at `/app`.
- `-w /app` This means we want to run our command inside of `/app`
- `-u "$(shell id -u):$(shell id -g)" ` This means the user id and group id
  of the process in the container should be equal to the user id and group id
  of the host system. This is important on Linux because of the mount, with
  docker for macOS this setting is actually optional.
- `rust@sha256:8463cc29a3187a10fc8bf5200619aadf78091b997b0c3941345332a931c40a64`
  This specifies one specific Rust image by it's checksum. This is important to
  document which compiler was used to build the binary. If you use the same
  compiler you're also going to get a 100% identical binary (note this might
  not be the case with more complex builds).
- `cargo build --release --locked` This is the command we're running inside the
  container. This is compiling the binary with optimizations from the release
  profile.
- `--locked` This option explicitly says the dependencies in the Cargo.lock
  file must be used (none, in our case).
- `--target=x86_64-unknown-linux-musl` This specifies the target system we want
  to support, in our case that's the cpu architecture and linux with musl libc.
  This currently implies statically linked builds in the rust world.

## `docker:`

This builds the Docker image.

- `sudo buildah` This means we're going to run [`buildah`](https://buildah.io/)
  as root. `buildah` is a tool to build container images, its less known than
  docker but has a unique feature that we're going to use here. The final image
  can be used with docker too.
- `bud` This is short for build-using-dockerfile, it means we're going to
  execute the instructions in our [`Dockerfile`](dockerfile.md).
- `--timestamp 0` This causes buildah to hardcode the build time to `1970-01-01
  00:00:00`. Usually the current time is used instead, which would make the
  image indeterministic.
- `--tag asdf` This means our newly built image should be tagged with the name
  `asdf`.

## `src.tgz:`

This snapshots all the source code from this git commit into an archive. This
is only needed for the Arch Linux package.

- `git archive` This subcommand creates an archive that contains all the code
  from a given commit.
- `-o src.tgz` This specifies the file the archive should be written to.
- `HEAD` Refers to the commit we've currently checked out.

## `.PHONY: build docker`

This means `build` and `docker` are target names, not file names. The commands
should execute even if a file with that name already exists.
