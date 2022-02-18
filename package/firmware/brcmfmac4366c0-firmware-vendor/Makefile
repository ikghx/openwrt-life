#
# Copyright (C) 2021 ImmortalWrt
# <https://immortalwrt.org>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=brcmfmac-firmware-4366c0-pcie
PKG_VERSION:=1
PKG_RELEASE:=1
PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk

define Package/brcmfmac-firmware-4366c0-pcie-ea9500
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=Broadcom 4366c0 FullMac PCIe firmware from ea9500
  CONFLICTS:=brcmfmac-firmware-4366c0-pcie
endef

define Package/brcmfmac-firmware-4366c0-pcie-k3
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=Broadcom 4366c0 FullMac PCIe firmware from k3
  CONFLICTS:=brcmfmac-firmware-4366c0-pcie
endef

define Package/brcmfmac-firmware-4366c0-pcie-r8500
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=Broadcom 4366c0 FullMac PCIe firmware from r8500
  CONFLICTS:=brcmfmac-firmware-4366c0-pcie
endef

define Build/Compile
endef

define Package/brcmfmac-firmware-4366c0-pcie-ea9500/install
	$(INSTALL_DIR) $(1)/lib/firmware/brcm
	$(INSTALL_DATA) ./files/brcmfmac4366c-pcie-ea9500.bin $(1)/lib/firmware/brcm/brcmfmac4366c-pcie.bin
endef

define Package/brcmfmac-firmware-4366c0-pcie-k3/install
	$(INSTALL_DIR) $(1)/lib/firmware/brcm
	$(INSTALL_DATA) ./files/brcmfmac4366c-pcie-k3.bin $(1)/lib/firmware/brcm/brcmfmac4366c-pcie.bin
endef

define Package/brcmfmac-firmware-4366c0-pcie-r8500/install
	$(INSTALL_DIR) $(1)/lib/firmware/brcm
	$(INSTALL_DATA) ./files/brcmfmac4366c-pcie-r8500.bin $(1)/lib/firmware/brcm/brcmfmac4366c-pcie.bin
endef

$(eval $(call BuildPackage,brcmfmac-firmware-4366c0-pcie-ea9500))
$(eval $(call BuildPackage,brcmfmac-firmware-4366c0-pcie-k3))
$(eval $(call BuildPackage,brcmfmac-firmware-4366c0-pcie-r8500))
