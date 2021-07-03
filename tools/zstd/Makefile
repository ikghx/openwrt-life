include $(TOPDIR)/rules.mk

PKG_NAME:=zstd
PKG_VERSION:=1.4.9

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/facebook/zstd/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=acf714d98e3db7b876e5b540cbf6dee298f60eb3c0723104f6d3f065cd60d6a8

PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=LICENSE
PKG_CPE_ID:=cpe:/a:facebook:zstandard

CMAKE_SOURCE_SUBDIR:=build/cmake

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_HOST_OPTIONS += \
	-DBUILD_TESTING=OFF \
	-DCMAKE_C_COMPILER_LAUNCHER="" \
	-DCMAKE_C_COMPILER=$(HOSTCC_NOCACHE) \
	-DZSTD_LEGACY_SUPPORT=OFF

$(eval $(call HostBuild))
