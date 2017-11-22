################################################################################
#      This file is part of LibreELEC - https://libreelec.tv
#      Copyright (C) 2017-present Team LibreELEC
#      Copyright (C) 2017 kszaq
#
#  LibreELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  LibreELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with LibreELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

PKG_NAME="RTL8723DS-aml"
PKG_VERSION="96c22b8"
PKG_SHA256="3cb93c41c400b5d929820cbc6d89e8f254853d9b8f3a5bff972d6d6cde035c86"
PKG_REV="1"
PKG_ARCH="arm aarch64"
PKG_LICENSE="GPL"
# amlogic: PKG_SITE="http://openlinux.amlogic.com:8000/download/ARM/wifi/"
PKG_SITE="https://github.com/khadas/android_hardware_wifi_realtek_drivers_8723ds"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_SOURCE_DIR="android_hardware_wifi_realtek_drivers_8723ds-$PKG_VERSION*"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_TOOLCHAIN="manual"
PKG_IS_KERNEL_PKG="yes"

post_unpack() {
  sed -i 's/-DCONFIG_CONCURRENT_MODE//g; s/^CONFIG_POWER_SAVING.*$/CONFIG_POWER_SAVING = n/g; s/^CONFIG_RTW_DEBUG.*/CONFIG_RTW_DEBUG = n/g' $PKG_BUILD/*/Makefile
  sed -i 's/^#define CONFIG_DEBUG.*//g' $PKG_BUILD/*/include/autoconf.h
}

make_target() {
  LDFLAGS="" make -C $(kernel_path) M=$PKG_BUILD/rtl8723DS \
       ARCH=$TARGET_KERNEL_ARCH \
       KSRC=$(kernel_path) \
       CROSS_COMPILE=$TARGET_PREFIX \
       USER_EXTRA_CFLAGS="-fgnu89-inline"
}

makeinstall_target() {
  mkdir -p $INSTALL/$(get_full_module_dir)/$PKG_NAME
  cp $PKG_BUILD/rtl8723DS/*.ko $INSTALL/$(get_full_module_dir)/$PKG_NAME
}
