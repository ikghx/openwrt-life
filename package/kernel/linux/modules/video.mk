#
# Copyright (C) 2009 David Cooper <dave@kupesoft.com>
# Copyright (C) 2006-2010 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

VIDEO_MENU:=Video Support

define KernelPackage/backlight
	SUBMENU:=$(VIDEO_MENU)
	TITLE:=Backlight support
	DEPENDS:=@DISPLAY_SUPPORT
	HIDDEN:=1
	KCONFIG:=CONFIG_BACKLIGHT_CLASS_DEVICE \
		CONFIG_BACKLIGHT_LCD_SUPPORT=y \
		CONFIG_LCD_CLASS_DEVICE=n \
		CONFIG_BACKLIGHT_GENERIC=n \
		CONFIG_BACKLIGHT_ADP8860=n \
		CONFIG_BACKLIGHT_ADP8870=n \
		CONFIG_BACKLIGHT_OT200=n \
		CONFIG_BACKLIGHT_PM8941_WLED=n
	FILES:=$(LINUX_DIR)/drivers/video/backlight/backlight.ko
	AUTOLOAD:=$(call AutoProbe,video backlight)
endef

define KernelPackage/backlight/description
	Kernel module for Backlight support.
endef

$(eval $(call KernelPackage,backlight))

define KernelPackage/backlight-pwm
	SUBMENU:=$(VIDEO_MENU)
	TITLE:=PWM Backlight support
	DEPENDS:=+kmod-backlight
	KCONFIG:=CONFIG_BACKLIGHT_PWM
	FILES:=$(LINUX_DIR)/drivers/video/backlight/pwm_bl.ko
	AUTOLOAD:=$(call AutoProbe,video pwm_bl)
endef

define KernelPackage/backlight-pwm/description
	Kernel module for PWM based Backlight support.
endef

$(eval $(call KernelPackage,backlight-pwm))


define KernelPackage/fb
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer and framebuffer console support
  DEPENDS:=@DISPLAY_SUPPORT
  KCONFIG:= \
	CONFIG_FB \
	CONFIG_FB_MXS=n \
	CONFIG_FB_SM750=n \
	CONFIG_FRAMEBUFFER_CONSOLE=y \
	CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y \
	CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y \
	CONFIG_FONTS=y \
	CONFIG_FONT_8x8=y \
	CONFIG_FONT_8x16=y \
	CONFIG_FONT_6x11=n \
	CONFIG_FONT_7x14=n \
	CONFIG_FONT_PEARL_8x8=n \
	CONFIG_FONT_ACORN_8x8=n \
	CONFIG_FONT_MINI_4x6=n \
	CONFIG_FONT_6x10=n \
	CONFIG_FONT_SUN8x16=n \
	CONFIG_FONT_SUN12x22=n \
	CONFIG_FONT_10x18=n \
	CONFIG_VT=y \
	CONFIG_CONSOLE_TRANSLATIONS=y \
	CONFIG_VT_CONSOLE=y \
	CONFIG_VT_HW_CONSOLE_BINDING=y
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/fb.ko \
	$(LINUX_DIR)/lib/fonts/font.ko
  AUTOLOAD:=$(call AutoLoad,06,fb font)
endef

define KernelPackage/fb/description
 Kernel support for framebuffers and framebuffer console.
endef

define KernelPackage/fb/x86
  FILES+=$(LINUX_DIR)/arch/x86/video/fbdev.ko
  AUTOLOAD:=$(call AutoLoad,06,fbdev fb font)
endef

$(eval $(call KernelPackage,fb))


define KernelPackage/fb-cfb-fillrect
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software rectangle filling support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_FILLRECT
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/cfbfillrect.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbfillrect)
endef

define KernelPackage/fb-cfb-fillrect/description
 Kernel support for software rectangle filling
endef

$(eval $(call KernelPackage,fb-cfb-fillrect))


