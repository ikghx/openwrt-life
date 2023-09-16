define Device/generic
  DEVICE_VENDOR := Generic
  DEVICE_MODEL := x86/64
  DEVICE_PACKAGES += \
	kmod-amazon-ena kmod-amd-xgbe kmod-bnx2 kmod-e1000e kmod-e1000 \
	kmod-forcedeth kmod-fs-vfat kmod-igb kmod-igc kmod-ixgbe kmod-r8169 \
	kmod-tg3
  GRUB2_VARIANT := generic
endef
TARGET_DEVICES += generic

define Device/mellanox_spectrum-sn2100
  DEVICE_VENDOR := Mellanox
  DEVICE_MODEL := Spectrum SN2100
  DEVICE_PACKAGES += \
	kmod-mlxsw-core kmod-mlxsw-pci kmod-mlxsw-i2c \
	kmod-mlxsw-spectrum kmod-mlxsw-minimal kmod-mlxfw \
	kmod-leds-mlxcpld kmod-lib-objagg kmod-lib-parman \
	kmod-hwmon-coretemp kmod-hwmon-drivetemp kmod-hwmon-jc42 \
	kmod-i2c-i801 kmod-igb mlxsw_spectrum-firmware
  GRUB2_VARIANT := generic
endef
TARGET_DEVICES += mellanox_spectrum-sn2100
