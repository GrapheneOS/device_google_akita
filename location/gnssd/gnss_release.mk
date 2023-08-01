# only GPS libraries and binaries to the target directory
GPS_ROOT := device/google/akita/location/gnssd

PRODUCT_PACKAGES += \
    gnssd \
    gnss-aidl-service_IGnssV2_ISlsiGnssV1 \
    android.hardware.location.gps.prebuilt.xml

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.gnsslog.maxfilesize=256 \
    persist.vendor.gnsslog.status=0 \
    exynos.gnss.path.log=/data/vendor/gps/

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/ca.pem:vendor/etc/gnss/ca.pem \

PRODUCT_SOONG_NAMESPACES += \
    $(GPS_ROOT)

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/gps.cfg:vendor/etc/gnss/gps.cfg
