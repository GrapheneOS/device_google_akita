#
# Copyright (C) 2021 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TARGET_KERNEL_DIR ?= device/google/akita-kernel
TARGET_BOARD_KERNEL_HEADERS := device/google/akita-kernel/kernel-headers

$(call inherit-product-if-exists, vendor/google_devices/akita/prebuilts/device-vendor-akita.mk)
$(call inherit-product-if-exists, vendor/google_devices/zuma/prebuilts/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/zuma/proprietary/device-vendor.mk)
$(call inherit-product-if-exists, vendor/google_devices/akita/proprietary/akita/device-vendor-akita.mk)

# display
PRODUCT_COPY_FILES += \
	device/google/akita/akita/display_colordata_dev_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/display_colordata_dev_cal0.pb

# display brightness curve
PRODUCT_COPY_FILES += \
	device/google/akita/akita/panel_config_google-ak3b_cal0.pb:$(TARGET_COPY_OUT_VENDOR)/etc/panel_config_google-ak3b_cal0.pb

include device/google/zuma/device-shipping-common.mk
include device/google/akita/audio/akita/audio-tables.mk
include hardware/google/pixel/vibrator/cs40l26/device.mk
include device/google/gs-common/bcmbt/bluetooth.mk
include device/google/gs-common/touch/gti/gti.mk

# go/lyric-soong-variables
$(call soong_config_set,lyric,camera_hardware,akita)
$(call soong_config_set,lyric,tuning_product,akita)
$(call soong_config_set,google3a_config,target_device,akita)

DEVICE_PACKAGE_OVERLAYS += device/google/akita/akita/overlay

# Init files
PRODUCT_COPY_FILES += \
	device/google/akita/conf/init.akita.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.akita.rc

# Recovery files
PRODUCT_COPY_FILES += \
        device/google/akita/conf/init.recovery.device.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.akita.rc

# Camera
PRODUCT_COPY_FILES += \
	device/google/akita/media_profiles_akita.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# NFC
PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.nfc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.xml \
	frameworks/native/data/etc/android.hardware.nfc.hce.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hce.xml \
	frameworks/native/data/etc/android.hardware.nfc.hcef.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.hcef.xml \
	frameworks/native/data/etc/com.nxp.mifare.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/com.nxp.mifare.xml \
	frameworks/native/data/etc/android.hardware.nfc.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.nfc.ese.xml \
	device/google/akita/nfc/libnfc-hal-st.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libnfc-hal-st.conf \
	device/google/akita/nfc/libnfc-nci.conf:$(TARGET_COPY_OUT_PRODUCT)/etc/libnfc-nci.conf

PRODUCT_PACKAGES += \
	NfcNci \
	Tag \
	android.hardware.nfc-service.st

# SecureElement
PRODUCT_PACKAGES += \
	android.hardware.secure_element-service.thales

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.se.omapi.ese.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.ese.xml \
	frameworks/native/data/etc/android.hardware.se.omapi.uicc.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.se.omapi.uicc.xml \
	device/google/akita/nfc/libse-gto-hal.conf:$(TARGET_COPY_OUT_VENDOR)/etc/libse-gto-hal.conf

# Thermal Config
PRODUCT_COPY_FILES += \
	device/google/akita/thermal_info_config_akita.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json \
	device/google/akita/thermal_info_config_charge_akita.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config_charge.json

# Power HAL config
PRODUCT_COPY_FILES += \
	device/google/akita/powerhint-akita.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Bluetooth HAL
PRODUCT_COPY_FILES += \
	device/google/akita/bluetooth/bt_vendor_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth/bt_vendor_overlay.conf
PRODUCT_PROPERTY_OVERRIDES += \
    ro.bluetooth.a2dp_offload.supported=true \
    persist.bluetooth.a2dp_offload.disabled=false \
    persist.bluetooth.a2dp_offload.cap=sbc-aac-aptx-aptxhd-ldac

# Bluetooth hci_inject test tool
PRODUCT_PACKAGES_DEBUG += \
    hci_inject

# Bluetooth SAR test tool
PRODUCT_PACKAGES_DEBUG += \
    sar_test

