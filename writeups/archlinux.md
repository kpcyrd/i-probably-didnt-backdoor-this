### Reproducing the Arch Linux package

There's a custom Arch Linux repository that's distributing this package.

    [i-probably-didnt-backdoor-this]
    Server = https://pkgbuild.com/~kpcyrd/$repo/os/$arch/

This repository contains these 6 files:

- [i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst](https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst)
  This is the pre-built package that's going to be installed on the system.
  This is the file we want to reproduce.
- [i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst.sig](https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst.sig)
  This is a signature that we can use to verify the previous file was signed by
  somebody with control over a specific private key. This signature is also
  included in the .db file, so this file might not get downloaded.
- [i-probably-didnt-backdoor-this.db](https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this.db)
  This contains an index of all packages in the repository. pacman downloads
  this to learn about the packages in this repository.
- [i-probably-didnt-backdoor-this.db.tar.gz](https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this.db.tar.gz)
  identical with the .db file for compatibility reasons.
- [i-probably-didnt-backdoor-this.files](https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this.files)
  This contains an index of all the files in each package, this is only used by
  `pacman -F` operations.
- [i-probably-didnt-backdoor-this.files.tar.gz](https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this.files.tar.gz)
  identical with the .files file for compatibility reasons.

This repository has been setup from this git repository using the following
commands. You don't need to run them, they're only included for documentation
purpose.

- `extra-x86_64-build` to build the package from the [`PKGBUILD`](pkgbuild.md)
  instructions
- `gpg --detach-sign --no-armor -u kpcyrd@archlinux.org
  i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst` signs the package
  with my key
- `repo-add i-probably-didnt-backdoor-this.db.tar.gz
  i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst`  this creates a
  package database with our package

`extra-x86_64-build` uses a clean chroot and records the environment in a file
called `.BUILDINFO` that's embedded in the package. We download the package and
list what's inside of it:

    $ wget https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst
    [...]
    $ b2sum i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst
    84f398fae04a0d73647a7074dd9669e7899d8b702c30c928606ec2b0fde739b8131f817e77631ed0ffef4696380fa5478a0ebe0aa4e0b3d33ea7e3ee2910678c  i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst
    $ tar tf i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst
    .BUILDINFO
    .MTREE
    .PKGINFO
    usr/
    usr/bin/
    usr/bin/asdf

There's the .BUILDINFO file we already mentioned before, 2 files that are used
internally by pacman, and the binary that is distributed in this package.