define KernelPackage/fb-cfb-copyarea
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software copy area support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_COPYAREA
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/cfbcopyarea.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbcopyarea)
endef

define KernelPackage/fb-cfb-copyarea/description
 Kernel support for software copy area
endef

$(eval $(call KernelPackage,fb-cfb-copyarea))

define KernelPackage/fb-cfb-imgblt
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software image blit support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_CFB_IMAGEBLIT
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/cfbimgblt.ko
  AUTOLOAD:=$(call AutoLoad,07,cfbimgblt)
endef

define KernelPackage/fb-cfb-imgblt/description
 Kernel support for software image blitting
endef

$(eval $(call KernelPackage,fb-cfb-imgblt))


define KernelPackage/fb-sys-fops
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer software sys ops support
  DEPENDS:=+kmod-fb
  KCONFIG:=CONFIG_FB_SYS_FOPS
  FILES:=$(LINUX_DIR)/drivers/video/fbdev/core/fb_sys_fops.ko
  AUTOLOAD:=$(call AutoLoad,07,fb_sys_fops)
endef

define KernelPackage/fb-sys-fops/description
 Kernel support for framebuffer sys ops
endef

$(eval $(call KernelPackage,fb-sys-fops))


define KernelPackage/fb-sys-ram
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Framebuffer in system RAM support
  DEPENDS:=+kmod-fb
  KCONFIG:= \
	CONFIG_FB_SYS_COPYAREA \
	CONFIG_FB_SYS_FILLRECT \
	CONFIG_FB_SYS_IMAGEBLIT
  FILES:= \
	$(LINUX_DIR)/drivers/video/fbdev/core/syscopyarea.ko \
	$(LINUX_DIR)/drivers/video/fbdev/core/sysfillrect.ko \
	$(LINUX_DIR)/drivers/video/fbdev/core/sysimgblt.ko
  AUTOLOAD:=$(call AutoLoad,07,syscopyarea sysfillrect sysimgblt)
endef

define KernelPackage/fb-sys-ram/description
 Kernel support for framebuffers in system RAM
endef

$(eval $(call KernelPackage,fb-sys-ram))


define KernelPackage/fb-tft
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Support for small TFT LCD display modules
  DEPENDS:= \
	  @GPIO_SUPPORT +kmod-backlight \
	  +kmod-fb +kmod-fb-sys-fops +kmod-fb-sys-ram +kmod-spi-bitbang
  KCONFIG:= \
       CONFIG_FB_BACKLIGHT=y \
       CONFIG_FB_DEFERRED_IO=y \
       CONFIG_FB_TFT
  FILES:= \
       $(LINUX_DIR)/drivers/staging/fbtft/fbtft.ko
  AUTOLOAD:=$(call AutoLoad,08,fbtft)
endef

define KernelPackage/fb-tft/description
  Support for small TFT LCD display modules
endef

$(eval $(call KernelPackage,fb-tft))


define KernelPackage/fb-tft-ili9486
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=FB driver for the ILI9486 LCD Controller
  DEPENDS:=+kmod-fb-tft
  KCONFIG:=CONFIG_FB_TFT_ILI9486
  FILES:=$(LINUX_DIR)/drivers/staging/fbtft/fb_ili9486.ko
  AUTOLOAD:=$(call AutoLoad,09,fb_ili9486)
endef

define KernelPackage/fb-tft-ili9486/description
  FB driver for the ILI9486 LCD Controller
endef

$(eval $(call KernelPackage,fb-tft-ili9486))


define KernelPackage/multimedia-input
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Multimedia input support
  DEPENDS:=+kmod-input-core
  KCONFIG:=CONFIG_RC_CORE \
	CONFIG_LIRC=y \
	CONFIG_RC_DECODERS=y \
	CONFIG_RC_DEVICES=y
  FILES:=$(LINUX_DIR)/drivers/media/rc/rc-core.ko
  AUTOLOAD:=$(call AutoProbe,rc-core)
endef

