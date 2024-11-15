pkgname=anchaides-meta 
pkgver=1.2
pkgrel=5
pkgdesc="Aggregator package for useful scripts I've ran across over time" 
arch=('x86_64')
url=TBD
license=('GPL')
source=("git+https://gist.github.com/40dc881248c5685d1b9ccfbf559269fa.git"
        "git+https://github.com/andre-richter/vfio-pci-bind.git"
        "git+https://github.com/gnif/LookingGlass.git#tag=B7-rc1" 
)
sha256sums=('SKIP' 'SKIP' 'SKIP' ) 
depends=('git' 'cmake' 'fontconfig' 'binutils' 'libxss' 'libxpresent' 'pipewire' 'libsamplerate' 'spice-protocol' 'linux-lts-headers' 'linux-headers' )

build() {
    mkdir -p  $srcdir/bin 

    cp $srcdir/40dc881248c5685d1b9ccfbf559269fa/iommu.sh $srcdir/bin/print-iommu 
    mv $srcdir/vfio-pci-bind/vfio-pci-bind.sh $srcdir/bin/vfio-pci-bind 

    #looking glass compile 
    mkdir -p  $srcdir/LookingGlass/client/build 
    cd $srcdir/LookingGlass
    git submodule update --init --recursive
    cd client/build 
    cmake -DENABLE_PULSEAUDIO=no -DCMAKE_INSTALL_PREFIX=$srcdir ..
    make install 

    
}

package() {
    cd $srcdir 
    install -Dm755 bin/print-iommu "$pkgdir/usr/bin/print-iommu" 
    install -Dm755 bin/vfio-pci-bind  "$pkgdir/usr/bin/vfio-pci-bind" 
    install -Dm755 bin/looking-glass-client "$pkgdir/usr/bin/looking-glass-client" 
    install -Dm755 LookingGlass/resources/icon-128x128.png "$pkgdir/usr/share/icons/hicolor/128x128/apps/looking-glass-client.png"

    cd "$srcdir/LookingGlass/module"

    source dkms.conf 

    #sudo mkdir -p       "${pkdir}/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}" 
    #install -dm755 "${pkdir}/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"
    #sudo install -Dm755 dkms.conf "${pkdir}/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}/"
    #sudo dkms add     -m ${PACKAGE_NAME} -v ${PACKAGE_VERSION} 
    #sudo dkms build   -m ${PACKAGE_NAME} -v ${PACKAGE_VERSION} 
    #sudo dkms install -m ${PACKAGE_NAME} -v ${PACKAGE_VERSION} 

    sudo dkms install "." 

   #sudo dkms autoinstall 

    install -dm755  "${pkgdir}/etc/modprobe.d"
    echo "options kvmfr static_size_mb=32" > "${pkgdir}/etc/modprobe.d/kvmfr.conf"
}

post_install() {
    echo "Loading the module with modprobe." 
    sudo modprobe kvmfr static_size_mb=32
}

post_upgrade() {
    post_install
}

post_remove() {
    echo "Removing the module from the kernel."
    modprobe -r kvmfr 
    dkms remove kvmfr  || true 
}
