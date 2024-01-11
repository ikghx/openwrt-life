MMEDIA_MENU:=Multimedia

define KernelPackage/multimedia
  SUBMENU:=$(MMEDIA_MENU)
  TITLE:=Multimedia
  KCONFIG:= \
	CONFIG_MEDIA_SUPPORT=m \
	CONFIG_MEDIA_SUPPORT_FILTER=y \
	CONFIG_MEDIA_USB_SUPPORT=y
  DEPENDS:=@USB_SUPPORT
  FILES:=$(LINUX_DIR)/drivers/media/mc/mc.ko
  AUTOLOAD:=$(call AutoLoad,80,mc)
endef
define KernelPackage/multimedia/description
  Kernel module for Multimedia support (cameras, TV tuners)
endef
$(eval $(call KernelPackage,multimedia))

# DVB & tuners

define KernelPackage/dvb-usb-v2
  SUBMENU:=$(MMEDIA_MENU)
  TITLE:=USB DVB support
  KCONFIG:= \
	CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y \
	CONFIG_MEDIA_ANALOG_TV_SUPPORT=y \
	CONFIG_DVB_CORE=m \
	CONFIG_DVB_USB_V2=m
  DEPENDS:=+kmod-i2c-core +kmod-usb-core kmod-multimedia
  FILES:= \
	$(LINUX_DIR)/drivers/media/dvb-core/dvb-core.ko \
	$(LINUX_DIR)/drivers/media/usb/dvb-usb-v2/dvb_usb_v2.ko
  AUTOLOAD:=$(call AutoLoad,81,dvb-core dvb_usb_v2)
endef
define KernelPackage/dvb-usb-v2/description
  Kernel module for USB DVB support
endef
$(eval $(call KernelPackage,dvb-usb-v2))

define KernelPackage/dvb-tuner-r820t
  SUBMENU:=$(MMEDIA_MENU)
  TITLE:=DVB Tuner Rafael Micro R820T
  KCONFIG:=CONFIG_MEDIA_TUNER_R820T=m
  DEPENDS:=kmod-dvb-usb-v2
  FILES:=$(LINUX_DIR)/drivers/media/tuners/r820t.ko
  AUTOLOAD:=$(call AutoLoad,82,r820t)
endef
define KernelPackage/dvb-tuner-r820t/description
  Kernel module for Rafael Micro R820T tuner
endef
$(eval $(call KernelPackage,dvb-tuner-r820t))

define KernelPackage/dvb-frontend-mn88472
  SUBMENU:=$(MMEDIA_MENU)
  TITLE:=DVB-T Panasonic MN88472 (no firmware)
  KCONFIG:=CONFIG_DVB_MN88472=m
  DEPENDS:=+kmod-regmap-i2c kmod-dvb-usb-v2
  FILES:=$(LINUX_DIR)/drivers/media/dvb-frontends/mn88472.ko
  AUTOLOAD:=$(call AutoLoad,83,mn88472)
endef
define KernelPackage/dvb-frontend-mn88472/description
  Kernel module for Panasonic MN88472 DVB-T/T2/C frontend

  This chip requires firmware! It is not included due to missing licence.
  Firmware file: dvb-demod-mn88472-02.fw
  Install in: /lib/firmware
endef
$(eval $(call KernelPackage,dvb-frontend-mn88472))

define KernelPackage/dvb-frontend-mn88473
  SUBMENU:=$(MMEDIA_MENU)
  TITLE:=DVB-T Panasonic MN88473 (no firmware)
  KCONFIG:=CONFIG_DVB_MN88473=m
  DEPENDS:=+kmod-regmap-i2c kmod-dvb-usb-v2
  FILES:=$(LINUX_DIR)/drivers/media/dvb-frontends/mn88473.ko
  AUTOLOAD:=$(call AutoLoad,83,mn88473)
endef
define KernelPackage/dvb-frontend-mn88473/description
  Kernel module for Panasonic MN88473 DVB-T/T2/C frontend

  This chip requires firmware! It is not included due to missing licence.
  Firmware file: dvb-demod-mn88473-01.fw
  Install in: /lib/firmware
endef
$(eval $(call KernelPackage,dvb-frontend-mn88473))

