# `Dockerfile`

```dockerfile
FROM docker.io/rust@sha256:8463cc29a3187a10fc8bf5200619aadf78091b997b0c3941345332a931c40a64
WORKDIR /app
COPY . .
RUN cargo build --release --locked --target=x86_64-unknown-linux-musl

FROM docker.io/alpine@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae
COPY --from=0 /app/target/x86_64-unknown-linux-musl/release/asdf /asdf
ENTRYPOINT ["/asdf"]
```

The Dockerfile has two stages, the first one compiles the source code:

- `FROM
  docker.io/rust@sha256:8463cc29a3187a10fc8bf5200619aadf78091b997b0c3941345332a931c40a64`
  This describes the image we use to build the binary for our Docker image.
  This is the same image we also referenced in the Makefile.
- `WORKDIR /app` By default the working directory is `/`, this line creates a
  folder that we're going to compile in and change the working directory to
  this folder.
- `COPY . .` This copies the content of the current directory of the build
  system into the container. The current directory on the build system is
  expected to be the folder that this repository was cloned to, so the files
  that are copied are only those from the git repository.
- `RUN cargo build --release --locked --target=x86_64-unknown-linux-musl` This
  compiles the rust source code into a binary. The command is explained in
  detail in the [`Makefile`](makefile.md) writeup. This command is likely making our temporary

The temporary build image is done at this point, the second `FROM` starts a new
image:

- `FROM
  docker.io/alpine@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae`
  This is the base image for our final image that we're going to upload. The
  rust compiler is not required anymore so we're using one of the official
  [alpine](https://hub.docker.com/_/alpine) images here.
- `COPY --from=0 /app/target/x86_64-unknown-linux-musl/release/asdf /asdf` This
  copies the build artifact from the previous image into the final Docker
  image. If this binary is reproducible the final Docker image is going to be
  reproducible too.
- `ENTRYPOINT ["/asdf"]` This sets the `/asdf` binary we just copied into the
  container as the entrypoint, meaning if the container is executed, this
  binary runs, nothing else.
