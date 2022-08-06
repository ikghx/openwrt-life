define Device/generic
  DEVICE_TITLE := Generic x86/64
  DEVICE_PACKAGES += \
	kmod-amazon-ena kmod-bnx2 kmod-e1000e kmod-e1000 \
	kmod-forcedeth kmod-fs-vfat kmod-igb kmod-igc kmod-ixgbe kmod-r8169 \
	kmod-tg3
  GRUB2_VARIANT := generic
endef
TARGET_DEVICES += generic
