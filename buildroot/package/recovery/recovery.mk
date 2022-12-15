#############################################################
#
# Recovery system
#
#############################################################


RECOVERY_VERSION = 1.0
RECOVERY_SITE = $(TOPDIR)/../recovery
RECOVERY_SITE_METHOD = local
RECOVERY_LICENSE = BSD-3c
RECOVERY_LICENSE_FILES = LICENSE.txt
RECOVERY_INSTALL_STAGING = NO
RECOVERY_DEPENDENCIES = qt qjson wpa_supplicant dhcpcd

define RECOVERY_BUILD_CMDS
	(cd $(@D) ; $(QT_QMAKE))
	$(MAKE) -C $(@D) all
	$(TARGET_STRIP) $(@D)/recovery
endef

define RECOVERY_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/recovery $(TARGET_DIR)/usr/bin/recovery
	rm $(TARGET_DIR)/init || true
	$(INSTALL) -m 0755 package/recovery/init $(TARGET_DIR)/init
	$(INSTALL) -m 0644 $(@D)/cmdline.txt $(BINARIES_DIR)/cmdline.txt
	mkdir -p $(TARGET_DIR)/rootfs $(TARGET_DIR)/boot
endef

$(eval $(generic-package))
