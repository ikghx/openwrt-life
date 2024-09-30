include $(TOPDIR)/rules.mk

PKG_NAME:=yafut
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/kempniu/yafut.git
PKG_MIRROR_HASH:=ef0bc790aa87484c13de0a1f3a350f6a9b276dc2ba9ecf0f71179edac5c478c4
PKG_SOURCE_DATE:=2024-05-13
PKG_SOURCE_VERSION:=2b45baaf1cced47af8f22dd3acbf1df2f04c7510

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_INSTALL:=1

$(eval $(call HostBuild))
