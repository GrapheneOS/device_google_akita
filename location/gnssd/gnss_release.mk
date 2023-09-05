# only GPS libraries and binaries to the target directory
GPS_ROOT := device/google/akita/location/gnssd

PRODUCT_PACKAGES += \
    gnssd \
    android.hardware.gnss-service \
    android.hardware.location.gps.prebuilt.xml

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/ca.pem:vendor/etc/gnss/ca.pem \

PRODUCT_SOONG_NAMESPACES += \
    $(GPS_ROOT)

ifneq (,$(filter userdebug eng, $(TARGET_BUILD_VARIANT)))
    PRODUCT_COPY_FILES += \
        $(GPS_ROOT)/release/gps.cfg:vendor/etc/gnss/gps.cfg
    PRODUCT_VENDOR_PROPERTIES += \
        vendor.gps.aol.enabled=true
else
    PRODUCT_COPY_FILES += \
        $(GPS_ROOT)/release/gps_user.cfg:vendor/etc/gnss/gps.cfg
endif
