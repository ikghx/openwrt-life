#
# Copyright (C) 2006-2020 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=dropbear
PKG_VERSION:=2022.83
PKG_RELEASE:=2

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.bz2
PKG_SOURCE_URL:= \
	https://matt.ucc.asn.au/dropbear/releases/ \
	https://dropbear.nl/mirror/releases/
PKG_HASH:=bc5a121ffbc94b5171ad5ebe01be42746d50aa797c9549a4639894a16749443b

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE libtomcrypt/LICENSE libtommath/LICENSE
PKG_CPE_ID:=cpe:/a:matt_johnston:dropbear_ssh_server

PKG_BUILD_PARALLEL:=1
PKG_USE_MIPS16:=0
PKG_FIXUP:=autoreconf
PKG_FLAGS:=nonshared

# global hardening fixups
CONFIG_PKG_ASLR_PIE_REGULAR:=1
CONFIG_PKG_CC_STACKPROTECTOR_STRONG:=1
CONFIG_PKG_RELRO_FULL:=1
CONFIG_PKG_FORTIFY_SOURCE_2:=1
undefine CONFIG_PKG_ASLR_PIE_ALL
undefine CONFIG_PKG_CC_STACKPROTECTOR_REGULAR
undefine CONFIG_PKG_RELRO_PARTIAL
undefine CONFIG_PKG_FORTIFY_SOURCE_1
# package hardening fixups
PKG_ASLR_PIE_REGULAR:=1
PKG_SSP:=1
PKG_RELRO:=1
PKG_FORTIFY_SOURCE:=1
# switch from PIC to PIE
FPIC:=$(subst -fPIC,-fPIE,$(subst -fpic,-fpie,$(FPIC)))

PKG_CONFIG_DEPENDS:= \
	CONFIG_TARGET_INIT_PATH \
	CONFIG_DROPBEAR_MODERN_ONLY \
	CONFIG_DROPBEAR_CURVE25519 CONFIG_DROPBEAR_ECC CONFIG_DROPBEAR_ECC_FULL \
	CONFIG_DROPBEAR_ED25519 CONFIG_DROPBEAR_CHACHA20POLY1305 \
	CONFIG_DROPBEAR_U2F CONFIG_DROPBEAR_ECDSA_SK CONFIG_DROPBEAR_ED25519_SK \
	CONFIG_DROPBEAR_AGENTFORWARD CONFIG_DROPBEAR_ZLIB CONFIG_DROPBEAR_UTMP \
	CONFIG_DROPBEAR_PUTUTLINE CONFIG_DROPBEAR_SCP \
	CONFIG_DROPBEAR_DBCLIENT CONFIG_DROPBEAR_DBCLIENT_AGENTFORWARD \
	CONFIG_DROPBEAR_DBCLIENT_ASKPASS \


include $(INCLUDE_DIR)/package.mk

TARGET_CFLAGS += -DARGTYPE=3 -ffunction-sections -fdata-sections -flto=auto -ffat-lto-objects -Wl,-pie
TARGET_CFLAGS += $(if $(filter -Os,$(TARGET_CFLAGS)),-DLTC_SMALL_CODE,-DDROPBEAR_SMALL_CODE=0)
TARGET_LDFLAGS += -Wl,--gc-sections -flto=auto -ffat-lto-objects -pie

ifneq ($(DUMP),1)
  STAMP_CONFIGURED:=$(strip $(STAMP_CONFIGURED))_$(shell echo $(CONFIG_TARGET_INIT_PATH) | $(MKHASH) md5)
endif

define Package/dropbear/Default
  URL:=https://matt.ucc.asn.au/dropbear/
endef

define Package/dropbear/config
	source "$(SOURCE)/Config.in"
endef

define Package/dropbear
  $(call Package/dropbear/Default)
  SECTION:=net
  CATEGORY:=Base system
  TITLE:=Small SSH2 client/server
  DEPENDS:= +DROPBEAR_ZLIB:zlib
  ALTERNATIVES:=
  $(if $(CONFIG_DROPBEAR_SCP),ALTERNATIVES+= \
	  100:/usr/bin/scp:/usr/sbin/dropbear,)
  $(if $(CONFIG_DROPBEAR_DBCLIENT),ALTERNATIVES+= \
	  100:/usr/bin/ssh:/usr/sbin/dropbear,)

endef

define Package/dropbear/description
 A small SSH2 server/client designed for small memory environments.
endef

