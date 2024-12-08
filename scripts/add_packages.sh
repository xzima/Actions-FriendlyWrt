#!/bin/bash

# {{ Add luci-app-diskman
(cd friendlywrt && {
    mkdir -p package/luci-app-diskman
    wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/applications/luci-app-diskman/Makefile -O package/luci-app-diskman/Makefile
    mkdir -p package/parted
    wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -O package/parted/Makefile
})
cat >> configs/rockchip/01-nanopi <<EOL
CONFIG_PACKAGE_luci-app-diskman=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_btrfs_progs=y
CONFIG_PACKAGE_luci-app-diskman_INCLUDE_lsblk=y
CONFIG_PACKAGE_smartmontools=y
EOL
# }}

# {{ Add luci-theme-argon
(cd friendlywrt/package && {
    [ -d luci-theme-argon ] && rm -rf luci-theme-argon
    git clone https://github.com/jerrykuku/luci-theme-argon.git --depth 1 -b master
})
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> configs/rockchip/01-nanopi
sed -i -e 's/function init_theme/function old_init_theme/g' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
cat > /tmp/appendtext.txt <<EOL
function init_theme() {
    if uci get luci.themes.Argon >/dev/null 2>&1; then
        uci set luci.main.mediaurlbase="/luci-static/argon"
        uci commit luci
    fi
}
EOL
sed -i -e '/boardname=/r /tmp/appendtext.txt' friendlywrt/target/linux/rockchip/armv8/base-files/root/setup.sh
# }}

# {{ Add amneziawg
(cd friendlywrt && {
    mkdir -p package/kmod-amneziawg
    wget https://raw.githubusercontent.com/wadimk/awg-openwrt/refs/heads/master/kmod-amneziawg/Makefile -O package/kmod-amneziawg/Makefile

    mkdir -p package/amneziawg-tools
    wget https://raw.githubusercontent.com/wadimk/awg-openwrt/refs/heads/master/amneziawg-tools/Makefile -O package/amneziawg-tools/Makefile

    mkdir -p package/luci-app-amneziawg
    wget https://raw.githubusercontent.com/wadimk/awg-openwrt/refs/heads/master/luci-app-amneziawg/Makefile -O package/luci-app-amneziawg/Makefile
})
cat >> configs/rockchip/01-nanopi <<EOL

CONFIG_PACKAGE_kmod-amneziawg=m
CONFIG_PACKAGE_amneziawg-tools=y
CONFIG_PACKAGE_luci-app-amneziawg=y
CONFIG_PACKAGE_kmod-crypto-lib-chacha20=m
CONFIG_PACKAGE_kmod-crypto-lib-chacha20poly1305=m
CONFIG_PACKAGE_kmod-crypto-chacha20poly1305=m

EOL
# }}

