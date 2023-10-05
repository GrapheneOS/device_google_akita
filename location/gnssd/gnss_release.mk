# Enable pixel gnss hal service
include device/google/akita/location/gnssd/pixel_gnss_hal.mk

PRODUCT_PACKAGES += \
    gnssd \
    android.hardware.gnss-service \
    android.hardware.location.gps.prebuilt.xml

PRODUCT_COPY_FILES += \
    device/google/akita/location/gnssd/release/ca.pem:vendor/etc/gnss/ca.pem

PRODUCT_SOONG_NAMESPACES += \
    device/google/akita/location/gnssd

ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    PRODUCT_COPY_FILES += \
        device/google/akita/location/gnssd/release/gps.cfg:vendor/etc/gnss/gps.cfg
    PRODUCT_VENDOR_PROPERTIES += \
        vendor.gps.aol.enabled=true
else
    PRODUCT_COPY_FILES += \
        device/google/akita/location/gnssd/release/gps_user.cfg:vendor/etc/gnss/gps.cfg
endif