define Package/dropbear/conffiles
/etc/config/dropbear
/etc/dropbear/authorized_keys
/etc/dropbear/dropbear_ecdsa_host_key
/etc/dropbear/dropbear_ed25519_host_key
/etc/dropbear/dropbear_rsa_host_key
endef

define Package/dropbearconvert
  $(call Package/dropbear/Default)
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Utility for converting SSH keys
  DEPENDS:= +DROPBEAR_ZLIB:zlib
endef

CONFIGURE_ARGS += \
	--disable-pam \
	--enable-openpty \
	--enable-syslog \
	--disable-lastlog \
	--disable-utmpx \
	$(if $(CONFIG_DROPBEAR_UTMP),,--disable-utmp) \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-loginfunc \
	$(if $(CONFIG_DROPBEAR_PUTUTLINE),,--disable-pututline) \
	--disable-pututxline \
	$(if $(CONFIG_DROPBEAR_ZLIB),,--disable-zlib) \
	--enable-bundled-libtom

##############################################################################
#
#   option,value - add option to localoptions.h
# !!option,value - replace option in sysoptions.h
#
##############################################################################

# remove protocol idented software version number:
# - LOCAL_IDENT
# disable legacy/unsafe methods and unused functionality:
# - DO_MOTD
# - DROPBEAR_CLI_NETCAT
# - DROPBEAR_DH_GROUP14_SHA1
# - DROPBEAR_DSS (in both headers!)
# - DROPBEAR_RSA_SHA1
# - DROPBEAR_SHA1_HMAC
# adjust allowed shell list (if getusershell(3) is missing):
# - COMPAT_USER_SHELLS
DB_OPT_COMMON = \
	!!DROPBEAR_DSS,0 \
	!!LOCAL_IDENT,"SSH-2.0-dropbear" \
	COMPAT_USER_SHELLS,"/bin/ash","/bin/sh" \
	DEFAULT_PATH,"$(TARGET_INIT_PATH)" \
	DEFAULT_ROOT_PATH,"$(TARGET_INIT_PATH)" \
	DO_MOTD,0 \
	DROPBEAR_CLI_NETCAT,0 \
	DROPBEAR_DH_GROUP14_SHA1,0 \
	DROPBEAR_DSS,0 \
	DROPBEAR_RSA_SHA1,0 \
	DROPBEAR_SHA1_HMAC,0 \


##############################################################################
#
#   option,config,enabled,disabled = add option to localoptions.h
# !!option,config,enabled,disabled = replace option in sysoptions.h
#
#   option := (config) ? enabled : disabled
#
##############################################################################

DB_OPT_CONFIG = \
	DROPBEAR_AES128,CONFIG_DROPBEAR_MODERN_ONLY,0,1 \
	DROPBEAR_AES256,CONFIG_DROPBEAR_MODERN_ONLY,0,1 \
	DROPBEAR_RSA,CONFIG_DROPBEAR_MODERN_ONLY,0,1 \
	DROPBEAR_CURVE25519,CONFIG_DROPBEAR_CURVE25519,1,0 \
	DROPBEAR_ECDSA,CONFIG_DROPBEAR_ECC,1,0 \
	DROPBEAR_ECDH,CONFIG_DROPBEAR_ECC,1,0 \
	!!DROPBEAR_ECC_384,CONFIG_DROPBEAR_ECC_FULL,1,0 \
	!!DROPBEAR_ECC_521,CONFIG_DROPBEAR_ECC_FULL,1,0 \
	DROPBEAR_ED25519,CONFIG_DROPBEAR_ED25519,1,0 \
	DROPBEAR_CHACHA20POLY1305,CONFIG_DROPBEAR_CHACHA20POLY1305,1,0 \
	DROPBEAR_SK_KEYS,CONFIG_DROPBEAR_U2F,1,0 \
	DROPBEAR_SK_ECDSA,CONFIG_DROPBEAR_ECDSA_SK,1,0 \
	DROPBEAR_SK_ED25519,CONFIG_DROPBEAR_ED25519_SK,1,0 \
	DROPBEAR_SVR_AGENTFWD,CONFIG_DROPBEAR_AGENTFORWARD,1,0 \
	DROPBEAR_CLI_AGENTFWD,CONFIG_DROPBEAR_DBCLIENT_AGENTFORWARD,1,0 \
	DROPBEAR_CLI_ASKPASS_HELPER,CONFIG_DROPBEAR_DBCLIENT_ASKPASS,1,0 \


xsedx:=$(shell printf '\027')
# fixup for topmost rules.mk
space:=$(empty) $(empty)

