# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk

PKG_NAME:=xxHash
PKG_VERSION:=0.8.4

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/Cyan4973/xxHash
PKG_MIRROR_HASH:=4265c80d0ba3ec3aeb866572048cb77457ca3bcb61dec8ba1fe53814650fa6d4
PKG_SOURCE_VERSION:=c87183a77d67f7d37e3d2d1b7eaac5e7c695e4f0

PKG_LICENSE:=BSD-2-Clause
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_C_COMPILER_LAUNCHER :=
CMAKE_CXX_COMPILER_LAUNCHER :=

CMAKE_BINARY_SUBDIR := build
CMAKE_SOURCE_SUBDIR := cmake_unofficial

$(eval $(call HostBuild))
