FROM docker.io/alpine@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae
COPY target/x86_64-unknown-linux-musl/release/asdf /asdf
ENTRYPOINT ["/asdf"]