We only really care about the `.BUILDINFO` file, let's look into it:

    $ tar xfO i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst .BUILDINFO
    format = 2
    pkgname = i-probably-didnt-backdoor-this
    pkgbase = i-probably-didnt-backdoor-this
    pkgver = 0.1.1-1
    pkgarch = x86_64
    pkgbuild_sha256sum = b6e4c48bf0c3ee73ef80e6f29e646f191b204695b725684664a64c12cb7ee150
    packager = kpcyrd <kpcyrd@archlinux.org>
    builddate = 1630668222
    builddir = /build
    startdir = /startdir
    buildtool = makepkg
    buildtoolver = 6.0.0
    buildenv = !distcc
    buildenv = color
    buildenv = !ccache
    buildenv = check
    buildenv = !sign
    options = strip
    options = docs
    options = !libtool
    options = !staticlibs
    options = emptydirs
    options = zipman
    options = purge
    options = !debug
    installed = acl-2.3.1-1-x86_64
    installed = archlinux-keyring-20210820-1-any
    installed = attr-2.5.1-1-x86_64
    installed = audit-3.0.4-1-x86_64
    installed = autoconf-2.71-1-any
    installed = automake-1.16.4-1-any
    installed = bash-5.1.008-1-x86_64
    installed = binutils-2.36.1-3-x86_64
    installed = bison-3.7.6-1-x86_64
    installed = bzip2-1.0.8-4-x86_64
    installed = ca-certificates-20210603-1-any
    installed = ca-certificates-mozilla-3.69.1-1-x86_64
    installed = ca-certificates-utils-20210603-1-any
    installed = coreutils-8.32-1-x86_64
    installed = curl-7.78.0-1-x86_64
    installed = db-5.3.28-5-x86_64
    installed = diffutils-3.8-1-x86_64
    installed = e2fsprogs-1.46.4-1-x86_64
    installed = elfutils-0.185-1-x86_64
    installed = expat-2.4.1-1-x86_64
    installed = fakeroot-1.25.3-2-x86_64
    installed = file-5.40-5-x86_64
    installed = filesystem-2021.05.31-1-x86_64
    installed = findutils-4.8.0-1-x86_64
    installed = flex-2.6.4-3-x86_64
    installed = gawk-5.1.0-1-x86_64
    installed = gc-8.0.4-4-x86_64
    installed = gcc-11.1.0-1-x86_64
    installed = gcc-libs-11.1.0-1-x86_64
    installed = gdbm-1.20-1-x86_64
    installed = gettext-0.21-1-x86_64
    installed = glib2-2.68.4-1-x86_64
    installed = glibc-2.33-5-x86_64
    installed = gmp-6.2.1-1-x86_64
    installed = gnupg-2.2.29-1-x86_64
    installed = gnutls-3.7.2-2-x86_64
    installed = gpgme-1.16.0-1-x86_64
    installed = grep-3.6-1-x86_64
    installed = groff-1.22.4-6-x86_64
    installed = guile-2.2.7-1-x86_64
    installed = gzip-1.10-3-x86_64
    installed = iana-etc-20210728-1-any
    installed = icu-69.1-1-x86_64
    installed = keyutils-1.6.3-1-x86_64
    installed = krb5-1.19.1-1-x86_64
    installed = less-1:590-1-x86_64
    installed = libarchive-3.5.2-1-x86_64
    installed = libassuan-2.5.5-1-x86_64
    installed = libcap-2.53-1-x86_64
    installed = libcap-ng-0.8.2-3-x86_64
    installed = libcroco-0.6.13-2-x86_64
    installed = libedit-20210522_3.1-1-x86_64
    installed = libelf-0.185-1-x86_64
    installed = libffi-3.3-4-x86_64
    installed = libgcrypt-1.9.4-1-x86_64
    installed = libgpg-error-1.42-1-x86_64
    installed = libidn2-2.3.2-1-x86_64
    installed = libksba-1.6.0-1-x86_64
    installed = libldap-2.4.59-2-x86_64
    installed = libmpc-1.2.1-1-x86_64
    installed = libnghttp2-1.44.0-1-x86_64
    installed = libp11-kit-0.24.0-1-x86_64
    installed = libpsl-0.21.1-1-x86_64
    installed = libsasl-2.1.27-3-x86_64
    installed = libseccomp-2.5.1-2-x86_64
    installed = libsecret-0.20.4-1-x86_64
    installed = libssh2-1.9.0-3-x86_64
    installed = libtasn1-4.17.0-1-x86_64
    installed = libtirpc-1.3.2-1-x86_64
    installed = libtool-2.4.6+42+gb88cebd5-16-x86_64
    installed = libunistring-0.9.10-3-x86_64
    installed = libxcrypt-4.4.25-1-x86_64
    installed = libxml2-2.9.10-9-x86_64
    installed = linux-api-headers-5.12.3-1-any
    installed = llvm-libs-12.0.1-3-x86_64
    installed = lz4-1:1.9.3-2-x86_64
    installed = m4-1.4.19-1-x86_64
    installed = make-4.3-3-x86_64
    installed = mpfr-4.1.0.p13-1-x86_64
    installed = ncurses-6.2-2-x86_64
    installed = nettle-3.7.3-1-x86_64
    installed = npth-1.6-3-x86_64
    installed = openssl-1.1.1.l-1-x86_64
    installed = p11-kit-0.24.0-1-x86_64
    installed = pacman-6.0.0-5-x86_64
    installed = pacman-mirrorlist-20210822-1-any
    installed = pam-1.5.1-1-x86_64
    installed = pambase-20210605-2-any
    installed = patch-2.7.6-8-x86_64
    installed = pcre-8.45-1-x86_64
    installed = pcre2-10.37-1-x86_64
    installed = perl-5.34.0-2-x86_64
    installed = pinentry-1.1.1-1-x86_64
    installed = pkgconf-1.7.3-1-x86_64
    installed = readline-8.1.001-1-x86_64
    installed = rust-1:1.54.0-1-x86_64
    installed = sed-4.8-1-x86_64
    installed = shadow-4.8.1-4-x86_64
    installed = sqlite-3.36.0-1-x86_64
    installed = sudo-1.9.7.p2-1-x86_64
    installed = systemd-libs-249.4-1-x86_64
    installed = tar-1.34-1-x86_64
    installed = texinfo-6.8-2-x86_64
    installed = tzdata-2021a-2-x86_64
    installed = util-linux-2.37.2-1-x86_64
    installed = util-linux-libs-2.37.2-1-x86_64
    installed = which-2.21-5-x86_64
    installed = xz-5.2.5-1-x86_64
    installed = zlib-1:1.2.11-4-x86_64
    installed = zstd-1.5.0-1-x86_64

