#!/bin/sh

set -e

ln -rsf $TARGET_DIR/usr/lib/libGLESv2.so $TARGET_DIR/usr/lib/libGLESv2.so.2
ln -rsf $TARGET_DIR/usr/lib/libEGL.so $TARGET_DIR/usr/lib/libEGL.so.1
ln -rsf $TARGET_DIR/usr/lib/libWPEBackend-rdk.so $TARGET_DIR/usr/lib/libWPEBackend-default.so

DBUS_UUID=$(dbus-uuidgen)

mkdir -p $TARGET_DIR/var/lib/dbus
echo $DBUS_UUID >> $TARGET_DIR/var/lib/dbus/machine-id
echo $DBUS_UUID >> $TARGET_DIR/etc/machine-id
# Create the revert script for manually switching back to the previously
# active firmware.
mkdir -p $TARGET_DIR/usr/share/fwup
$HOST_DIR/usr/bin/fwup -c -f $NERVES_DEFCONFIG_DIR/fwup-revert.conf -o $TARGET_DIR/usr/share/fwup/revert.fw

# Copy the fwup includes to the images dir
cp -rf $NERVES_DEFCONFIG_DIR/fwup_include $BINARIES_DIR

