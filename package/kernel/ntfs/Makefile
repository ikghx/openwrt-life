include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=linux-ntfs
PKG_RELEASE:=1
PKG_BUILD_PARALLEL:=1

PKG_SOURCE_DATE:=2026-06-22
PKG_SOURCE_URL:=https://github.com/namjaejeon/linux-ntfs
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=640b7dde5def187d41042ec29a66fcbc46cdcc3a
PKG_MIRROR_HASH:=14997a1481cc66c8f5d8ccb29b7eb60724cc7ea5642bcdfa51ff85e182aaa3ce

PKG_LICENSE:=GPL-2.0-or-later

PKG_MAINTAINER:=Qingfang Deng <dqfext@gmail.com>

include $(INCLUDE_DIR)/package.mk

define KernelPackage/fs-ntfs
  SECTION:=kernel
  CATEGORY:=Kernel modules
  SUBMENU:=Filesystems
  TITLE:=NTFS file system support
  DEPENDS:=+kmod-nls-base
  URL:=$(PKG_SOURCE_URL)
  FILES:=$(PKG_BUILD_DIR)/ntfs.ko
  AUTOLOAD:=$(call AutoProbe,ntfs)
endef

define KernelPackage/fs-ntfs/description
  NTFS is the file system of Microsoft Windows NT, 2000, XP and 2003.
  This allows you to mount devices formatted with the ntfs file system.
endef

NOSTDINC_FLAGS += \
	$(KERNEL_NOSTDINC_FLAGS)

EXTRA_KCONFIG:= \
	CONFIG_NTFS_FS=m

MAKE_OPTS:= \
	M="$(PKG_BUILD_DIR)" \
	NOSTDINC_FLAGS="$(NOSTDINC_FLAGS)" \
	$(EXTRA_KCONFIG)

define Build/Compile
	+$(KERNEL_MAKE) $(PKG_JOBS) $(MAKE_OPTS) modules
endef

$(eval $(call KernelPackage,fs-ntfs))