This seems like a lot of control from a file we just downloaded from the
internet, but note that most of these are only informal and the tooling we're
going to use only allows packages to be installed that have been officially
published in Arch Linux. The packages listed here are basically a base-devel
install plus `makedepends=`.

For official Arch Linux packages the field `pkgbase` is used with
[`asp`](https://man.archlinux.org/man/extra/asp/asp.1.en) to fetch the build
instructions and `pkgbuild_sha256sum` is used to identify the right commit. For
technical reasons the commit id is not yet available when the Arch Linux
package is built.

Because in our case everything is contained within this repository and we
already know the right commit, so we can skip this step. The Arch Linux tooling
expects a tar ball, so we're generating one from this repository. The commands
that are used for this can be found in the [`Makefile`](makefile.md).

    $ make src.tgz

Using the Arch Linux reproducible builds tooling we're taking the build
environment from the package, the [`PKGBUILD`](pkgbuild.md) build instructions
from this repository, and the `src.tgz` tar ball we've just generated and
attempt to create an identical package.

`makerepropkg` can be installed with `pacman -S devtools`.

    $ makerepropkg i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst
    Create subvolume '/var/lib/archbuild/reproducible/root'
    ==> Creating install root at /var/lib/archbuild/reproducible/root
    ==> Installing packages to /var/lib/archbuild/reproducible/root
    warning: database file for 'core' does not exist (use '-Sy' to download)
    warning: database file for 'extra' does not exist (use '-Sy' to download)
    warning: database file for 'community' does not exist (use '-Sy' to download)
    loading packages...
    resolving dependencies...
    looking for conflicting packages...

    Packages (110) acl-2.3.1-1  archlinux-keyring-20210820-1  attr-2.5.1-1  audit-3.0.4-1  autoconf-2.71-1
                   automake-1.16.4-1  bash-5.1.008-1  binutils-2.36.1-3  bison-3.7.6-1  bzip2-1.0.8-4
                   ca-certificates-20210603-1  ca-certificates-mozilla-3.69.1-1  ca-certificates-utils-20210603-1
                   coreutils-8.32-1  curl-7.78.0-1  db-5.3.28-5  diffutils-3.8-1  e2fsprogs-1.46.4-1  elfutils-0.185-1
                   expat-2.4.1-1  fakeroot-1.25.3-2  file-5.40-5  filesystem-2021.05.31-1  findutils-4.8.0-1
                   flex-2.6.4-3  gawk-5.1.0-1  gc-8.0.4-4  gcc-11.1.0-1  gcc-libs-11.1.0-1  gdbm-1.20-1  gettext-0.21-1
                   glib2-2.68.4-1  glibc-2.33-5  gmp-6.2.1-1  gnupg-2.2.29-1  gnutls-3.7.2-2  gpgme-1.16.0-1  grep-3.6-1
                   groff-1.22.4-6  guile-2.2.7-1  gzip-1.10-3  iana-etc-20210728-1  icu-69.1-1  keyutils-1.6.3-1
                   krb5-1.19.1-1  less-1:590-1  libarchive-3.5.2-1  libassuan-2.5.5-1  libcap-2.53-1  libcap-ng-0.8.2-3
                   libcroco-0.6.13-2  libedit-20210522_3.1-1  libelf-0.185-1  libffi-3.3-4  libgcrypt-1.9.4-1
                   libgpg-error-1.42-1  libidn2-2.3.2-1  libksba-1.6.0-1  libldap-2.4.59-2  libmpc-1.2.1-1
                   libnghttp2-1.44.0-1  libp11-kit-0.24.0-1  libpsl-0.21.1-1  libsasl-2.1.27-3  libseccomp-2.5.1-2
                   libsecret-0.20.4-1  libssh2-1.9.0-3  libtasn1-4.17.0-1  libtirpc-1.3.2-1
                   libtool-2.4.6+42+gb88cebd5-16  libunistring-0.9.10-3  libxcrypt-4.4.25-1  libxml2-2.9.10-9
                   linux-api-headers-5.12.3-1  llvm-libs-12.0.1-3  lz4-1:1.9.3-2  m4-1.4.19-1  make-4.3-3
                   mpfr-4.1.0.p13-1  ncurses-6.2-2  nettle-3.7.3-1  npth-1.6-3  openssl-1.1.1.l-1  p11-kit-0.24.0-1
                   pacman-6.0.0-5  pacman-mirrorlist-20210822-1  pam-1.5.1-1  pambase-20210605-2  patch-2.7.6-8
                   pcre-8.45-1  pcre2-10.37-1  perl-5.34.0-2  pinentry-1.1.1-1  pkgconf-1.7.3-1  readline-8.1.001-1
                   rust-1:1.54.0-1  sed-4.8-1  shadow-4.8.1-4  sqlite-3.36.0-1  sudo-1.9.7.p2-1  systemd-libs-249.4-1
                   tar-1.34-1  texinfo-6.8-2  tzdata-2021a-2  util-linux-2.37.2-1  util-linux-libs-2.37.2-1
                   which-2.21-5  xz-5.2.5-1  zlib-1:1.2.11-4  zstd-1.5.0-1

    Total Installed Size:  1330.71 MiB

    :: Proceed with installation? [Y/n]
    (110/110) checking keys in keyring                                     [#######################################] 100%
    (110/110) checking package integrity                                   [#######################################] 100%
    (110/110) loading package files                                        [#######################################] 100%
    (110/110) checking for file conflicts                                  [#######################################] 100%
    (110/110) checking available disk space                                [#######################################] 100%
    :: Processing package changes...
    (  1/110) installing linux-api-headers                                 [#######################################] 100%
    (  2/110) installing tzdata                                            [#######################################] 100%
    (  3/110) installing iana-etc                                          [#######################################] 100%
    (  4/110) installing filesystem                                        [#######################################] 100%

This takes some time but should eventually print the following text at the end:

    ==> Extracting sources...
      -> Extracting src.tgz with bsdtar
    ==> Starting build()...
       Compiling asdf v0.1.1 (/build/i-probably-didnt-backdoor-this/src)
        Finished release [optimized] target(s) in 1.63s
    ==> Entering fakeroot environment...
    ==> Starting package()...
    ==> Tidying install...
      -> Removing libtool files...
      -> Purging unwanted files...
      -> Removing static library files...
      -> Stripping unneeded symbols from binaries and libraries...
      -> Compressing man and info pages...
    ==> Checking for packaging issues...
    ==> Creating package "i-probably-didnt-backdoor-this"...
      -> Generating .PKGINFO file...
      -> Generating .BUILDINFO file...
    warning: database file for 'core' does not exist (use '-Sy' to download)
    warning: database file for 'extra' does not exist (use '-Sy' to download)
    warning: database file for 'community' does not exist (use '-Sy' to download)
      -> Generating .MTREE file...
      -> Compressing package...
    ==> Leaving fakeroot environment.
    ==> Finished making: i-probably-didnt-backdoor-this 0.1.1-1 (Fri 03 Sep 2021 01:26:15 PM CEST)
      -> built succeeded! built packages can be found in /var/lib/archbuild/reproducible/testenv/pkgdest
    ==> comparing artifacts...
      -> Package 'i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst' successfully reproduced!

This means we've successfully built a package from source that is bit-for-bit
identical, including every file inside of it. The first is the package we
downloaded, the second is the package we built from source.

```sh
$ b2sum i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst /var/lib/archbuild/reproducible/testenv/pkgdest/i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst
84f398fae04a0d73647a7074dd9669e7899d8b702c30c928606ec2b0fde739b8131f817e77631ed0ffef4696380fa5478a0ebe0aa4e0b3d33ea7e3ee2910678c  i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst
84f398fae04a0d73647a7074dd9669e7899d8b702c30c928606ec2b0fde739b8131f817e77631ed0ffef4696380fa5478a0ebe0aa4e0b3d33ea7e3ee2910678c  /var/lib/archbuild/reproducible/testenv/pkgdest/i-probably-didnt-backdoor-this-0.1.1-1-x86_64.pkg.tar.zst
```
