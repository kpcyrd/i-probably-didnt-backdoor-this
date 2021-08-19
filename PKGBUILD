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
