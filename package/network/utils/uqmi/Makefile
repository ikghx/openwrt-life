include $(TOPDIR)/rules.mk

PKG_NAME:=uqmi
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=$(PROJECT_GIT)/project/uqmi.git
PKG_SOURCE_DATE:=2024-04-24
PKG_SOURCE_VERSION:=e7207bec95f02f2f7a98254d642186a082af838d
PKG_MIRROR_HASH:=d835b874a9c8bac8d801d310decf95eb7c357fe0348a1f9935752b1bc0412b55
PKG_MAINTAINER:=Matti Laakso <malaakso@elisanet.fi>

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=

PKG_FLAGS:=nonshared
PKG_BUILD_FLAGS:=gc-sections

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/uqmi
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=WWAN
  DEPENDS:=+libubox +libblobmsg-json +kmod-usb-net +kmod-usb-net-qmi-wwan +wwan
  TITLE:=Control utility for mobile broadband modems
endef

define Package/uqmi/description
  uqmi is a command line tool for controlling mobile broadband modems using
  the QMI-protocol.
endef

TARGET_CFLAGS += \
	-I$(STAGING_DIR)/usr/include \
	-Wno-error=maybe-uninitialized

CMAKE_OPTIONS += \
	-DDEBUG=1

define Package/uqmi/install
	$(INSTALL_DIR) $(1)/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/uqmi/uqmi $(1)/sbin/
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,uqmi))
