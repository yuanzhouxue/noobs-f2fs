################################################################################
#
# rpi-firmware
#
################################################################################

RPI_FIRMWARE_VERSION = 0d6514f32722e4acf091ab2af9715793ffd6b727
RPI_FIRMWARE_SITE = $(call github,raspberrypi,firmware,$(RPI_FIRMWARE_VERSION))
RPI_FIRMWARE_LICENSE = BSD-3c
RPI_FIRMWARE_LICENSE_FILES = boot/LICENCE.broadcom
RPI_FIRMWARE_INSTALL_TARGET = NO
RPI_FIRMWARE_INSTALL_IMAGES = YES

RPI_FIRMWARE_DEPENDENCIES += host-rpi-firmware

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTBS),y)
define RPI_FIRMWARE_INSTALL_DTB
	for dtb in $(@D)/boot/*.dtb; do \
		$(INSTALL) -D -m 0644 $(@D)/boot/$${dtb} $(BINARIES_DIR)/rpi-firmware/$${dtb}
	done
endef
endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_DTB_OVERLAYS),y)
define RPI_FIRMWARE_INSTALL_DTB_OVERLAYS
	for ovldtb in  $(@D)/boot/overlays/*.dtbo; do \
		$(INSTALL) -D -m 0644 $${ovldtb} $(BINARIES_DIR)/rpi-firmware/overlays/$${ovldtb##*/} || exit 1; \
	done
endef
endif

ifeq ($(BR2_PACKAGE_RPI_FIRMWARE_INSTALL_VCDBG),y)
define RPI_FIRMWARE_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 0700 $(@D)/$(if BR2_ARM_EABIHF,hardfp/)opt/vc/bin/vcdbg \
		$(TARGET_DIR)/usr/sbin/vcdbg
endef
endif # INSTALL_VCDBG

define RPI_FIRMWARE_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 $(@D)/boot/bootcode.bin $(BINARIES_DIR)/rpi-firmware/bootcode.bin
	$(INSTALL) -D -m 0644 $(@D)/boot/start$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).elf $(BINARIES_DIR)/rpi-firmware/start.elf
	$(INSTALL) -D -m 0644 $(@D)/boot/fixup$(BR2_PACKAGE_RPI_FIRMWARE_BOOT).dat $(BINARIES_DIR)/rpi-firmware/fixup.dat
	$(INSTALL) -D -m 0644 $(@D)/boot/start$(BR2_PACKAGE_RPI_FIRMWARE_BOOT_PI4).elf $(BINARIES_DIR)/rpi-firmware/start4.elf
	$(INSTALL) -D -m 0644 $(@D)/boot/fixup$(BR2_PACKAGE_RPI_FIRMWARE_BOOT_PI4).dat $(BINARIES_DIR)/rpi-firmware/fixup4.dat
	$(INSTALL) -D -m 0644 package/rpi-firmware/config.txt $(BINARIES_DIR)/rpi-firmware/config.txt
	$(INSTALL) -D -m 0644 package/rpi-firmware/cmdline.txt $(BINARIES_DIR)/rpi-firmware/cmdline.txt
	$(RPI_FIRMWARE_INSTALL_DTB)
	$(RPI_FIRMWARE_INSTALL_DTB_OVERLAYS)
endef

# We have no host sources to get, since we already
# bundle the script we want to install.
HOST_RPI_FIRMWARE_SOURCE =
HOST_RPI_FIRMWARE_DEPENDENCIES =

$(eval $(generic-package))
$(eval $(host-generic-package))
