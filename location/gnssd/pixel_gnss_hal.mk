# Enable aidl service
$(call soong_config_set, pixel_gnss, enable_pixel_gnss_aidl_service, true)

PRODUCT_PACKAGES += \
    android.hardware.gnss-service.pixel

PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.gps.hal.service.name=vendor

# Compatibility matrix
DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += \
    device/google/akita/location/gnssd/device_framework_matrix_product.xml

DEVICE_PRODUCT_COMPATIBILITY_MATRIX_FILE += device/google/gs-common/proprietary/vendor.google.aam.xml
