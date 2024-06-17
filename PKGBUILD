pkgname=utils-meta 
pkgver=0.1 
pkgrel=0
pkgdesc="Aggregator package for useful scripts I've ran across over time" 
arch=('x86_64')
url=TBD
license=('GPL')
source=("git+https://gist.github.com/40dc881248c5685d1b9ccfbf559269fa.git"
        "git+https://github.com/andre-richter/vfio-pci-bind.git"
)
sha256sums=('SKIP' 'SKIP') 

build() {
    cd "$srcdir"
    mv 40dc881248c5685d1b9ccfbf559269fa/iommu.sh print-iommu 
    mv vfio-pci-bind/vfio-pci-bind.sh vfio-pci-bind 
}

package() {
    cd "$srcdir"
    install -Dm755 print-iommu "$pkgdir/usr/bin/print-iommu" 
    install -Dm755 vfio-pci-bind  "$pkgdir/usr/bin/vfio-pci-bind" 
}

