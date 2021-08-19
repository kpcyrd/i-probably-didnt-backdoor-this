# `PKGBUILD`

This file is only used if you're following the "Reproducing the Arch Linux
package" instructions.

```sh
pkgname=i-probably-didnt-backdoor-this
pkgver=0.1.0
pkgrel=1
arch=('x86_64')
makedepends=('cargo')
source=(src.tgz)
sha256sums=(SKIP)

build() {
    cargo build --release --locked
}

package() {
    install -Dm 755 target/release/asdf -t "${pkgdir}/usr/bin/"
}
```

This is the bare minimum to create a working package, even though it doesn't
meet the Arch Linux packaging standards (namcap is going to print some warnings
about this).

```sh
pkgname=i-probably-didnt-backdoor-this
pkgver=0.1.0
pkgrel=1
arch=('x86_64')
```

These fields are required in a PKGBUILD, it contains the package name and the
package version. `pkgrel=` is a "revision" in case we need to release a new
package for the same upstream version. `arch=` is a list of supported
architectures, for simplicity we set this to just `x86_64`.

```sh
makedepends=('cargo')
```

In addition to base-devel, which we can assume is always installed in the build
container, we also need the rust build system. Note that we don't specify which
version we want, for the initial build this is automatically going to resolve
to "the latest in Arch Linux", for our rebuild we're going to pick the one
that's specified in the `.BUILDINFO` file of the package we want to reproduce.
There's an in-depth explanation in the [Arch Linux package
writeup](archlinux.md).

```sh
source=(src.tgz)
sha256sums=(SKIP)
```

These are the source inputs, `src.tgz` is a tarball of this repository that
we're going to generate with `git archive` as described in the
[`Makefile`](makefile.md).

```sh
build() {
    cargo build --release --locked
}
```

This function implements the actual build. `--release` specifies the binary
should be built with the [standard release
profile](https://doc.rust-lang.org/cargo/reference/profiles.html#release).
`--locked` means the build MUST use the dependencies defined in
[`Cargo.lock`](cargo-lock.md).

```sh
package() {
    install -Dm 755 target/release/asdf -t "${pkgdir}/usr/bin/"
}
```

After the build this function implements how the package should be created.

- `install -Dm 755` means we want to copy a file, all directories in the
  destination path should be created as needed, and `755` are the permissions
  the file should have. This translates to "read/write/execute for root,
  read/execute for everybody else".
- `target/release/asdf` this is the file that was compiled in `build()` that we
  want to ship in our package.
- `-t "${pkgdir}/usr/bin/"` this means the file should be copied into the
  `/usr/bin/` folder of our package. `install` is going to keep the filename.
