# `Cargo.toml`

This is mostly defaults from running `cargo new --bin asdf`:

```toml
[package]
name = "asdf"
version = "0.1.1"
edition = "2018"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
```

- `name = "asdf"` is the name of our project. This isn't really used for
  anything but the binary name.
- `version = "0.1.1"` is the version of our project.
- `edition = "2018"` this means we're opting into new features of the Rust
  compiler. If unspecified rustc is using the 2015 edition, the 2018 edition is
  the default for new projects.

The `[dependencies]` section is able to reference other code that isn't part of
this repository, but there are none in this case because there are no lines
after this one.
