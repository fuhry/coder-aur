# vim: set ft=sh ts=4 sw=4 et:
# Maintainer: Maarten de Boer <maarten@cloudstek.nl>
# Maintainer: Dan Fuhry <dan@fuhry.com>

pkgname=('coder')
pkgver=2.15.0
pkgrel=1
pkgdesc="Provision remote development environments via Terraform"
arch=('i386' 'x86_64' 'armv7h' 'aarch64')
url="https://github.com/coder/coder"
license=('AGPL-3.0')
depends=('glibc')
makedepends=('go>=1.22.0')

source=("${pkgname}-${pkgver}.tar.gz::https://github.com/coder/coder/archive/refs/tags/v${pkgver}.tar.gz")
sha512sums=('8588ed75ce1a522215dba680b515cdf7bfb63abcc08c325805bef5ae221e2cab5c8d8263bd9db2fff4c9b7ba478238029510c408b076c8656e7e8934d6d24654')

determine_goarch() {
    case "${CARCH}" in
        amd64|x86_64)
            build_arch="amd64" ;;
        arm64|aarch64)
            build_arch="arm64" ;;
        *)
            build_arch="$(go env GOARCH)"
    esac

    echo "${build_arch}"
}

prepare() {
    cd "${srcdir}/${pkgname}-${pkgver}"
    for f in "${source[@]}"; do
        if [ "${f##*.}" = "patch" ]; then
            msg "Aplying patch: ${f}"
            patch -Np1 -i "${srcdir}/${f}"
        fi
    done
}

build() {
    cd "${srcdir}/${pkgname}-${pkgver}"

    export GOPATH="${srcdir}/go"
    export GOCACHE="${srcdir}/go-cache"

    # See: https://wiki.archlinux.org/index.php/Go_package_guidelines
    export CGO_CPPFLAGS="${CPPFLAGS}"
    export CGO_CFLAGS="${CFLAGS}"
    export CGO_CXXFLAGS="${CXXFLAGS}"
    export CGO_LDFLAGS="${LDFLAGS}"
    export GOFLAGS="-buildmode=pie -trimpath -ldflags=-linkmode=external -mod=readonly -modcacherw"

    build_arch="$(determine_goarch)"

	# Generating these mocks tends to fail, but the generated files are committed.
	# Touching them prevents make from trying to recreate them.
	touch coderd/database/dbmock/dbmock.go \
	    coderd/database/pubsub/psmock/psmock.go

    # "src" env var is used to override coder source directory, because their build
    # scripts look for .git which is usually the AUR packaging scripts (since we are
    # using release tarballs)
	env CODER_FORCE_VERSION=${pkgver} \
        src="$(pwd)" \
	    make build/coder-slim_linux_${build_arch}

    # Make sure go path is writable so it can be cleaned up
    chmod -R u+w "${srcdir}/go"
    chmod -R u+w "${srcdir}/go-cache"
}

package_coder() {
    cd "${srcdir}/${pkgname}-${pkgver}"
    build_arch="$(determine_goarch)"

	install -d -m755 "${pkgdir}/usr/bin"
    install -m755 "build/coder-slim_${pkgver}_linux_${build_arch}" "${pkgdir}/usr/bin/coder"
	
	install -d -m755 "${pkgdir}/usr/share/licenses/coder"
    install -m644 "LICENSE" "${pkgdir}/usr/share/licenses/coder/LICENSE"
}

