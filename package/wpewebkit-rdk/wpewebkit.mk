################################################################################
#
# wpewebkit-rdk
#
################################################################################

WPEWEBKIT_RDK_VERSION = 2.28.0
WPEWEBKIT_RDK_SITE = https://www.wpewebkit.org/releases
WPEWEBKIT_RDK_SOURCE = wpewebkit-$(WPEWEBKIT_RDK_VERSION).tar.xz
WPEWEBKIT_RDK_INSTALL_STAGING = YES
WPEWEBKIT_RDK_LICENSE = LGPv2.1+, BSD-2-Clause
WPEWEBKIT_RDK_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2.1
WPEWEBKIT_RDK_DEPENDENCIES = host-cmake host-ruby host-flex host-bison \
	host-gperf harfbuzz icu jpeg libegl libepoxy libgcrypt libsoup \
	libxml2 sqlite webp \
	wpebackend-rdk

WPEWEBKIT_RDK_CONF_OPTS = \
	-DPORT=WPE \
	-DENABLE_ACCESSIBILITY=OFF \
	-DENABLE_API_TESTS=OFF \
	-DENABLE_MINIBROWSER=OFF \
	-DSILENCE_CROSS_COMPILATION_NOTICES=ON


ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_SANDBOX),y)

WPEWEBKIT_RDK_CONF_OPTS += \
	-DENABLE_BUBBLEWRAP_SANDBOX=ON \
	-DBWRAP_EXECUTABLE=/usr/bin/bwrap \
	-DDBUS_PROXY_EXECUTABLE=/usr/bin/xdg-dbus-proxy
WPEWEBKIT_RDK_DEPENDENCIES += libseccomp
else
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_BUBBLEWRAP_SANDBOX=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_MULTIMEDIA),y)
WPEWEBKIT_RDK_CONF_OPTS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_WEB_AUDIO=ON
WPEWEBKIT_RDK_DEPENDENCIES += gstreamer1 gst1-libav gst1-plugins-base gst1-plugins-good
else
WPEWEBKIT_RDK_CONF_OPTS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_USE_GSTREAMER_GL),y)
WPEWEBKIT_RDK_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_RDK_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_RDK_WEBDRIVER),y)
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_WEBDRIVER=ON
else
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_WEBDRIVER=OFF
endif

ifeq ($(BR2_PACKAGE_WOFF2),y)
WPEWEBKIT_RDK_CONF_OPTS += -DUSE_WOFF2=ON
WPEWEBKIT_RDK_DEPENDENCIES += woff2
else
WPEWEBKIT_RDK_CONF_OPTS += -DUSE_WOFF2=OFF
endif

# JIT is not supported for MIPS r6, but the WebKit build system does not
# have a check for these processors. Disable JIT forcibly here and use
# the CLoop interpreter instead.
#
# Upstream bug: https://bugs.webkit.org/show_bug.cgi?id=191258
ifeq ($(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6),y)
WPEWEBKIT_RDK_CONF_OPTS += -DENABLE_JIT=OFF -DENABLE_C_LOOP=ON
endif

$(eval $(cmake-package))