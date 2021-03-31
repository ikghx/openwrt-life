#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=grub
PKG_CPE_ID:=cpe:/a:gnu:grub2
PKG_VERSION:=2.04
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=@GNU/grub
PKG_HASH:=e5292496995ad42dabe843a0192cf2a2c502e7ffcc7479398232b10a472df77d

HOST_BUILD_PARALLEL:=1

PKG_SSP:=0

PKG_FLAGS:=nonshared

PATCH_DIR:=../patches

HOST_BUILD_DIR ?= $(BUILD_DIR_HOST)/$(PKG_NAME)-$(GRUB_PLATFORM)/$(PKG_NAME)$(if $(PKG_VERSION),-$(PKG_VERSION))
HOST_BUILD_PREFIX := $(STAGING_DIR_HOST)

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk


HOST_CONFIGURE_VARS += \
	grub_build_mkfont_excuse="don't want fonts"

HOST_CONFIGURE_ARGS += \
	--disable-grub-mkfont \
	--target=$(REAL_GNU_TARGET_NAME) \
	--sbindir="$(STAGING_DIR_HOST)/bin" \
	--disable-werror \
	--disable-libzfs \
	--disable-nls \
	--with-platform=$(GRUB_PLATFORM)

HOST_MAKE_FLAGS += \
	TARGET_RANLIB=$(TARGET_RANLIB) \
	LIBLZMA=$(STAGING_DIR_HOST)/lib/liblzma.a

define Host/Configure
	$(SED) 's,(RANLIB),(TARGET_RANLIB),' $(HOST_BUILD_DIR)/grub-core/Makefile.in
	$(Host/Configure/Default)
endef
