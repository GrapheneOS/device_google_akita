# only GPS libraries and binaries to the target directory
GPS_ROOT := device/google/akita/location/gnssd

PRODUCT_PACKAGES += \
    android.hardware.gnss@2.1-impl \
    vendor.samsung.hardware.gnss@1.0 \
    vendor.samsung.hardware.gnss@1.0-impl \
    vendor.samsung.hardware.gnss@1.0-service \
    gnssd \
    sctd \
    spad \
    swcnd \
    libmptool_json \
    libmptool_log \
    libmptool_utils \
    gnss-aidl-service_IGnssV2_ISlsiGnssV1 \
    libsensorndkbridge

PRODUCT_PROPERTY_OVERRIDES += \
    persist.vendor.gnsslog.maxfilesize=256 \
    persist.vendor.gnsslog.status=0 \
    exynos.gnss.path.log=/data/vendor/gps/

PRODUCT_COPY_FILES += \
	  $(GPS_ROOT)/init.gnss.rc:vendor/etc/init/init.gnss.rc

DEVICE_MANIFEST_FILE += \
    $(GPS_ROOT)/manifest.xml

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/ca.pem:vendor/etc/gnss/ca.pem \
    $(GPS_ROOT)/release/sctd.json:vendor/etc/sctd.json \
    $(GPS_ROOT)/release/spad.json:vendor/etc/spad.json \
    $(GPS_ROOT)/release/swcnd.json:vendor/etc/swcnd.json \
    $(GPS_ROOT)/release/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \

#DEVICE_MATRIX_FILE := \
    $(GPS_ROOT)/compatibility_matrix.xml

PRODUCT_SOONG_NAMESPACES += \
    $(GPS_ROOT)

PRODUCT_COPY_FILES += \
    $(GPS_ROOT)/release/gps.cfg:vendor/etc/gnss/gps.cfg
