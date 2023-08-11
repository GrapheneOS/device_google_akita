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

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/gps.cfg:vendor/etc/gnss/gps.cfg