define KernelPackage/dvb-frontend-cxd2841er
  SUBMENU:=$(MMEDIA_MENU)
  TITLE:=DVB-C Sony CXD2841ER
  KCONFIG:=CONFIG_DVB_CXD2841ER=m
  DEPENDS:=kmod-dvb-usb-v2
  FILES:=$(LINUX_DIR)/drivers/media/dvb-frontends/cxd2841er.ko
  AUTOLOAD:=$(call AutoLoad,83,cxd2841er)
endef
define KernelPackage/dvb-frontend-cxd2841er/description
  Kernel module for Sony CXD2841ER DVB-C frontend
endef
$(eval $(call KernelPackage,dvb-frontend-cxd2841er))

define KernelPackage/dvb-usb-rtl28xx
  SUBMENU:=$(MMEDIA_MENU)
  TITLE:=DVB USB Realtek RTL28xx
  KCONFIG:= \
	CONFIG_DVB_USB_RTL28XXU=m \
	CONFIG_DVB_RTL2830=m \
	CONFIG_DVB_RTL2832=m
  DEPENDS:=+kmod-i2c-mux +kmod-regmap-i2c kmod-dvb-usb-v2
  FILES:= \
	$(LINUX_DIR)/drivers/media/usb/dvb-usb-v2/dvb-usb-rtl28xxu.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/rtl2830.ko \
	$(LINUX_DIR)/drivers/media/dvb-frontends/rtl2832.ko
  AUTOLOAD:=$(call AutoLoad,83,rtl2830)
  AUTOLOAD:=$(call AutoLoad,83,rtl2832)
  AUTOLOAD:=$(call AutoLoad,89,dvb-usb-rtl28xxu)
# rtl28xxu must load after these frontends: MN88472, MN88473, CXD2841ER, RTL2830, RTL2832, R820T, and others not yet added in OpenWrt (see kernel menuconfig help for this module)
endef
define KernelPackage/dvb-usb-rtl28xx/description
  Kernel modules for RTL28xxU USB DVB demod and RTL2830 & RTL2832 DVB-T frontends
endef
$(eval $(call KernelPackage,dvb-usb-rtl28xx))


# CAMERAS

define KernelPackage/video-core
  SUBMENU:=$(MMEDIA_MENU)
  TITLE=Video4Linux support
  DEPENDS:=+PACKAGE_kmod-i2c-core:kmod-i2c-core kmod-multimedia
  KCONFIG:= \
	CONFIG_MEDIA_CAMERA_SUPPORT=y \
	CONFIG_VIDEO_DEV \
	CONFIG_V4L_PLATFORM_DRIVERS=y
  FILES:= \
	$(LINUX_DIR)/drivers/media/v4l2-core/videodev.ko
  AUTOLOAD:=$(call AutoLoad,81, videodev v4l2-common)
endef

define KernelPackage/video-core/description
 Kernel modules for Video4Linux support
endef

$(eval $(call KernelPackage,video-core))


define AddDepends/video
  SUBMENU:=$(MMEDIA_MENU)
  DEPENDS+=kmod-video-core $(1)
endef

define AddDepends/camera
$(AddDepends/video)
  KCONFIG+=CONFIG_MEDIA_CAMERA_SUPPORT=y
endef

define AddDepends/framegrabber
$(AddDepends/video)
  KCONFIG+=CONFIG_MEDIA_PCI_SUPPORT=y
endef

define KernelPackage/video-videobuf2
  TITLE:=videobuf2 lib
  DEPENDS:=+kmod-dma-buf
  KCONFIG:= \
	CONFIG_VIDEOBUF2_CORE \
	CONFIG_VIDEOBUF2_MEMOPS \
	CONFIG_VIDEOBUF2_VMALLOC
  FILES:= \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-common.ko \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-v4l2.ko \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-memops.ko \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-vmalloc.ko
  AUTOLOAD:=$(call AutoLoad,82,videobuf2-core videobuf-v4l2 videobuf2-memops videobuf2-vmalloc)
  $(call AddDepends/video)
endef

define KernelPackage/video-videobuf2/description
 Kernel modules that implements three basic types of media buffers.
endef

$(eval $(call KernelPackage,video-videobuf2))


define KernelPackage/video-cpia2
  TITLE:=CPIA2 video driver
  DEPENDS:=@USB_SUPPORT +kmod-usb-core
  KCONFIG:=CONFIG_VIDEO_CPIA2
  FILES:=$(LINUX_DIR)/drivers/media/usb/cpia2/cpia2.ko
  AUTOLOAD:=$(call AutoProbe,cpia2)
  $(call AddDepends/camera)
