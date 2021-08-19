# `Dockerfile`

```dockerfile
FROM docker.io/alpine@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae
COPY target/x86_64-unknown-linux-musl/release/asdf /asdf
ENTRYPOINT ["/asdf"]
```

- `FROM
  docker.io/alpine@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae`
  This describes the image we use as a base. We're pinning one of the official
  [alpine](https://hub.docker.com/_/alpine) images here.
- `COPY target/x86_64-unknown-linux-musl/release/asdf /asdf` This copies the
  file `target/x86_64-unknown-linux-musl/release/asdf` from our local
  filesystem to `/asdf` in the container. See the [`Makefile`](makefile.md) how
  this file is generated.
- `ENTRYPOINT ["/asdf"]` This sets the `/asdf` binary we just copied into the
  container as the entrypoint, meaning if the container is executed, this
  binary runs, nothing else.