define KernelPackage/multimedia-input/description
  Enable multimedia input.
endef

$(eval $(call KernelPackage,multimedia-input))


define KernelPackage/drm
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Direct Rendering Manager (DRM) support
  HIDDEN:=1
  DEPENDS:=+kmod-dma-buf +kmod-i2c-core +kmod-i2c-algo-bit +kmod-backlight
  KCONFIG:= \
	CONFIG_DRM \
	CONFIG_DRM_PANEL_ORIENTATION_QUIRKS=y \
	CONFIG_DRM_FBDEV_EMULATION=y \
	CONFIG_DRM_FBDEV_OVERALLOC=100 \
	CONFIG_HDMI
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/drm.ko
  AUTOLOAD:=$(call AutoLoad,05,drm)
endef

define KernelPackage/drm/description
  Direct Rendering Manager (DRM) core support
endef

$(eval $(call KernelPackage,drm))

define KernelPackage/drm-ttm
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=GPU memory management subsystem
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm
  KCONFIG:=CONFIG_DRM_TTM
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/ttm/ttm.ko
  AUTOLOAD:=$(call AutoProbe,ttm)
endef

define KernelPackage/drm-ttm/description
  GPU memory management subsystem for devices with multiple GPU memory types.
  Will be enabled automatically if a device driver uses it.
endef

$(eval $(call KernelPackage,drm-ttm))


define KernelPackage/drm-ttm-helper
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Helpers for ttm-based gem objects
  HIDDEN:=1
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm-ttm
  KCONFIG:=CONFIG_DRM_TTM_HELPER
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_ttm_helper.ko
  AUTOLOAD:=$(call AutoProbe,drm_ttm_helper)
endef

$(eval $(call KernelPackage,drm-ttm-helper))


define KernelPackage/drm-kms-helper
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=CRTC helpers for KMS drivers
  DEPENDS:=@DISPLAY_SUPPORT +kmod-drm +kmod-fb +kmod-fb-sys-fops +kmod-fb-cfb-copyarea \
	+kmod-fb-cfb-fillrect +kmod-fb-cfb-imgblt +kmod-fb-sys-ram
  KCONFIG:= \
	CONFIG_DRM_KMS_HELPER \
	CONFIG_DRM_KMS_FB_HELPER=y
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/drm_kms_helper.ko
  AUTOLOAD:=$(call AutoProbe,drm_kms_helper)
endef

define KernelPackage/drm-kms-helper/description
  CRTC helpers for KMS drivers.
endef

$(eval $(call KernelPackage,drm-kms-helper))

define KernelPackage/drm-amdgpu
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=AMDGPU DRM support
  DEPENDS:=@TARGET_x86 @DISPLAY_SUPPORT +kmod-backlight +kmod-drm-ttm \
	+kmod-drm-ttm-helper +kmod-drm-kms-helper +kmod-i2c-algo-bit +amdgpu-firmware
  KCONFIG:=CONFIG_DRM_AMDGPU \
	CONFIG_DRM_AMDGPU_SI=y \
	CONFIG_DRM_AMDGPU_CIK=y \
	CONFIG_DRM_AMD_DC=y \
	CONFIG_DEBUG_KERNEL_DC=n
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/amd/amdgpu/amdgpu.ko \
	$(LINUX_DIR)/drivers/gpu/drm/scheduler/gpu-sched.ko
  AUTOLOAD:=$(call AutoProbe,amdgpu)
endef

define KernelPackage/drm-amdgpu/description
  Direct Rendering Manager (DRM) support for AMDGPU Cards
endef

$(eval $(call KernelPackage,drm-amdgpu))