endef

define KernelPackage/video-cpia2/description
 Kernel modules for supporting CPIA2 USB based cameras
endef

$(eval $(call KernelPackage,video-cpia2))


define KernelPackage/video-pwc
  TITLE:=Philips USB webcam support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2
  KCONFIG:= \
	CONFIG_USB_PWC \
	CONFIG_USB_PWC_DEBUG=n
  FILES:=$(LINUX_DIR)/drivers/media/usb/pwc/pwc.ko
  AUTOLOAD:=$(call AutoProbe,pwc)
  $(call AddDepends/camera)
endef

define KernelPackage/video-pwc/description
 Kernel modules for supporting Philips USB based cameras
endef

$(eval $(call KernelPackage,video-pwc))


define KernelPackage/video-uvc
  TITLE:=USB Video Class (UVC) support
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-video-videobuf2 +kmod-input-core
  KCONFIG:= CONFIG_USB_VIDEO_CLASS
  FILES:=$(LINUX_DIR)/drivers/media/usb/uvc/uvcvideo.ko
  AUTOLOAD:=$(call AutoProbe,uvcvideo)
  $(call AddDepends/camera)
endef

define KernelPackage/video-uvc/description
 Kernel modules for supporting USB Video Class (UVC) devices
endef

$(eval $(call KernelPackage,video-uvc))


define KernelPackage/video-gspca-core
  MENU:=1
  TITLE:=GSPCA webcam core support framework
  DEPENDS:=@USB_SUPPORT +kmod-usb-core +kmod-input-core +kmod-video-videobuf2
  KCONFIG:=CONFIG_USB_GSPCA
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_main.ko
  AUTOLOAD:=$(call AutoProbe,gspca_main)
  $(call AddDepends/camera)
endef

define KernelPackage/video-gspca-core/description
 Kernel modules for supporting GSPCA based webcam devices. Note this is just
 the core of the driver, please select a submodule that supports your webcam.
endef

$(eval $(call KernelPackage,video-gspca-core))


define AddDepends/camera-gspca
  SUBMENU:=$(MMEDIA_MENU)
  DEPENDS+=kmod-video-gspca-core $(1)
endef


define KernelPackage/video-gspca-conex
  TITLE:=conex webcam support
  KCONFIG:=CONFIG_USB_GSPCA_CONEX
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_conex.ko
  AUTOLOAD:=$(call AutoProbe,gspca_conex)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-conex/description
 The Conexant Camera Driver (conex) kernel module
endef

$(eval $(call KernelPackage,video-gspca-conex))


define KernelPackage/video-gspca-etoms
  TITLE:=etoms webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ETOMS
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_etoms.ko
  AUTOLOAD:=$(call AutoProbe,gspca_etoms)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-etoms/description
 The Etoms USB Camera Driver (etoms) kernel module
endef

$(eval $(call KernelPackage,video-gspca-etoms))


define KernelPackage/video-gspca-finepix
  TITLE:=finepix webcam support
  KCONFIG:=CONFIG_USB_GSPCA_FINEPIX
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_finepix.ko
  AUTOLOAD:=$(call AutoProbe,gspca_finepix)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-finepix/description
 The Fujifilm FinePix USB V4L2 driver (finepix) kernel module
endef

$(eval $(call KernelPackage,video-gspca-finepix))


define KernelPackage/video-gspca-mars
  TITLE:=mars webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MARS
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_mars.ko
  AUTOLOAD:=$(call AutoProbe,gspca_mars)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mars/description
 The Mars USB Camera Driver (mars) kernel module
endef

$(eval $(call KernelPackage,video-gspca-mars))


define KernelPackage/video-gspca-mr97310a
  TITLE:=mr97310a webcam support
  KCONFIG:=CONFIG_USB_GSPCA_MR97310A
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_mr97310a.ko
  AUTOLOAD:=$(call AutoProbe,gspca_mr97310a)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-mr97310a/description
 The Mars-Semi MR97310A USB Camera Driver (mr97310a) kernel module
endef

$(eval $(call KernelPackage,video-gspca-mr97310a))


