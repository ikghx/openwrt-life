include ./common-ubnt.mk

define Device/ubnt_aircube-ac
  $(Device/ubnt-acb)
  SOC := ar9342
  DEVICE_MODEL := airCube AC
  UBNT_CHIP := ar9342
  DEVICE_PACKAGES += kmod-ath10k-ct-smallbuffers ath10k-firmware-qca988x-ct
endef
TARGET_DEVICES += ubnt_aircube-ac

define Device/ubnt_aircube-isp
  $(Device/ubnt-acb)
  SOC := qca9533
  DEVICE_MODEL := airCube ISP
  UBNT_CHIP := qca9533
  SUPPORTED_DEVICES += ubnt,acb-isp
endef
TARGET_DEVICES += ubnt_aircube-isp

define Device/ubnt_airrouter
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := AirRouter
  SUPPORTED_DEVICES += airrouter
endef
TARGET_DEVICES += ubnt_airrouter

define Device/ubnt_bullet-ac
  $(Device/ubnt-2wa)
  DEVICE_MODEL := Bullet AC
  DEVICE_PACKAGES += kmod-ath10k-ct-smallbuffers ath10k-firmware-qca988x-ct rssileds
endef
TARGET_DEVICES += ubnt_bullet-ac

define Device/ubnt_bullet-m-ar7240
  $(Device/ubnt-xm)
  SOC := ar7240
  DEVICE_MODEL := Bullet M
  DEVICE_VARIANT := XM (AR7240)
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_bullet-m-ar7240

define Device/ubnt_bullet-m-ar7241
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Bullet M
  DEVICE_VARIANT := XM (AR7241)
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m ubnt,bullet-m
endef
TARGET_DEVICES += ubnt_bullet-m-ar7241

define Device/ubnt_bullet-m-xw
  $(Device/ubnt-xw)
  DEVICE_MODEL := Bullet M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m-xw
endef
TARGET_DEVICES += ubnt_bullet-m-xw

define Device/ubnt_edgeswitch-5xp
  $(Device/ubnt-sw)
  DEVICE_MODEL := EdgeSwitch 5XP
endef
TARGET_DEVICES += ubnt_edgeswitch-5xp

define Device/ubnt_edgeswitch-8xp
  $(Device/ubnt-sw)
  DEVICE_MODEL := EdgeSwitch 8XP
  DEVICE_PACKAGES += kmod-switch-bcm53xx-mdio
  DEFAULT := n
endef
TARGET_DEVICES += ubnt_edgeswitch-8xp

define Device/ubnt_lap-120
  $(Device/ubnt-wa)
  DEVICE_MODEL := LiteAP ac (LAP-120)
  DEVICE_PACKAGES += kmod-ath10k-ct-smallbuffers ath10k-firmware-qca988x-ct
endef
TARGET_DEVICES += ubnt_lap-120

define Device/ubnt_litebeam-ac-gen2
  $(Device/ubnt-wa)
  DEVICE_MODEL := LiteBeam AC
  DEVICE_VARIANT := Gen2
  DEVICE_PACKAGES := kmod-ath10k-ct-smallbuffers ath10k-firmware-qca988x-ct
endef
TARGET_DEVICES += ubnt_litebeam-ac-gen2

define Device/ubnt_nanobeam-ac
  $(Device/ubnt-wa)
  DEVICE_MODEL := NanoBeam AC
  DEVICE_VARIANT := Gen1
  DEVICE_PACKAGES += kmod-ath10k-ct-smallbuffers ath10k-firmware-qca988x-ct rssileds
endef
TARGET_DEVICES += ubnt_nanobeam-ac

define Device/ubnt_nanobeam-ac-gen2
  $(Device/ubnt-wa)
  DEVICE_MODEL := NanoBeam AC
  DEVICE_VARIANT := Gen2
  DEVICE_PACKAGES += kmod-ath10k-ct-smallbuffers ath10k-firmware-qca988x-ct rssileds
endef
TARGET_DEVICES += ubnt_nanobeam-ac-gen2

define Device/ubnt_nanobridge-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := NanoBridge M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_nanobridge-m

define Device/ubnt_nanostation-ac
  $(Device/ubnt-wa)
  DEVICE_MODEL := Nanostation AC
  DEVICE_PACKAGES += kmod-ath10k-ct-smallbuffers ath10k-firmware-qca988x-ct rssileds
endef
TARGET_DEVICES += ubnt_nanostation-ac

define Device/ubnt_nanostation-ac-loco
  $(Device/ubnt-wa)
  DEVICE_MODEL := Nanostation AC loco
  DEVICE_PACKAGES += kmod-ath10k-ct-smallbuffers ath10k-firmware-qca988x-ct
endef
TARGET_DEVICES += ubnt_nanostation-ac-loco

define Device/ubnt_nanostation-loco-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Nanostation Loco M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_nanostation-loco-m

define Device/ubnt_nanostation-loco-m-xw
  $(Device/ubnt-xw)
  DEVICE_MODEL := Nanostation Loco M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += loco-m-xw
endef
TARGET_DEVICES += ubnt_nanostation-loco-m-xw

define Device/ubnt_nanostation-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Nanostation M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += nanostation-m
endef
TARGET_DEVICES += ubnt_nanostation-m

define Device/ubnt_nanostation-m-xw
  $(Device/ubnt-xw)
  DEVICE_MODEL := Nanostation M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += nanostation-m-xw
endef
TARGET_DEVICES += ubnt_nanostation-m-xw