# Bluetooth EWP test tool
PRODUCT_PACKAGES_DEBUG += \
    ewp_tool

# Bluetooth AAC VBR
PRODUCT_PRODUCT_PROPERTIES += \
    persist.bluetooth.a2dp_aac.vbr_supported=true

# Spatial Audio
PRODUCT_PACKAGES += \
	libspatialaudio \
	librondo

# Keymaster HAL
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# Gatekeeper HAL
#LOCAL_GATEKEEPER_PRODUCT_PACKAGE ?= android.hardware.gatekeeper@1.0-service.software


# Gatekeeper
# PRODUCT_PACKAGES += \
# 	android.hardware.gatekeeper@1.0-service.software

# Keymint replaces Keymaster
# PRODUCT_PACKAGES += \
# 	android.hardware.security.keymint-service

# Keymaster
#PRODUCT_PACKAGES += \
#	android.hardware.keymaster@4.0-impl \
#	android.hardware.keymaster@4.0-service

#PRODUCT_PACKAGES += android.hardware.keymaster@4.0-service.remote
#PRODUCT_PACKAGES += android.hardware.keymaster@4.1-service.remote
#LOCAL_KEYMASTER_PRODUCT_PACKAGE := android.hardware.keymaster@4.1-service
#LOCAL_KEYMASTER_PRODUCT_PACKAGE ?= android.hardware.keymaster@4.1-service

# PRODUCT_PROPERTY_OVERRIDES += \
# 	ro.hardware.keystore_desede=true \
# 	ro.hardware.keystore=software \
# 	ro.hardware.gatekeeper=software

# PowerStats HAL
PRODUCT_SOONG_NAMESPACES += \
    device/google/akita/powerstats/akita

# WiFi Overlay
PRODUCT_PACKAGES += \
	WifiOverlay2024Mid

# Trusty liboemcrypto.so
PRODUCT_SOONG_NAMESPACES += vendor/google_devices/akita/prebuilts

# Location
PRODUCT_COPY_FILES += \
       device/google/akita/location/gps.cer:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.cer

ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
        PRODUCT_COPY_FILES += \
		device/google/akita/location/lhd.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/lhd.conf \
		device/google/akita/location/scd.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/scd.conf \
		device/google/akita/location/gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
else
        PRODUCT_COPY_FILES += \
		device/google/akita/location/lhd_user.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/lhd.conf \
		device/google/akita/location/scd_user.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/scd.conf \
		device/google/akita/location/gps_user.xml:$(TARGET_COPY_OUT_VENDOR)/etc/gnss/gps.xml
endif

# include GNSSD
include device/google/akita/location/gnssd/device-gnss.mk

# Install product specific framework compatibility matrix
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/google/akita/device_framework_matrix_product.xml


# Set zram size
PRODUCT_VENDOR_PROPERTIES += \
	vendor.zram.size=50p \
	persist.device_config.configuration.disable_rescue_party=true

# Fingerprint HAL
GOODIX_CONFIG_BUILD_VERSION := g7_trusty
include device/google/gs101/fingerprint/udfps_common.mk
ifeq ($(filter factory%, $(TARGET_PRODUCT)),)
include device/google/gs101/fingerprint/udfps_shipping.mk
else
include device/google/gs101/fingerprint/udfps_factory.mk
endif

# Display LBE
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += vendor.display.lbe.supported=1

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.udfps.als_feed_forward_supported=true \
    persist.vendor.udfps.lhbm_controlled_in_hal_supported=true

# OIS with system imu
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.ois_with_system_imu=true

# Vibrator HAL
ADAPTIVE_HAPTICS_FEATURE := adaptive_haptics_v1
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.vibrator.hal.supported_primitives=243 \
    ro.vendor.vibrator.hal.f0.comp.enabled=1 \
    ro.vendor.vibrator.hal.redc.comp.enabled=0 \
	persist.vendor.vibrator.hal.context.enable=false \
	persist.vendor.vibrator.hal.context.scale=40 \
	persist.vendor.vibrator.hal.context.fade=true \
	persist.vendor.vibrator.hal.context.cooldowntime=1600 \
	persist.vendor.vibrator.hal.context.settlingtime=5000