define KernelPackage/video-gspca-ov519
  TITLE:=ov519 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV519
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_ov519.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov519)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov519/description
 The OV519 USB Camera Driver (ov519) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov519))


define KernelPackage/video-gspca-ov534
  TITLE:=ov534 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_ov534.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov534)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534/description
 The OV534 USB Camera Driver (ov534) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov534))


define KernelPackage/video-gspca-ov534-9
  TITLE:=ov534-9 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_OV534_9
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_ov534_9.ko
  AUTOLOAD:=$(call AutoProbe,gspca_ov534_9)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-ov534-9/description
 The OV534-9 USB Camera Driver (ov534_9) kernel module
endef

$(eval $(call KernelPackage,video-gspca-ov534-9))


define KernelPackage/video-gspca-pac207
  TITLE:=pac207 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC207
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_pac207.ko
  AUTOLOAD:=$(call AutoProbe,gspca_pac207)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac207/description
 The Pixart PAC207 USB Camera Driver (pac207) kernel module
endef

$(eval $(call KernelPackage,video-gspca-pac207))


define KernelPackage/video-gspca-pac7311
  TITLE:=pac7311 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_PAC7311
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_pac7311.ko
  AUTOLOAD:=$(call AutoProbe,gspca_pac7311)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-pac7311/description
 The Pixart PAC7311 USB Camera Driver (pac7311) kernel module
endef

$(eval $(call KernelPackage,video-gspca-pac7311))


define KernelPackage/video-gspca-se401
  TITLE:=se401 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SE401
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_se401.ko
  AUTOLOAD:=$(call AutoProbe,gspca_se401)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-se401/description
 The SE401 USB Camera Driver kernel module
endef

$(eval $(call KernelPackage,video-gspca-se401))


define KernelPackage/video-gspca-sn9c20x
  TITLE:=sn9c20x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SN9C20X
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_sn9c20x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sn9c20x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sn9c20x/description
 The SN9C20X USB Camera Driver (sn9c20x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sn9c20x))


define KernelPackage/video-gspca-sonixb
  TITLE:=sonixb webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXB
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_sonixb.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sonixb)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixb/description
 The SONIX Bayer USB Camera Driver (sonixb) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sonixb))


define KernelPackage/video-gspca-sonixj
  TITLE:=sonixj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SONIXJ
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_sonixj.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sonixj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sonixj/description
 The SONIX JPEG USB Camera Driver (sonixj) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sonixj))


define KernelPackage/video-gspca-spca500
  TITLE:=spca500 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA500
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_spca500.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca500)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca500/description
 The SPCA500 USB Camera Driver (spca500) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca500))


define KernelPackage/video-gspca-spca501
  TITLE:=spca501 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA501
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_spca501.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca501)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca501/description
 The SPCA501 USB Camera Driver (spca501) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca501))


define KernelPackage/video-gspca-spca505
  TITLE:=spca505 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA505
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_spca505.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca505)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca505/description
 The SPCA505 USB Camera Driver (spca505) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca505))


define KernelPackage/video-gspca-spca506
  TITLE:=spca506 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA506
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_spca506.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca506)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca506/description
 The SPCA506 USB Camera Driver (spca506) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca506))


define KernelPackage/video-gspca-spca508
  TITLE:=spca508 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA508
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_spca508.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca508)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca508/description
 The SPCA508 USB Camera Driver (spca508) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca508))


define KernelPackage/video-gspca-spca561
  TITLE:=spca561 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SPCA561
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_spca561.ko
  AUTOLOAD:=$(call AutoProbe,gspca_spca561)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-spca561/description
 The SPCA561 USB Camera Driver (spca561) kernel module
endef

$(eval $(call KernelPackage,video-gspca-spca561))


define KernelPackage/video-gspca-sq905
  TITLE:=sq905 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_sq905.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq905)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905/description
 The SQ Technologies SQ905 based USB Camera Driver (sq905) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq905))


define KernelPackage/video-gspca-sq905c
  TITLE:=sq905c webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ905C
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_sq905c.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq905c)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq905c/description
 The SQ Technologies SQ905C based USB Camera Driver (sq905c) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq905c))


define KernelPackage/video-gspca-sq930x
  TITLE:=sq930x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SQ930X
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_sq930x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sq930x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sq930x/description
 The SQ Technologies SQ930X based USB Camera Driver (sq930x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sq930x))


