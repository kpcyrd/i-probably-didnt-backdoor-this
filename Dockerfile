FROM docker.io/rust@sha256:8463cc29a3187a10fc8bf5200619aadf78091b997b0c3941345332a931c40a64
WORKDIR /app
COPY . .
RUN cargo build --release --locked --target=x86_64-unknown-linux-musl

FROM docker.io/alpine@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae
COPY --from=0 /app/target/x86_64-unknown-linux-musl/release/asdf /asdf
ENTRYPOINT ["/asdf"]
