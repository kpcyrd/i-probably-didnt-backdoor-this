### Reproducing the Arch Linux package

There's a custom Arch Linux repository that's distributing this package.

    [i-probably-didnt-backdoor-this]
    Server = https://pkgbuild.com/~kpcyrd/$repo/os/$arch/

This repository contains these 6 files:

- [i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst](https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst)
  This is the pre-built package that's going to be installed on the system.
  This is the file we want to reproduce.
- [i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst.sig](https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst.sig)
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
  i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst` signs the package
  with my key
- `repo-add i-probably-didnt-backdoor-this.db.tar.gz
  i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst`  this creates a
  package database with our package

`extra-x86_64-build` uses a clean chroot and records the environment in a file
called `.BUILDINFO` that's embedded in the package. We download the package and
list what's inside of it:

    $ wget https://pkgbuild.com/~kpcyrd/i-probably-didnt-backdoor-this/os/x86_64/i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst
    [...]
    $ b2sum i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst
    83b289364105e4d6f1d89a92bf5c1aa4e7e6367e14cb28ba1c28ece4a0d0012481f6af802cb0a2abd78c346c3eb6f7ac758e83eac6ffeeb18df8588cb00b11e8  i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst
    $ tar tf i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst
    .BUILDINFO
    .MTREE
    .PKGINFO
    usr/
    usr/bin/
    usr/bin/asdf

There's the .BUILDINFO file we already mentioned before, 2 files that are used
internally by pacman, and the binary that is distributed in this package.

We only really care about the `.BUILDINFO` file, let's look into it:

    $ tar xfO i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst .BUILDINFO
    format = 2
    pkgname = i-probably-didnt-backdoor-this
    pkgbase = i-probably-didnt-backdoor-this
    pkgver = 0.1.0-1
    pkgarch = x86_64
    pkgbuild_sha256sum = c7a3ce47d0f3b95ffae58fa60f1a08ab698c6a6f719f273ef8dff22ac2caefef
    packager = kpcyrd <kpcyrd@archlinux.org>
    builddate = 1629399235
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
    installed = archlinux-keyring-20210802-1-any
    installed = argon2-20190702-3-x86_64
    installed = attr-2.5.1-1-x86_64
    installed = audit-3.0.4-1-x86_64
    installed = autoconf-2.71-1-any
    installed = automake-1.16.4-1-any
    installed = bash-5.1.008-1-x86_64
    installed = binutils-2.36.1-3-x86_64
    installed = bison-3.7.6-1-x86_64
    installed = bzip2-1.0.8-4-x86_64
    installed = ca-certificates-20210603-1-any
    installed = ca-certificates-mozilla-3.69-1-x86_64
    installed = ca-certificates-utils-20210603-1-any
    installed = coreutils-8.32-1-x86_64
    installed = cracklib-2.9.7-2-x86_64
    installed = cryptsetup-2.3.6-1-x86_64
    installed = curl-7.78.0-1-x86_64
    installed = db-5.3.28-5-x86_64
    installed = dbus-1.12.20-1-x86_64
    installed = device-mapper-2.03.13-1-x86_64
    installed = diffutils-3.8-1-x86_64
    installed = e2fsprogs-1.46.3-3-x86_64
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
    installed = glib2-2.68.3-1-x86_64
    installed = glibc-2.33-5-x86_64
    installed = gmp-6.2.1-1-x86_64
    installed = gnupg-2.2.29-1-x86_64
    installed = gnutls-3.7.2-2-x86_64
    installed = gpgme-1.16.0-1-x86_64
    installed = grep-3.6-1-x86_64
    installed = groff-1.22.4-6-x86_64
    installed = guile-2.2.7-1-x86_64
    installed = gzip-1.10-3-x86_64
    installed = hwids-20210613-1-any
    installed = iana-etc-20210728-1-any
    installed = icu-69.1-1-x86_64
    installed = iptables-1:1.8.7-1-x86_64
    installed = json-c-0.15-1-x86_64
    installed = kbd-2.4.0-2-x86_64
    installed = keyutils-1.6.3-1-x86_64
    installed = kmod-29-1-x86_64
    installed = krb5-1.19.1-1-x86_64
    installed = less-1:590-1-x86_64
    installed = libarchive-3.5.1-1-x86_64
    installed = libassuan-2.5.5-1-x86_64
    installed = libatomic_ops-7.6.10-2-x86_64
    installed = libcap-2.51-1-x86_64
    installed = libcap-ng-0.8.2-3-x86_64
    installed = libcroco-0.6.13-2-x86_64
    installed = libedit-20210522_3.1-1-x86_64
    installed = libelf-0.185-1-x86_64
    installed = libffi-3.3-4-x86_64
    installed = libgcrypt-1.9.3-1-x86_64
    installed = libgpg-error-1.42-1-x86_64
    installed = libidn2-2.3.2-1-x86_64
    installed = libksba-1.6.0-1-x86_64
    installed = libldap-2.4.59-2-x86_64
    installed = libmicrohttpd-0.9.73-1-x86_64
    installed = libmnl-1.0.4-3-x86_64
    installed = libmpc-1.2.1-1-x86_64
    installed = libnetfilter_conntrack-1.0.8-1-x86_64
    installed = libnfnetlink-1.0.1-4-x86_64
    installed = libnftnl-1.2.0-1-x86_64
    installed = libnghttp2-1.44.0-1-x86_64
    installed = libnl-3.5.0-3-x86_64
    installed = libp11-kit-0.24.0-1-x86_64
    installed = libpcap-1.10.1-1-x86_64
    installed = libpsl-0.21.1-1-x86_64
    installed = libsasl-2.1.27-3-x86_64
    installed = libseccomp-2.5.1-2-x86_64
    installed = libsecret-0.20.4-1-x86_64
    installed = libssh2-1.9.0-3-x86_64
    installed = libtasn1-4.17.0-1-x86_64
    installed = libtirpc-1.3.2-1-x86_64
    installed = libtool-2.4.6+42+gb88cebd5-16-x86_64
    installed = libunistring-0.9.10-3-x86_64
    installed = libusb-1.0.24-2-x86_64
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
    installed = openssl-1.1.1.k-1-x86_64
    installed = p11-kit-0.24.0-1-x86_64
    installed = pacman-6.0.0-5-x86_64
    installed = pacman-mirrorlist-20210808-1-any
    installed = pam-1.5.1-1-x86_64
    installed = pambase-20210605-2-any
    installed = patch-2.7.6-8-x86_64
    installed = pcre-8.45-1-x86_64
    installed = pcre2-10.37-1-x86_64
    installed = perl-5.34.0-2-x86_64
    installed = pinentry-1.1.1-1-x86_64
    installed = pkgconf-1.7.3-1-x86_64
    installed = popt-1.18-1-x86_64
    installed = readline-8.1.001-1-x86_64
    installed = rust-1:1.54.0-1-x86_64
    installed = sed-4.8-1-x86_64
    installed = shadow-4.8.1-4-x86_64
    installed = sqlite-3.36.0-1-x86_64
    installed = sudo-1.9.7.p2-1-x86_64
    installed = systemd-249.3-1-x86_64
    installed = systemd-libs-249.3-1-x86_64
    installed = tar-1.34-1-x86_64
    installed = texinfo-6.8-2-x86_64
    installed = tzdata-2021a-1-x86_64
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

    $ makerepropkg i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst
    Create subvolume '/var/lib/archbuild/reproducible/root'
    ==> Creating install root at /var/lib/archbuild/reproducible/root
    ==> Installing packages to /var/lib/archbuild/reproducible/root
    warning: database file for 'core' does not exist (use '-Sy' to download)
    warning: database file for 'extra' does not exist (use '-Sy' to download)
    warning: database file for 'community' does not exist (use '-Sy' to download)
    loading packages...
    resolving dependencies...
    looking for conflicting packages...

    Packages (131) acl-2.3.1-1  archlinux-keyring-20210802-1  argon2-20190702-3  attr-2.5.1-1
                   audit-3.0.4-1  autoconf-2.71-1  automake-1.16.4-1  bash-5.1.008-1  binutils-2.36.1-3
                   bison-3.7.6-1  bzip2-1.0.8-4  ca-certificates-20210603-1
                   ca-certificates-mozilla-3.69-1  ca-certificates-utils-20210603-1  coreutils-8.32-1
                   cracklib-2.9.7-2  cryptsetup-2.3.6-1  curl-7.78.0-1  db-5.3.28-5  dbus-1.12.20-1
                   device-mapper-2.03.13-1  diffutils-3.8-1  e2fsprogs-1.46.3-3  elfutils-0.185-1
                   expat-2.4.1-1  fakeroot-1.25.3-2  file-5.40-5  filesystem-2021.05.31-1
                   findutils-4.8.0-1  flex-2.6.4-3  gawk-5.1.0-1  gc-8.0.4-4  gcc-11.1.0-1
                   gcc-libs-11.1.0-1  gdbm-1.20-1  gettext-0.21-1  glib2-2.68.3-1  glibc-2.33-5
                   gmp-6.2.1-1  gnupg-2.2.29-1  gnutls-3.7.2-2  gpgme-1.16.0-1  grep-3.6-1
                   groff-1.22.4-6  guile-2.2.7-1  gzip-1.10-3  hwids-20210613-1  iana-etc-20210728-1
                   icu-69.1-1  iptables-1:1.8.7-1  json-c-0.15-1  kbd-2.4.0-2  keyutils-1.6.3-1
                   kmod-29-1  krb5-1.19.1-1  less-1:590-1  libarchive-3.5.1-1  libassuan-2.5.5-1
                   libatomic_ops-7.6.10-2  libcap-2.51-1  libcap-ng-0.8.2-3  libcroco-0.6.13-2
                   libedit-20210522_3.1-1  libelf-0.185-1  libffi-3.3-4  libgcrypt-1.9.3-1
                   libgpg-error-1.42-1  libidn2-2.3.2-1  libksba-1.6.0-1  libldap-2.4.59-2
                   libmicrohttpd-0.9.73-1  libmnl-1.0.4-3  libmpc-1.2.1-1  libnetfilter_conntrack-1.0.8-1
                   libnfnetlink-1.0.1-4  libnftnl-1.2.0-1  libnghttp2-1.44.0-1  libnl-3.5.0-3
                   libp11-kit-0.24.0-1  libpcap-1.10.1-1  libpsl-0.21.1-1  libsasl-2.1.27-3
                   libseccomp-2.5.1-2  libsecret-0.20.4-1  libssh2-1.9.0-3  libtasn1-4.17.0-1
                   libtirpc-1.3.2-1  libtool-2.4.6+42+gb88cebd5-16  libunistring-0.9.10-3
                   libusb-1.0.24-2  libxcrypt-4.4.25-1  libxml2-2.9.10-9  linux-api-headers-5.12.3-1
                   llvm-libs-12.0.1-3  lz4-1:1.9.3-2  m4-1.4.19-1  make-4.3-3  mpfr-4.1.0.p13-1
                   ncurses-6.2-2  nettle-3.7.3-1  npth-1.6-3  openssl-1.1.1.k-1  p11-kit-0.24.0-1
                   pacman-6.0.0-5  pacman-mirrorlist-20210808-1  pam-1.5.1-1  pambase-20210605-2
                   patch-2.7.6-8  pcre-8.45-1  pcre2-10.37-1  perl-5.34.0-2  pinentry-1.1.1-1
                   pkgconf-1.7.3-1  popt-1.18-1  readline-8.1.001-1  rust-1:1.54.0-1  sed-4.8-1
                   shadow-4.8.1-4  sqlite-3.36.0-1  sudo-1.9.7.p2-1  systemd-249.3-1
                   systemd-libs-249.3-1  tar-1.34-1  texinfo-6.8-2  tzdata-2021a-1  util-linux-2.37.2-1
                   util-linux-libs-2.37.2-1  which-2.21-5  xz-5.2.5-1  zlib-1:1.2.11-4  zstd-1.5.0-1

    Total Installed Size:  1373.98 MiB

    :: Proceed with installation? [Y/n]
    (131/131) checking keys in keyring                            [#################################] 100%
    (131/131) checking package integrity                          [#################################] 100%
    (131/131) loading package files                               [#################################] 100%
    (131/131) checking for file conflicts                         [#################################] 100%
    (131/131) checking available disk space                       [#################################] 100%
    :: Processing package changes...
    (  1/131) installing linux-api-headers                        [#################################] 100%
    (  2/131) installing tzdata                                   [#################################] 100%
    (  3/131) installing iana-etc                                 [#################################] 100%
    (  4/131) installing filesystem                               [#################################] 100%

This takes some time but should eventually print the following text at the end:

    ==> Extracting sources...
      -> Extracting src.tgz with bsdtar
    ==> Starting build()...
       Compiling asdf v0.1.0 (/build/i-probably-didnt-backdoor-this/src)
        Finished release [optimized] target(s) in 1.71s
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
    ==> Finished making: i-probably-didnt-backdoor-this 0.1.0-1 (Thu 19 Aug 2021 09:04:10 PM CEST)
      -> built succeeded! built packages can be found in /var/lib/archbuild/reproducible/testenv/pkgdest
    ==> comparing artifacts...
      -> Package 'i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst' successfully reproduced!

This means we've successfully built a package from source that is bit-for-bit
identical, including every file inside of it. The first is the package we
downloaded, the second is the package we built from source.

```sh
$ b2sum i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst /var/lib/archbuild/reproducible/testenv/pkgdest/i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst
83b289364105e4d6f1d89a92bf5c1aa4e7e6367e14cb28ba1c28ece4a0d0012481f6af802cb0a2abd78c346c3eb6f7ac758e83eac6ffeeb18df8588cb00b11e8  i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst
83b289364105e4d6f1d89a92bf5c1aa4e7e6367e14cb28ba1c28ece4a0d0012481f6af802cb0a2abd78c346c3eb6f7ac758e83eac6ffeeb18df8588cb00b11e8  /var/lib/archbuild/reproducible/testenv/pkgdest/i-probably-didnt-backdoor-this-0.1.0-1-x86_64.pkg.tar.zst
```