define KernelPackage/video-gspca-stk014
  TITLE:=stk014 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_STK014
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_stk014.ko
  AUTOLOAD:=$(call AutoProbe,gspca_stk014)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stk014/description
 The Syntek DV4000 (STK014) USB Camera Driver (stk014) kernel module
endef

$(eval $(call KernelPackage,video-gspca-stk014))


define KernelPackage/video-gspca-sunplus
  TITLE:=sunplus webcam support
  KCONFIG:=CONFIG_USB_GSPCA_SUNPLUS
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_sunplus.ko
  AUTOLOAD:=$(call AutoProbe,gspca_sunplus)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-sunplus/description
 The SUNPLUS USB Camera Driver (sunplus) kernel module
endef

$(eval $(call KernelPackage,video-gspca-sunplus))


define KernelPackage/video-gspca-t613
  TITLE:=t613 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_T613
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_t613.ko
  AUTOLOAD:=$(call AutoProbe,gspca_t613)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-t613/description
 The T613 (JPEG Compliance) USB Camera Driver (t613) kernel module
endef

$(eval $(call KernelPackage,video-gspca-t613))


define KernelPackage/video-gspca-tv8532
  TITLE:=tv8532 webcam support
  KCONFIG:=CONFIG_USB_GSPCA_TV8532
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_tv8532.ko
  AUTOLOAD:=$(call AutoProbe,gspca_tv8532)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-tv8532/description
 The TV8532 USB Camera Driver (tv8532) kernel module
endef

$(eval $(call KernelPackage,video-gspca-tv8532))


define KernelPackage/video-gspca-vc032x
  TITLE:=vc032x webcam support
  KCONFIG:=CONFIG_USB_GSPCA_VC032X
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_vc032x.ko
  AUTOLOAD:=$(call AutoProbe,gspca_vc032x)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-vc032x/description
 The VC032X USB Camera Driver (vc032x) kernel module
endef

$(eval $(call KernelPackage,video-gspca-vc032x))


