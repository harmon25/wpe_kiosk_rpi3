################################################################################
#
# wpewebkit
#
################################################################################

WPEWEBKIT_RDK_VERSION = 2.22.2
WPEWEBKIT_RDK_SITE = https://www.wpewebkit.org/releases
WPEWEBKIT_RDK_SOURCE = wpewebkit-$(WPEWEBKIT_VERSION).tar.xz
WPEWEBKIT_RDK_INSTALL_STAGING = YES
WPEWEBKIT_RDK_LICENSE = LGPv2.1+, BSD-2-Clause
WPEWEBKIT_RDK_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2.1
WPEWEBKIT_RDK_DEPENDENCIES = host-cmake host-ruby host-flex host-bison \
	host-gperf harfbuzz icu jpeg libegl libepoxy libgcrypt libsoup \
	libxml2 sqlite webp \
	libwpe-rdk
WPEWEBKIT_RDK_CONF_OPTS = -DPORT=WPE

# JSC JIT is supported on: i386, x86_64, aarch64 and mips32le target archs.
# For target arch arm (32) it is only supported on ARMv7 CPUs and ARMv8 CPUs,
# and is recommended to generate a Thumb2 build (as upstream tests more this)
ifeq ($(BR2_i386)$(BR2_x86_64)$(BR2_aarch64)$(BR2_mipsel),y)
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_JIT=ON
else ifeq ($(BR2_ARM_CPU_ARMV7A)$(BR2_ARM_CPU_ARMV8A)$(BR2_ARM_CPU_ARMV8),y)
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_JIT=ON
else
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_JIT=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_MULTIMEDIA),y)
WPEWEBKIT_RDK_CONF_OPTS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_WEB_AUDIO=ON \
	-DENABLE_MEDIA_SOURCE=ON
WPEWEBKIT_RDK_DEPENDENCIES += gstreamer1 gst1-libav gst1-plugins-base \
	gst1-plugins-good gst1-plugins-bad
else
WPEWEBKIT_RDK_CONF_OPTS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_WEB_AUDIO=OFF \
	-DENABLE_MEDIA_SOURCE=OFF
endif

ifeq ($(BR2_PACKAGE_WPEBACKEND_FDO),y)
    WPEWEBKIT_RDK_DEPENDENCIES += wpebackend-fdo
endif

ifeq ($(BR2_PACKAGE_WPEBACKEND_RDK),y)
    WPEWEBKIT_RDK_DEPENDENCIES += wpebackend-rdk
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_HTTPS),y)
WPEWEBKIT_RDK_DEPENDENCIES += glib-networking
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_WEBCRYPTO),y)
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_WEB_CRYPTO=ON
WPEWEBKIT_RDK_DEPENDENCIES += libtasn1
else
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_WEB_CRYPTO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_WEBDRIVER),y)
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_WEBDRIVER=ON
else
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_WEBDRIVER=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_XSLT),y)
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_XSLT=ON
WPEWEBKIT_RDK_DEPENDENCIES += libxslt
else
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_XSLT=OFF
endif

#MiniBrowser and its Backend
ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_MINIBROWSER),y)
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_MINIBROWSER=ON
ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_MINIBROWSER_BACKEND_FDO),y)
WPEWEBKIT_RDK_CONF_OPTS += \
	-DUSE_MINIBROWSER_BACKEND_FDO=ON
else ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_MINIBROWSER_BACKEND_DEFAULT),y)
WPEWEBKIT_RDK_CONF_OPTS += \
	-DUSE_MINIBROWSER_BACKEND_DEFAULT=ON
endif
else
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_MINIBROWSER=OFF
endif

ifeq ($(BR2_PACKAGE_WOFF2),y)
WPEWEBKIT_RDK_CONF_OPTS += -DUSE_WOFF2=ON
WPEWEBKIT_RDK_DEPENDENCIES += woff2
else
WPEWEBKIT_RDK_CONF_OPTS += -DUSE_WOFF2=OFF
endif

define WPEWEBKIT_RDK_BUILD_JSC
	$(WPEWEBKIT_RDK_MAKE_ENV) $(WPEWEBKIT_MAKE) -C $(@D) jsc
endef

define WPEWEBKIT_RDK_INSTALL_JSC
	install -Dm755 $(@D)/bin/jsc $(TARGET_DIR)/usr/bin/jsc
	$(STRIPCMD) $(TARGET_DIR)/usr/bin/jsc
endef

define WPEWEBKIT_RDK_INSTALL_JSC_STAGING
	install -Dm755 $(@D)/bin/jsc $(STAGING_DIR)/usr/bin/jsc
	cd $(@D) && DESTDIR=$(STAGING_DIR) $(HOST_DIR)/usr/bin/cmake \
			-DCOMPONENT=Development \
			-P $(WPEWEBKIT_RDK_BUILDDIR)/Source/JavaScriptCore/cmake_install.cmake
endef

ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_BUILD_JSC),y)
WPEWEBKIT_RDK_POST_BUILD_HOOKS += WPEWEBKIT_BUILD_JSC
WPEWEBKIT_RDK_POST_INSTALL_TARGET_HOOKS += WPEWEBKIT_INSTALL_JSC
WPEWEBKIT_RDK_POST_INSTALL_STAGING_HOOKS += WPEWEBKIT_INSTALL_JSC_STAGING
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GL),y)
WPEWEBKIT_RDK_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_RDK_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

$(eval $(cmake-package))
