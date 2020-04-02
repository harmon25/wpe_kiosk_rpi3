################################################################################
#
# WPEBackend-RDK
#
################################################################################

WPEBACKEND_RDK_VERSION = 4e9a79d25f6a8f5fe6ca52376db8c757f0193987
WPEBACKEND_RDK_SITE = $(call github,WebPlatformForEmbedded,WPEBackend-rdk,$(WPEBACKEND_RDK_VERSION))
WPEBACKEND_RDK_INSTALL_STAGING = YES
#WPEBACKEND_RDK_DEPENDENCIES = libglib2
WPEBACKEND_RDK_DEPENDENCIES = libwpe-rdk libglib2

ifeq ($(BR2_PACKAGE_XKEYBOARD_CONFIG),y)
WPEBACKEND_RDK_DEPENDENCIES += xkeyboard-config
endif

# USE_BACKEND_BCM_RPI
ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
WPEBACKEND_RDK_DEPENDENCIES += rpi-userland libegl libinput
WPEBACKEND_RDK_CONF_OPTS += -DUSE_BACKEND_BCM_RPI=ON
endif

$(eval $(cmake-package))
