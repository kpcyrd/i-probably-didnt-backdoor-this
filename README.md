# I probably didn't backdoor this

This is a practical attempt at shipping a program and having reasonably solid
evidence there's probably no backdoor. All source code is annotated and there
are instructions explaining how to use reproducible builds to rebuild the
artifacts distributed in this repository from source.

The idea is shifting the burden of proof from "you need to prove there's a
backdoor" to "we need to prove there's probably no backdoor". This repository
is less about code (we're going to try to keep code at a minimum actually) and
instead contains technical writing that explains why these controls are
effective and how to verify them. You are very welcome to adopt the techniques
used here in your projects.

The author should be assumed to be your average software developer, who might
be suspiciously good with computer security, but doesn't have nation-state
capabilities.

## Contents

- [Preparing retroactive reviews](#preparing-retroactive-reviews)
- [Pinned external resources](#pinned-external-resources)
- [Reading the source code](#reading-the-source-code)
- [Reproducing the ELF binary](#reproducing-the-elf-binary)
- [Reproducing the Docker image](#reproducing-the-oci-image)
- [Reproducing the Arch Linux package](#reproducing-the-arch-linux-package)
- [Notes on security patches](#notes-on-security-patches)
- [How is this related to Reproducible Builds](#how-is-this-related-to-reproducible-builds)
- [Similar work](#similar-work)

### Preparing retroactive reviews

Since "reading the source code" requires advanced domain knowledge, this
section describes a pen-and-paper aproach that can be used to cryptographically
ensure you can retro-actively review what you executed, even if you didn't
review before you executed it. Pen-and-paper should be taken literally here to
ensure this can't be modified by software. If done correctly, you don't need to
read the other sections immediately, instead you're creating an immutable
papertrail that can later be used by a subject matter expert. Note that the
review needs to happen on a different computer than the one that executed the
code, for safety reasons.

Because it's in the authors interest to prove there are no backdoors, all
external resources that are not contained within this repository need to be
referred to in a way that's addressing its content (more on this in the next
section).

We're starting with the main repository by cloning it and showing the commit
hash we're about to work with:

```sh
$ git clone https://github.com/kpcyrd/i-probably-didnt-backdoor-this
$ cd i-probably-didnt-backdoor-this/
$ git rev-parse HEAD
aabbccddeeff00112233445566778899aabbccdd
```

The hash in the last line is going to be different for you. This 40 character
id is what you need for your paper trail, you need to write this down
(preferably along with the current date) and keep it in a safe location. It
needs to be protected from undetected tampering but isn't secret, so you may
create copies or even post it publicly.

This id uniquely identifies all files in this repository with their content. If
a file is modified/removed/added/renamed in this repository, this hash changes
too.

If you want to read more about the cryptographic properties behind this, look
into [Merkel trees](https://en.wikipedia.org/wiki/Merkle_tree).

### Pinned external resources

In the previous section we've described how git is automatically tracking the
content of all files in this repository with a single hash. Software projects
often rely on external resources downloaded from the internet, like libraries.

Downloading resources from the internet doesn't weaken what we've established
in the previous section, as long as:

1. The content of the resource is pinned with a cryptographic hash and the hash
   is recorded in the git repository.
2. We can be reasonably sure the resource is not going to disappear. If they
   disappear you could attempt to use backup copies, as long as they match the
   cryptographic hash in the repository.

If at least one of those two doesn't apply we "broke the chain of custody".

We don't have to implement this ourselves, but `cargo` and `docker` implement
this internally.

### Reading the source code

The repository contains 6 source code files, there's a writeup for each of
them. Files ending with `.md` are documentation.

- [`Cargo.toml`](writeups/cargo-toml.md) - Contains metadata about the project and a list of dependencies (if any)
- [`Cargo.lock`](writeups/cargo-lock.md) - Automatically generated, records sha256 checksums for all dependencies
- [`src/main.rs`](writeups/main-rs.md) - The actual source code of our program
- [`Makefile`](writeups/makefile.md) - A wrapper script with build instructions
- [`Dockerfile`](writeups/dockerfile.md) - Contains build instructions for a container image
- [`PKGBUILD`](writeups/pkgbuild.md) - Contains build instructions for an Arch Linux package

### Reproducing the ELF binary

The binary is built in a docker container, the exact command can be found in
the [`Makefile`](writeups/makefile.md). Running make executes the build in a
specific Docker image (the official rust 1.54.0 alpine 3.14 docker image).

Because the build environment is pinned and there's nothing introducing
non-determinism to the build (like recording the build time), running the build
on different computers (or even operating systems) should always result in the
same binary.

Start the build with this command:

```sh
$ make
```

This command should finish quite quickly and produces a binary that matches
this checksum:

```sh
$ b2sum target/x86_64-unknown-linux-musl/release/asdf
35578eb5fbd13fe27bbc9f799488de2a196acfdb00886d7a5b88e13e0a73e8197fded1afdc9eb6b886864cd39bdeaa17910351da971710056630b1cb3a31a8cd  target/x86_64-unknown-linux-musl/release/asdf
```

If you get the same checksum you've successfully reproduced the binary. If
there's no difference between the pre-compiled binary and the one you built
yourself this means the pre-compiled binary is just as trustworthy as the one
you built yourself.

### Reproducing the Docker image

There's a Dockerfile in the repository that always produces the same
bit-for-bit identical image if we provide the same binary (and use the right
command). It does so by selecting one specific official alpine image by its
sha256 hash, then `COPY`s the binary we've built in the previous section.

```sh
$ b2sum target/x86_64-unknown-linux-musl/release/asdf
35578eb5fbd13fe27bbc9f799488de2a196acfdb00886d7a5b88e13e0a73e8197fded1afdc9eb6b886864cd39bdeaa17910351da971710056630b1cb3a31a8cd  target/x86_64-unknown-linux-musl/release/asdf
$ make docker
sudo buildah bud --timestamp 0 --tag asdf
STEP 1/3: FROM docker.io/alpine@sha256:eb3e4e175ba6d212ba1d6e04fc0782916c08e1c9d7b45892e9796141b1d379ae
STEP 2/3: COPY target/x86_64-unknown-linux-musl/release/asdf /asdf
STEP 3/3: ENTRYPOINT ["/asdf"]
COMMIT asdf
Getting image source signatures
Copying blob bc276c40b172 skipped: already exists
Copying blob 0ab66dfcdb16 done
Copying config 1816fbf1a0 done
Writing manifest to image destination
Storing signatures
--> 1816fbf1a0d
Successfully tagged localhost/asdf:latest
1816fbf1a0d2b49dda1eecc604419e5a8cb72df7924a7d2a3ebded128c9a1f66
```

The last line is the hash of our image.  We're using buildah to build the image
because there's no way to set the layer timestamp with docker (causing the hash
to vary). Unfortunately buildah records it's version, this image has been built
with `1.22.0`.

Next pull the image from the registry:

```sh
$ docker pull ghcr.io/kpcyrd/i-probably-didnt-backdoor-this:latest
latest: Pulling from kpcyrd/i-probably-didnt-backdoor-this
06127b9e1ec2: Pull complete
7c4fdf312986: Pull complete
Digest: sha256:7914eb02bce9944273a753e83cd55063ddbfd1aaf76fc023175188485d968fd3
Status: Downloaded newer image for ghcr.io/kpcyrd/i-probably-didnt-backdoor-this:latest
ghcr.io/kpcyrd/i-probably-didnt-backdoor-this:latest
```

You'll noticed the hash doesn't seem to match at first, but the image id is
indeed the same:

```
$ docker images --no-trunc ghcr.io/kpcyrd/i-probably-didnt-backdoor-this
REPOSITORY                                      TAG       IMAGE ID                                                                  CREATED        SIZE
ghcr.io/kpcyrd/i-probably-didnt-backdoor-this   latest    sha256:1816fbf1a0d2b49dda1eecc604419e5a8cb72df7924a7d2a3ebded128c9a1f66   51 years ago   9.38MB
```

### Reproducing the Arch Linux package

There's a custom Arch Linux repository that's distributing a pre-built package:

```
[i-probably-didnt-backdoor-this]
Server = https://pkgbuild.com/~kpcyrd/$repo/os/$arch/
```

This package can be reproduced from source, the full writeup for this can be
found in [this document](writeups/archlinux.md).

### Notes on security patches

We've pinned very specific versions in multiple places (including the
compiler). This is often considered bad style since we're now in charge of
keeping all of this updated.

If you're adopting this in your own project you should periodically release new
versions, even if you aren't making any changes to the code anymore. This also
applies to many modern programming ecosystems these days due to lock files.

The following places need to be updated occasionally, causing the artifact
hashes to change.

- Dependencies in Cargo.toml/Cargo.lock (if any, cargo update)
- `FROM` line in Dockerfile (docker pull alpine:latest)
- The build image in the Makefile (docker pull rust:alpine)

### How is this related to Reproducible Builds

There's quite a bit of overlap with the [reproducible
builds](https://reproducible-builds.org) project. The techniques used to
rebuild the binary artifacts are only possible because the builds for this
project are [reproducible](https://reproducible-builds.org/docs/definition/).

This project also attempts to exclusively use binaries distributed by
high-profile targets like Alpine Linux and the Rust project. This is commonly
accepted as "reasonable" in the wider tech industry, but makes their build
servers and signing keys extremely valuable.

The reproducible builds effort attempts to reduce this risk by allowing
independent parties to "reproduce" their packages with "confirmation rebuilds",
just like you did when following the instructions here!

### Similar work

- [Verifying a Tails image for reproducibility](https://tails.boum.org/contribute/build/reproducible/)
- [Reproducing Monero Binaries](https://github.com/monero-project/monero/blob/master/contrib/gitian/README.md)

## Acknowledgments

This project was funded by Google, The Linux Foundation, and people like you
and me through [GitHub sponsors](https://github.com/sponsors/kpcyrd).
♥️♥️♥️

## License

Licensed under either of Apache License, Version 2.0 or MIT license at your
option.