define KernelPackage/drm-imx
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Freescale i.MX DRM support
  DEPENDS:=@TARGET_imx +kmod-drm-kms-helper
  KCONFIG:=CONFIG_DRM_IMX \
	CONFIG_IMX_IPUV3_CORE \
	CONFIG_RESET_CONTROLLER=y \
	CONFIG_DRM_IMX_IPUV3 \
	CONFIG_IMX_IPUV3 \
	CONFIG_DRM_GEM_CMA_HELPER=y \
	CONFIG_DRM_KMS_CMA_HELPER=y \
	CONFIG_DRM_IMX_FB_HELPER \
	CONFIG_DRM_IMX_PARALLEL_DISPLAY=n \
	CONFIG_DRM_IMX_TVE=n \
	CONFIG_DRM_IMX_LDB=n \
	CONFIG_DRM_IMX_HDMI=n
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/imx/imxdrm.ko \
	$(LINUX_DIR)/drivers/gpu/ipu-v3/imx-ipu-v3.ko
  AUTOLOAD:=$(call AutoLoad,08,imxdrm imx-ipu-v3 imx-ipuv3-crtc)
endef

define KernelPackage/drm-imx/description
  Direct Rendering Manager (DRM) support for Freescale i.MX
endef

$(eval $(call KernelPackage,drm-imx))

define KernelPackage/drm-imx-hdmi
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Freescale i.MX HDMI DRM support
  DEPENDS:=+kmod-sound-core kmod-drm-imx
  KCONFIG:=CONFIG_DRM_IMX_HDMI \
	CONFIG_DRM_DW_HDMI_AHB_AUDIO \
	CONFIG_DRM_DW_HDMI_I2S_AUDIO
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/bridge/synopsys/dw-hdmi.ko \
	$(LINUX_DIR)/drivers/gpu/drm/bridge/synopsys/dw-hdmi-ahb-audio.ko \
	$(LINUX_DIR)/drivers/gpu/drm/imx/dw_hdmi-imx.ko
  AUTOLOAD:=$(call AutoLoad,08,dw-hdmi dw-hdmi-ahb-audio.ko dw_hdmi-imx)
endef

define KernelPackage/drm-imx-hdmi/description
  Direct Rendering Manager (DRM) support for Freescale i.MX HDMI
endef

$(eval $(call KernelPackage,drm-imx-hdmi))

define KernelPackage/drm-imx-ldb
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Freescale i.MX LVDS DRM support
  DEPENDS:=+kmod-backlight kmod-drm-imx
  KCONFIG:=CONFIG_DRM_IMX_LDB \
	CONFIG_DRM_PANEL_SIMPLE \
	CONFIG_DRM_PANEL=y \
	CONFIG_DRM_PANEL_SAMSUNG_LD9040=n \
	CONFIG_DRM_PANEL_SAMSUNG_S6E8AA0=n \
	CONFIG_DRM_PANEL_LG_LG4573=n \
	CONFIG_DRM_PANEL_LD9040=n \
	CONFIG_DRM_PANEL_LVDS=n \
	CONFIG_DRM_PANEL_S6E8AA0=n \
	CONFIG_DRM_PANEL_SITRONIX_ST7789V=n
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/imx/imx-ldb.ko \
	$(LINUX_DIR)/drivers/gpu/drm/panel/panel-simple.ko \
	$(LINUX_DIR)/drivers/gpu/drm/drm_dp_aux_bus.ko
  AUTOLOAD:=$(call AutoLoad,08,imx-ldb)
endef

define KernelPackage/drm-imx-ldb/description
  Direct Rendering Manager (DRM) support for Freescale i.MX LVDS
endef

$(eval $(call KernelPackage,drm-imx-ldb))

define KernelPackage/drm-lima
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Mali-4xx GPU support
  DEPENDS:=@(TARGET_rockchip||TARGET_sunxi) +kmod-drm
  KCONFIG:= \
	CONFIG_DRM_VGEM \
	CONFIG_DRM_GEM_CMA_HELPER=y \
	CONFIG_DRM_LIMA
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/vgem/vgem.ko \
	$(LINUX_DIR)/drivers/gpu/drm/scheduler/gpu-sched.ko \
	$(LINUX_DIR)/drivers/gpu/drm/lima/lima.ko
  AUTOLOAD:=$(call AutoProbe,lima vgem)