define KernelPackage/video-gspca-zc3xx
  TITLE:=zc3xx webcam support
  KCONFIG:=CONFIG_USB_GSPCA_ZC3XX
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_zc3xx.ko
  AUTOLOAD:=$(call AutoProbe,gspca_zc3xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-zc3xx/description
 The ZC3XX USB Camera Driver (zc3xx) kernel module
endef

$(eval $(call KernelPackage,video-gspca-zc3xx))


define KernelPackage/video-gspca-m5602
  TITLE:=m5602 webcam support
  KCONFIG:=CONFIG_USB_M5602
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/m5602/gspca_m5602.ko
  AUTOLOAD:=$(call AutoProbe,gspca_m5602)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-m5602/description
 The ALi USB m5602 Camera Driver (m5602) kernel module
endef

$(eval $(call KernelPackage,video-gspca-m5602))


define KernelPackage/video-gspca-stv06xx
  TITLE:=stv06xx webcam support
  KCONFIG:=CONFIG_USB_STV06XX
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/stv06xx/gspca_stv06xx.ko
  AUTOLOAD:=$(call AutoProbe,gspca_stv06xx)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-stv06xx/description
 The STV06XX USB Camera Driver (stv06xx) kernel module
endef

$(eval $(call KernelPackage,video-gspca-stv06xx))


define KernelPackage/video-gspca-gl860
  TITLE:=gl860 webcam support
  KCONFIG:=CONFIG_USB_GL860
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gl860/gspca_gl860.ko
  AUTOLOAD:=$(call AutoProbe,gspca_gl860)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-gl860/description
 The GL860 USB Camera Driver (gl860) kernel module
endef

$(eval $(call KernelPackage,video-gspca-gl860))


define KernelPackage/video-gspca-jeilinj
  TITLE:=jeilinj webcam support
  KCONFIG:=CONFIG_USB_GSPCA_JEILINJ
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_jeilinj.ko
  AUTOLOAD:=$(call AutoProbe,gspca_jeilinj)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-jeilinj/description
 The JEILINJ USB Camera Driver (jeilinj) kernel module
endef

$(eval $(call KernelPackage,video-gspca-jeilinj))


define KernelPackage/video-gspca-konica
  TITLE:=konica webcam support
  KCONFIG:=CONFIG_USB_GSPCA_KONICA
  FILES:=$(LINUX_DIR)/drivers/media/usb/gspca/gspca_konica.ko
  AUTOLOAD:=$(call AutoProbe,gspca_konica)
  $(call AddDepends/camera-gspca)
endef

define KernelPackage/video-gspca-konica/description
 The Konica USB Camera Driver (konica) kernel module
endef

$(eval $(call KernelPackage,video-gspca-konica))

#
# Video Processing
#

define KernelPackage/video-mem2mem
  SUBMENU:=$(MMEDIA_MENU)
  TITLE:=Memory 2 Memory device support
  HIDDEN:=1
  DEPENDS:=+kmod-video-videobuf2
  KCONFIG:= CONFIG_V4L_MEM2MEM_DRIVERS=y
  FILES:= $(LINUX_DIR)/drivers/media/v4l2-core/v4l2-mem2mem.ko
  AUTOLOAD:=$(call AutoLoad,83,v4l2-mem2mem)
  $(call AddDepends/video)
endef

define KernelPackage/video-mem2mem/description
  Memory 2 memory device support
endef

$(eval $(call KernelPackage,video-mem2mem))

define KernelPackage/video-dma
  SUBMENU:=$(MMEDIA_MENU)
  TITLE:=Video DMA support
  HIDDEN:=1
  DEPENDS:=+kmod-video-videobuf2
  KCONFIG:= \
	CONFIG_VIDEOBUF2_DMA_CONTIG \
	CONFIG_VIDEOBUF2_DMA_SG
  FILES:= \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dma-contig.ko \
	$(wildcard $(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dma-sg.ko)
  AUTOLOAD:=$(call AutoLoad,83,videobuf2-dma-contig videobuf2-dma-sg)
  $(call AddDepends/video)
endef

define KernelPackage/video-dma/description
  Video DMA support
endef

$(eval $(call KernelPackage,video-dma))

define KernelPackage/video-coda
  TITLE:=i.MX VPU support
  DEPENDS:=@(TARGET_imx&&!TARGET_imx_cortexa7) +kmod-video-mem2mem +kmod-video-dma
  KCONFIG:= \
  	CONFIG_VIDEO_CODA \
  	CONFIG_VIDEO_IMX_VDOA
  FILES:= \
  	$(LINUX_DIR)/drivers/media/platform/coda/coda-vpu.ko \
  	$(LINUX_DIR)/drivers/media/platform/coda/imx-vdoa.ko \
 	$(LINUX_DIR)/drivers/media/v4l2-core/v4l2-jpeg.ko
  AUTOLOAD:=$(call AutoProbe,coda-vpu imx-vdoa v4l2-jpeg)
  $(call AddDepends/video)
endef

define KernelPackage/video-coda/description
 The i.MX Video Processing Unit (VPU) kernel module
endef

$(eval $(call KernelPackage,video-coda))

define KernelPackage/video-pxp
  TITLE:=i.MX PXP support
  DEPENDS:=@TARGET_imx +kmod-video-mem2mem +kmod-video-dma
  KCONFIG:= CONFIG_VIDEO_IMX_PXP
  FILES:= $(LINUX_DIR)/drivers/media/platform/imx-pxp.ko
  AUTOLOAD:=$(call AutoProbe,imx-pxp)
  $(call AddDepends/video)
endef

define KernelPackage/video-pxp/description
 The i.MX Pixel Pipeline (PXP) kernel module
 This enables hardware accelerated support for image
 Colour Conversion, Scaling and Rotation
endef

$(eval $(call KernelPackage,video-pxp))

define KernelPackage/video-tw686x
  TITLE:=TW686x support
  DEPENDS:=@PCIE_SUPPORT +kmod-video-dma +kmod-sound-core
  KCONFIG:= CONFIG_VIDEO_TW686X
  FILES:= $(LINUX_DIR)/drivers/media/pci/tw686x/tw686x.ko
  AUTOLOAD:=$(call AutoProbe,tw686x)
  MODPARAMS.tw686x:=dma_mode=contig
  $(call AddDepends/framegrabber)
endef

define KernelPackage/video-tw686x/description
 The Intersil/Techwell TW686x kernel module
endef

$(eval $(call KernelPackage,video-tw686x))
