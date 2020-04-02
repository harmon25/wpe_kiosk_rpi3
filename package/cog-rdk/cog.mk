################################################################################
#
# cog-rdk
#
################################################################################

COG_RDK_VERSION = 0.6.0
COG_RDK_SITE = https://wpewebkit.org/releases
COG_RDK_SOURCE = cog-$(COG_RDK_VERSION).tar.xz
COG_RDK_INSTALL_STAGING = YES
COG_RDK_DEPENDENCIES = dbus wpewebkit-rdk wpebackend-rdk
COG_RDK_LICENSE = MIT
COG_RDK_LICENSE_FILES = COPYING
COG_RDK_CONF_OPTS = \
	-DCOG_BUILD_PROGRAMS=ON \
	-DCOG_PLATFORM_DRM=OFF \
	-DCOG_HOME_URI='$(call qstrip,$(BR2_PACKAGE_COG_RDK_PROGRAMS_HOME_URI))'

ifeq ($(BR2_PACKAGE_COG_RDK_PLATFORM_FDO),y)
COG_RDK_DEPENDENCIES += libegl libgles wayland wpewebkit wpebackend-fdo
COG_RDK_CONF_OPTS += -DCOG_PLATFORM_FDO=ON
else
COG_RDK_CONF_OPTS += -DCOG_PLATFORM_FDO=OFF
endif

ifeq ($(BR2_PACKAGE_COG_RDK_PROGRAMS_DBUS_SYSTEM_BUS),y)
COG_RDK_CONF_OPTS += -DCOG_DBUS_SYSTEM_BUS=ON
else
COG_RDK_CONF_OPTS += -DCOG_DBUS_SYSTEM_BUS=OFF
endif

$(eval $(cmake-package))