endef

define KernelPackage/drm-lima/description
  Open-source reverse-engineered driver for Mali-4xx GPUs
endef

$(eval $(call KernelPackage,drm-lima))

define KernelPackage/drm-panfrost
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=DRM support for ARM Mali Midgard/Bifrost GPUs
  DEPENDS:=@(TARGET_rockchip||TARGET_sunxi) +kmod-drm
  KCONFIG:=CONFIG_DRM_PANFROST
  FILES:= \
	$(LINUX_DIR)/drivers/gpu/drm/panfrost/panfrost.ko \
	$(LINUX_DIR)/drivers/gpu/drm/scheduler/gpu-sched.ko
  AUTOLOAD:=$(call AutoProbe,panfrost)
endef

define KernelPackage/drm-panfrost/description
  DRM driver for ARM Mali Midgard (T6xx, T7xx, T8xx) and
  Bifrost (G3x, G5x, G7x) GPUs
endef

$(eval $(call KernelPackage,drm-panfrost))

define KernelPackage/drm-radeon
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Radeon DRM support
  DEPENDS:=@TARGET_x86 @DISPLAY_SUPPORT +kmod-backlight +kmod-drm-kms-helper \
	+kmod-drm-ttm +kmod-drm-ttm-helper +kmod-i2c-algo-bit +radeon-firmware
  KCONFIG:=CONFIG_DRM_RADEON
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/radeon/radeon.ko
  AUTOLOAD:=$(call AutoProbe,radeon)
endef

define KernelPackage/drm-radeon/description
  Direct Rendering Manager (DRM) support for Radeon Cards
endef

$(eval $(call KernelPackage,drm-radeon))

define KernelPackage/drm-i915
  SUBMENU:=$(VIDEO_MENU)
  TITLE:=Intel GPU drm support
  DEPENDS:=@TARGET_x86 +kmod-drm-ttm +kmod-drm-kms-helper +i915-firmware
  KCONFIG:= \
	CONFIG_INTEL_GTT=y \
	CONFIG_DRM_I915=m \
	CONFIG_DRM_I915_ALPHA_SUPPORT=n \
	CONFIG_DRM_I915_CAPTURE_ERROR=y \
	CONFIG_DRM_I915_COMPRESS_ERROR=y \
	CONFIG_DRM_I915_USERPTR=y \
	CONFIG_DRM_I915_GVT=n \
	CONFIG_DRM_I915_WERROR=n \
	CONFIG_DRM_I915_DEBUG=n \
	CONFIG_DRM_I915_DEBUG_MMIO=n \
	CONFIG_DRM_I915_SW_FENCE_DEBUG_OBJECTS=n \
	CONFIG_DRM_I915_SW_FENCE_CHECK_DAG=n \
	CONFIG_DRM_I915_DEBUG_GUC=n \
	CONFIG_DRM_I915_SELFTEST=n \
	CONFIG_DRM_I915_LOW_LEVEL_TRACEPOINTS=n \
	CONFIG_DRM_I915_DEBUG_VBLANK_EVADE=n \
	CONFIG_DRM_I915_DEBUG_RUNTIME_PM=n
  FILES:=$(LINUX_DIR)/drivers/gpu/drm/i915/i915.ko
  AUTOLOAD:=$(call AutoProbe,i915)
endef

define KernelPackage/drm-i915/description
  Direct Rendering Manager (DRM) support for "Intel Graphics
  Media Accelerator" or "HD Graphics" integrated graphics,
  including 830M, 845G, 852GM, 855GM, 865G, 915G, 945G, 965G,
  G35, G41, G43, G45 chipsets and Celeron, Pentium, Core i3,
  Core i5, Core i7 as well as Atom CPUs with integrated graphics.
endef

$(eval $(call KernelPackage,drm-i915))