define Device/ubnt_picostation-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Picostation M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_picostation-m

define Device/ubnt_powerbeam-5ac-500
  $(Device/ubnt-xc)
  SOC := qca9558
  DEVICE_MODEL := PowerBeam 5AC
  DEVICE_VARIANT := 500
  DEVICE_PACKAGES := kmod-ath10k-ct ath10k-firmware-qca988x-ct
endef
TARGET_DEVICES += ubnt_powerbeam-5ac-500

define Device/ubnt_powerbeam-5ac-gen2
  $(Device/ubnt-wa)
  DEVICE_MODEL := PowerBeam 5AC
  DEVICE_VARIANT := Gen2
  DEVICE_PACKAGES := kmod-ath10k-ct-smallbuffers ath10k-firmware-qca988x-ct rssileds
endef
TARGET_DEVICES += ubnt_powerbeam-5ac-gen2

define Device/ubnt_powerbridge-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := PowerBridge M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_powerbridge-m

define Device/ubnt_rocket-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Rocket M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += rocket-m
endef
TARGET_DEVICES += ubnt_rocket-m

define Device/ubnt_routerstation_common
  DEVICE_PACKAGES := -kmod-ath9k -wpad-basic-wolfssl -uboot-envtools kmod-usb-ohci \
	kmod-usb2 fconfig
  DEVICE_VENDOR := Ubiquiti
  SOC := ar7161
  IMAGE_SIZE := 16128k
  IMAGES += factory.bin
  IMAGE/factory.bin := append-rootfs | pad-rootfs | mkubntimage | \
	check-size
  IMAGE/sysupgrade.bin := append-rootfs | pad-rootfs | combined-image | \
	append-metadata | check-size
  KERNEL := kernel-bin | append-dtb | lzma | pad-to $$(BLOCKSIZE)
  KERNEL_INITRAMFS := kernel-bin | append-dtb
endef

define Device/ubnt_routerstation
  $(Device/ubnt_routerstation_common)
  DEVICE_MODEL := RouterStation
  UBNT_BOARD := RS
  UBNT_TYPE := RSx
  UBNT_CHIP := ar7100
  DEVICE_PACKAGES += -swconfig
  SUPPORTED_DEVICES += routerstation
endef
TARGET_DEVICES += ubnt_routerstation

define Device/ubnt_routerstation-pro
  $(Device/ubnt_routerstation_common)
  DEVICE_MODEL := RouterStation Pro
  UBNT_BOARD := RSPRO
  UBNT_TYPE := RSPRO
  UBNT_CHIP := ar7100pro
  SUPPORTED_DEVICES += routerstation-pro
endef
TARGET_DEVICES += ubnt_routerstation-pro

define Device/ubnt_unifi
  $(Device/ubnt-bz)
  DEVICE_MODEL := UniFi
  SUPPORTED_DEVICES += unifi
endef
TARGET_DEVICES += ubnt_unifi

define Device/ubnt_unifiac
  DEVICE_VENDOR := Ubiquiti
  SOC := qca9563
  IMAGE_SIZE := 15488k
  DEVICE_PACKAGES := kmod-ath10k-ct ath10k-firmware-qca988x-ct
endef

define Device/ubnt_unifiac-lite
  $(Device/ubnt_unifiac)
  DEVICE_MODEL := UniFi AC Lite
  DEVICE_PACKAGES += -swconfig
  SUPPORTED_DEVICES += unifiac-lite
endef
TARGET_DEVICES += ubnt_unifiac-lite

define Device/ubnt_unifiac-lr
  $(Device/ubnt_unifiac)
  DEVICE_MODEL := UniFi AC LR
  DEVICE_PACKAGES += -swconfig
  SUPPORTED_DEVICES += unifiac-lite ubnt,unifiac-lite
endef
TARGET_DEVICES += ubnt_unifiac-lr

define Device/ubnt_unifiac-mesh
  $(Device/ubnt_unifiac)
  DEVICE_MODEL := UniFi AC Mesh
  DEVICE_PACKAGES += -swconfig
  SUPPORTED_DEVICES += unifiac-lite
endef
TARGET_DEVICES += ubnt_unifiac-mesh

define Device/ubnt_unifiac-mesh-pro
  $(Device/ubnt_unifiac)
  DEVICE_MODEL := UniFi AC Mesh Pro
  SUPPORTED_DEVICES += unifiac-pro
endef
TARGET_DEVICES += ubnt_unifiac-mesh-pro

define Device/ubnt_unifiac-pro
  $(Device/ubnt_unifiac)
  DEVICE_MODEL := UniFi AC Pro
  DEVICE_PACKAGES += kmod-usb2
  SUPPORTED_DEVICES += unifiac-pro
endef
TARGET_DEVICES += ubnt_unifiac-pro

define Device/ubnt_unifi-ap-outdoor-plus
  $(Device/ubnt-bz)
  $(Device/ubnt-unifi-jffs2)
  DEVICE_MODEL := UniFi AP Outdoor+
  SUPPORTED_DEVICES += unifi-outdoor-plus
endef
TARGET_DEVICES += ubnt_unifi-ap-outdoor-plus

define Device/ubnt_unifi-ap-pro
  $(Device/ubnt-unifi-jffs2)
  SOC := ar9344
  DEVICE_MODEL := UniFi AP Pro
  UBNT_CHIP := ar934x
  SUPPORTED_DEVICES += uap-pro
endef
TARGET_DEVICES += ubnt_unifi-ap-pro
