pkgname=utils-meta 
pkgver=1.0 
pkgrel=3
pkgdesc="Aggregator package for useful scripts I've ran across over time" 
arch=('x86_64')
url=TBD
license=('GPL')
source=("git+https://gist.github.com/40dc881248c5685d1b9ccfbf559269fa.git"
        "git+https://github.com/andre-richter/vfio-pci-bind.git"
)
sha256sums=('SKIP' 'SKIP') 

build() {
    mkdir -p  $srcdir/bin 

    cp $srcdir/40dc881248c5685d1b9ccfbf559269fa/iommu.sh $srcdir/bin/print-iommu 
    mv $srcdir/vfio-pci-bind/vfio-pci-bind.sh $srcdir/bin/vfio-pci-bind 
}

package() {
    cd $srcdir 
    install -Dm755 bin/print-iommu "$pkgdir/usr/bin/print-iommu" 
    install -Dm755 bin/vfio-pci-bind  "$pkgdir/usr/bin/vfio-pci-bind" 
}