db_opt_add     =echo '\#define $(1) $(2)' >> $(PKG_BUILD_DIR)/localoptions.h
db_opt_replace =$(ESED) '/^\#define $(1) .*$$$$/{h;:a;$$$$!n;/^\#.+$$$$/bb;/^$$$$/bb;H;ba;:b;x;s$(xsedx)^.+$$$$$(xsedx)\#define $(1) $(2)$(xsedx)p;x};p' -n $(PKG_BUILD_DIR)/sysoptions.h

define Build/Configure/dropbear_headers
	$(strip $(foreach s,$(DB_OPT_COMMON), \
	  $(if $(filter !!%,$(word 1,$(subst $(comma),$(space),$(s)))), \
	    $(call db_opt_replace,$(patsubst !!%,%,$(word 1,$(subst $(comma),$(space),$(s)))),$(subst $(space),$(comma),$(wordlist 2,$(words $(subst $(comma),$(space),$(s))),$(subst $(comma),$(space),$(s))))), \
	    $(call db_opt_add,$(word 1,$(subst $(comma),$(space),$(s))),$(subst $(space),$(comma),$(wordlist 2,$(words $(subst $(comma),$(space),$(s))),$(subst $(comma),$(space),$(s))))) \
	  ) ; \
	))

	$(strip $(foreach s,$(DB_OPT_CONFIG), \
	  $(if $(filter !!%,$(word 1,$(subst $(comma),$(space),$(s)))), \
	    $(call db_opt_replace,$(patsubst !!%,%,$(word 1,$(subst $(comma),$(space),$(s)))),$(if $($(word 2,$(subst $(comma),$(space),$(s)))),$(word 3,$(subst $(comma),$(space),$(s))),$(word 4,$(subst $(comma),$(space),$(s))))), \
	    $(call db_opt_add,$(word 1,$(subst $(comma),$(space),$(s))),$(if $($(word 2,$(subst $(comma),$(space),$(s)))),$(word 3,$(subst $(comma),$(space),$(s))),$(word 4,$(subst $(comma),$(space),$(s))))) \
	  ) ; \
	))
endef

define Build/Configure
	rm -f $(PKG_BUILD_DIR)/localoptions.h
	$(Build/Configure/Default)
	: > $(PKG_BUILD_DIR)/localoptions.h
	$(Build/Configure/dropbear_headers)

	# Enforce rebuild of svr-chansession.c
	rm -f $(PKG_BUILD_DIR)/svr-chansession.o

	# Rebuild them on config change
	+$(MAKE) -C $(PKG_BUILD_DIR)/libtomcrypt clean
	+$(MAKE) -C $(PKG_BUILD_DIR)/libtommath clean
endef

define Build/Compile
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		PROGRAMS="dropbear $(if $(CONFIG_DROPBEAR_DBCLIENT),dbclient,) dropbearkey $(if $(CONFIG_DROPBEAR_SCP),scp,)" \
		IGNORE_SPEED=1 $(if $(filter -Os,$(TARGET_CFLAGS)),LTC_SMALL=1) \
		MULTI=1 SCPPROGRESS=1
	+$(MAKE) $(PKG_JOBS) -C $(PKG_BUILD_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		PROGRAMS="dropbearconvert" \
		IGNORE_SPEED=1 $(if $(filter -Os,$(TARGET_CFLAGS)),LTC_SMALL=1)
endef

define Package/dropbear/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dropbearmulti $(1)/usr/sbin/dropbear
	$(INSTALL_DIR) $(1)/usr/bin
	$(if $(CONFIG_DROPBEAR_DBCLIENT),$(LN) ../sbin/dropbear $(1)/usr/bin/dbclient,)
	$(LN) ../sbin/dropbear $(1)/usr/bin/dropbearkey
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/dropbear.config $(1)/etc/config/dropbear
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/dropbear.init $(1)/etc/init.d/dropbear
	$(INSTALL_DIR) $(1)/usr/lib/opkg/info
	$(INSTALL_DIR) $(1)/etc/dropbear
	$(INSTALL_DIR) $(1)/lib/preinit
	$(INSTALL_DATA) ./files/dropbear.failsafe $(1)/lib/preinit/99_10_failsafe_dropbear
	$(foreach f,$(Package/dropbear/conffiles),$(if $(wildcard $(TOPDIR)/files/$(f)),chmod 0600 $(TOPDIR)/files/$(f) || :; ))
endef

define Package/dropbearconvert/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dropbearconvert $(1)/usr/bin/dropbearconvert
endef

$(eval $(call BuildPackage,dropbear))
$(eval $(call BuildPackage,dropbearconvert))
