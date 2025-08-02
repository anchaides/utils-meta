pkgname=anchaides-meta 
pkgver=1.4
pkgrel=2
pkgdesc="Aggregator package for useful scripts I've ran across over time" 
arch=('x86_64')
url=TBD
license=('GPL')
source=("git+https://gist.github.com/40dc881248c5685d1b9ccfbf559269fa.git"
        "git+https://github.com/andre-richter/vfio-pci-bind.git"
        "git+https://github.com/gnif/LookingGlass.git#tag=B7-rc1" 
        "git+https://github.com/anchaides/input-forwarder.git#commit=261fc17"
)
sha256sums=('SKIP' 'SKIP' 'SKIP' 'SKIP' ) 
depends=('git' 'cmake' 'fontconfig' 'binutils' 'libxss' 'libxpresent' 'pipewire' 'libsamplerate' 'spice-protocol' 'linux-lts-headers' 'linux-headers' 'python-pywayland' 'python-pywlroots' 'wayland-protocols')

build() {
    mkdir -p  $srcdir/bin 

    cp $srcdir/40dc881248c5685d1b9ccfbf559269fa/iommu.sh $srcdir/bin/print-iommu 
    mv $srcdir/vfio-pci-bind/vfio-pci-bind.sh $srcdir/bin/vfio-pci-bind 

    #looking glass compile - rebuild should fix missing library dependencies (From discord)
    mkdir -p  $srcdir/LookingGlass/client/build 
    cd $srcdir/LookingGlass
    git submodule update --init --recursive
    cd client/build 
    cmake -DENABLE_PULSEAUDIO=no -DCMAKE_INSTALL_PREFIX=$srcdir -DCMAKE_POLICY_VERSION_MINIMUM=3.5 ..
    make install 

    prev_cwd=$(pwd)
    cd $srcdir/input-forwarder 
    git submodule update --init --recursive 
    cd wayland_client 
    make 
    cd $prev_cwd 

}

prepare() {
  echo "Empty stage" 
  #git clone -b v0.0.1 https://github.com/anchaides/input-forwarder.git
  #cd "$srcdir/input-forwarder"

  # Check out the branch into a working tree
  #git config --local --get remote.origin.fetch >/dev/null || git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
  #git fetch origin
  #git checkout -f master

}

package_input_forwarder() {
    mkdir -p $pkgdir/usr/lib/input_forwarder/
    mkdir -p $pkgdir/usr/bin/


    install -Dm755 $srcdir/input-forwarder/wayland_client/hover_surface    $pkgdir/usr/bin/
    install -Dm755 $srcdir/input-forwarder/input_forwarder/__init__.py  $pkgdir/usr/lib/input_forwarder/__init__.py
    install -Dm755 $srcdir/input-forwarder/input_forwarder/__main__.py  $pkgdir/usr/lib/input_forwarder/__main__.py
    install -Dm755 $srcdir/input-forwarder/input_forwarder/config.py    $pkgdir/usr/lib/input_forwarder/config.py
    install -Dm755 $srcdir/input-forwarder/input_forwarder/fsm.py       $pkgdir/usr/lib/input_forwarder/fsm.py
    install -Dm755 $srcdir/input-forwarder/input_forwarder/io_backend_x11.py  $pkgdir/usr/lib/input_forwarder/io_backend_x11.py
    install -Dm755 $srcdir/input-forwarder/input_forwarder/threads.py  $pkgdir/usr/lib/input_forwarder/threads.py
    install -Dm755 $srcdir/input-forwarder/input_forwarder/composer_backend.py  $pkgdir/usr/lib/input_forwarder/composer_backend.py
    install -Dm755 $srcdir/input-forwarder/input_forwarder/io_backend_wayland.py  $pkgdir/usr/lib/input_forwarder/io_backend_wayland.py

    mkdir    -p  $pkgdir/usr/lib/systemd/user/ 
    install -Dm644 $srcdir/input-forwarder/service/input-forwarder.service $pkgdir/usr/lib/systemd/user/input-forwarder.service
   
    mkdir    -p  $pkgdir/etc/udev/rules.d/ 
    install -Dm644 $srcdir/input-forwarder/service/99-uinput.rules  $pkgdir/etc/udev/rules.d/99-uinput.rules
    # UINPUT - Input forwarder 
    echo "uinput" > "${pkgdir}/etc/modules-load.d/uinput.conf"
    echo 'KERNEL=="uinput", OWNER="root", GROUP="input", MODE="0660"' > "${pkgdir}/etc/udev/rules.d/99-uinput.rules"

}

package() {
    cd $srcdir 

    install -dm755  "${pkgdir}/etc/udev/rules.d/" 
    install -dm755  "${pkgdir}/etc/modules-load.d/" 

    package_input_forwarder

    install -Dm755 bin/print-iommu "$pkgdir/usr/bin/print-iommu" 
    install -Dm755 bin/vfio-pci-bind  "$pkgdir/usr/bin/vfio-pci-bind" 
    install -Dm755 bin/looking-glass-client "$pkgdir/usr/bin/looking-glass-client" 
    install -Dm755 LookingGlass/resources/icon-128x128.png "$pkgdir/usr/share/icons/hicolor/128x128/apps/looking-glass-client.png"

    cd "$srcdir/LookingGlass/module"
    git checkout e25492a3 

    source dkms.conf 

    sudo mkdir -p       "${pkdir}/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}" 

    echo "* copying module into /usr/src" 

    install -dm755    "${pkgdir}/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"
    cp      -r $PWD/* "${pkgdir}/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"

    mkdir -p ${pkgdir}/etc/modprobe.d/
    echo "options kvmfr static_size_mb=32" > "${pkgdir}/etc/modprobe.d/kvmfr.conf"
    echo 'SUBSYSTEM=="kvmfr", KERNEL=="kvmfr0", OWNER="root", GROUP="kvm", MODE="0660"' > "${pkgdir}/etc/udev/rules.d/99-kvmfr.rules"

    # Load all modules that need to be present at start up 
    # KVMFR  - Looking Glass 
    echo "kvmfr" >  "${pkgdir}/etc/modules-load.d/kvmfr.conf"


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
