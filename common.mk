# Copyright 2023 Paranoid Android
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

QCOM_COMMON_PATH := device/qcom/common
TARGET_FWK_SUPPORTS_FULL_VALUEADDS := true

ifeq ($(TARGET_BOARD_PLATFORM),)
$(error "TARGET_BOARD_PLATFORM is not defined yet, please define in your device makefile so it's accessible to QCOM common.")
endif

# List of QCOM targets.
MSMSTEPPE := sm6150
TRINKET := trinket

QCOM_BOARD_PLATFORMS += \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    bengal \
    crow \
    holi \
    kona \
    kalama \
    lahaina \
    lito \
    monaco \
    msm8937 \
    msm8953 \
    msm8996 \
    msm8998 \
    msmnile \
    parrot \
    sdm660 \
    sdm710 \
    sdm845 \
    taro

# List of targets that use video hardware.
MSM_VIDC_TARGET_LIST ?= \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    kona \
    lito \
    msm8937 \
    msm8953 \
    msm8996 \
    msm8998 \
    msmnile \
    sdm660 \
    sdm710 \
    sdm845

ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19, $(TARGET_KERNEL_VERSION)))
# List of targets that use master side content protection.
MASTER_SIDE_CP_TARGET_LIST := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    bengal \
    kona \
    lito \
    msm8996 \
    msm8998 \
    msmnile \
    sdm660 \
    sdm710 \
    sdm845
endif

# Include QCOM board utilities.
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
include vendor/qcom/opensource/core-utils/build/utils.mk
endif

6_1_FAMILY := \
    pineapple

# Kernel Families
5_15_FAMILY := \
    crow \
    kalama \
    monaco

5_10_FAMILY := \
    parrot \
    taro

5_4_FAMILY := \
    holi \
    lahaina

4_19_FAMILY := \
    bengal \
    kona \
    lito

4_14_FAMILY := \
    $(MSMSTEPPE) \
    $(TRINKET) \
    atoll \
    msmnile

4_9_FAMILY := \
    msm8953 \
    qcs605 \
    sdm710 \
    sdm845

4_4_FAMILY := \
    msm8998 \
    sdm660

3_18_FAMILY := \
    msm8937 \
    msm8996

ifeq ($(call is-board-platform-in-list,$(6_1_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 6.1
else ifeq ($(call is-board-platform-in-list,$(5_15_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.15
else ifeq ($(call is-board-platform-in-list,$(5_10_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.10
else ifeq ($(call is-board-platform-in-list,$(5_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 5.4
else ifeq ($(call is-board-platform-in-list,$(4_19_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.19
else ifeq ($(call is-board-platform-in-list,$(4_14_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.14
else ifeq ($(call is-board-platform-in-list,$(4_9_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.9
else ifeq ($(call is-board-platform-in-list,$(4_4_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 4.4
else ifeq ($(call is-board-platform-in-list,$(3_18_FAMILY)),true)
TARGET_KERNEL_VERSION ?= 3.18
endif

ifeq ($(call is-board-platform-in-list,$(QCOM_BOARD_PLATFORMS)),true)
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
DEVICE_FRAMEWORK_MANIFEST_FILE += \
    $(QCOM_COMMON_PATH)/configs/hidl/framework_manifest.xml

# Compatibility matrix
DEVICE_MATRIX_FILE += \
    $(QCOM_COMMON_PATH)/configs/hidl/compatibility_matrix.xml

DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    vendor/qcom/opensource/core-utils/vendor_framework_compatibility_matrix.xml
endif

# Components
include $(QCOM_COMMON_PATH)/components.mk

# Filesystem
TARGET_FS_CONFIG_GEN += $(QCOM_COMMON_PATH)/config.fs

# Opt out of 16K alignment changes
PRODUCT_MAX_PAGE_SIZE_SUPPORTED ?= 4096

# Permissions
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/configs/privapp-permissions-qti.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-qti.xml \
    $(QCOM_COMMON_PATH)/configs/privapp-permissions-qti-system-ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-qti-system-ext.xml \
    $(QCOM_COMMON_PATH)/configs/qti_whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/qti_whitelist.xml \
    $(QCOM_COMMON_PATH)/configs/qti_whitelist_system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/qti_whitelist_system_ext.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnel_migration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnel_migration.xml

# Public Libraries
PRODUCT_COPY_FILES += \
    $(QCOM_COMMON_PATH)/configs/public.libraries.product-qti.txt:$(TARGET_COPY_OUT_PRODUCT)/etc/public.libraries-qti.txt \
    $(QCOM_COMMON_PATH)/configs/public.libraries.system_ext-qti.txt:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/public.libraries-qti.txt

# EGL blobcache configuration
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.egl.blobcache.multifile=true \
    ro.egl.blobcache.multifile_limit=33554432

# Exfat FS
PRODUCT_PACKAGES += \
    fsck.exfat \
    mkfs.exfat

# GPS
PRODUCT_PACKAGES += \
    libcurl

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.base@1.0.vendor \
    android.hidl.manager@1.0 \
    android.hidl.memory.block@1.0.vendor \
    libhidltransport \
    libhidltransport.vendor \
    libhwbinder \
    libhwbinder.vendor \
    android.hidl.allocator@1.0.vendor

# Media
TARGET_DYNAMIC_64_32_MEDIASERVER := true

# Partition source order for Product/Build properties pickup.
PRODUCT_SYSTEM_PROPERTIES += \
    ro.product.property_source_order=odm,vendor,product,system_ext,system

# Protobuf
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full-3.9.1-vendorcompat \
    libprotobuf-cpp-lite-3.9.1-vendorcompat-new

# QTI framework detect
PRODUCT_PACKAGES += \
    libqti_vndfwk_detect \
    libqti_vndfwk_detect.vendor \
    libvndfwk_detect_jni.qti \
    libvndfwk_detect_jni.qti.vendor

# QTI VA
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.qti.va_aosp.support=1

PRODUCT_ODM_PROPERTIES += \
    ro.vendor.qti.va_odm.support=1

# Sensors
PRODUCT_PACKAGES += \
    android.frameworks.sensorservice@1.0.vendor

# SoC
PRODUCT_VENDOR_PROPERTIES += \
    ro.soc.manufacturer=QTI

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model

# usbudev service for usb ip assigment
PRODUCT_PACKAGES += \
    usbudev

# RFS APQ GNSS symlinks
PRODUCT_PACKAGES += \
    rfs_apq_gnss_hlos_symlink \
    rfs_apq_gnss_ramdumps_symlink \
    rfs_apq_gnss_readonly_firmware_symlink \
    rfs_apq_gnss_readonly_vendor_firmware_symlink \
    rfs_apq_gnss_readwrite_symlink \
    rfs_apq_gnss_shared_symlink

# RFS MDM ADSP symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_adsp_hlos_symlink \
    rfs_mdm_adsp_ramdumps_symlink \
    rfs_mdm_adsp_readonly_firmware_symlink \
    rfs_mdm_adsp_readonly_vendor_firmware_symlink \
    rfs_mdm_adsp_readwrite_symlink \
    rfs_mdm_adsp_shared_symlink

# RFS MDM CDSP symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_cdsp_hlos_symlink \
    rfs_mdm_cdsp_ramdumps_symlink \
    rfs_mdm_cdsp_readonly_firmware_symlink \
    rfs_mdm_cdsp_readonly_vendor_firmware_symlink \
    rfs_mdm_cdsp_readwrite_symlink \
    rfs_mdm_cdsp_shared_symlink

# RFS MDM MPSS symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_mpss_hlos_symlink \
    rfs_mdm_mpss_ramdumps_symlink \
    rfs_mdm_mpss_readonly_firmware_symlink \
    rfs_mdm_mpss_readonly_vendor_firmware_symlink \
    rfs_mdm_mpss_readwrite_symlink \
    rfs_mdm_mpss_shared_symlink

# RFS MDM SLPI symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_slpi_hlos_symlink \
    rfs_mdm_slpi_ramdumps_symlink \
    rfs_mdm_slpi_readonly_firmware_symlink \
    rfs_mdm_slpi_readonly_vendor_firmware_symlink \
    rfs_mdm_slpi_readwrite_symlink \
    rfs_mdm_slpi_shared_symlink

# RFS MDM TN symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_tn_hlos_symlink \
    rfs_mdm_tn_ramdumps_symlink \
    rfs_mdm_tn_readonly_firmware_symlink \
    rfs_mdm_tn_readonly_vendor_firmware_symlink \
    rfs_mdm_tn_readwrite_symlink \
    rfs_mdm_tn_shared_symlink

# RFS MDM WPSS symlinks
PRODUCT_PACKAGES += \
    rfs_mdm_wpss_hlos_symlink \
    rfs_mdm_wpss_ramdumps_symlink \
    rfs_mdm_wpss_readonly_firmware_symlink \
    rfs_mdm_wpss_readonly_vendor_firmware_symlink \
    rfs_mdm_wpss_readwrite_symlink \
    rfs_mdm_wpss_shared_symlink

# RFS MSM ADSP symlinks
PRODUCT_PACKAGES += \
    rfs_msm_adsp_hlos_symlink \
    rfs_msm_adsp_ramdumps_symlink \
    rfs_msm_adsp_readonly_firmware_symlink \
    rfs_msm_adsp_readonly_vendor_firmware_symlink \
    rfs_msm_adsp_readwrite_symlink \
    rfs_msm_adsp_shared_symlink

# RFS MSM CDSP symlinks
PRODUCT_PACKAGES += \
    rfs_msm_cdsp_hlos_symlink \
    rfs_msm_cdsp_ramdumps_symlink \
    rfs_msm_cdsp_readonly_firmware_symlink \
    rfs_msm_cdsp_readonly_vendor_firmware_symlink \
    rfs_msm_cdsp_readwrite_symlink \
    rfs_msm_cdsp_shared_symlink

# RFS MSM MPSS symlinks
PRODUCT_PACKAGES += \
    rfs_msm_mpss_hlos_symlink \
    rfs_msm_mpss_ramdumps_symlink \
    rfs_msm_mpss_readonly_firmware_symlink \
    rfs_msm_mpss_readonly_vendor_firmware_symlink \
    rfs_msm_mpss_readwrite_symlink \
    rfs_msm_mpss_shared_symlink

# RFS MSM SLPI symlinks
PRODUCT_PACKAGES += \
    rfs_msm_slpi_hlos_symlink \
    rfs_msm_slpi_ramdumps_symlink \
    rfs_msm_slpi_readonly_firmware_symlink \
    rfs_msm_slpi_readonly_vendor_firmware_symlink \
    rfs_msm_slpi_readwrite_symlink \
    rfs_msm_slpi_shared_symlink

# RFS MSM WPSS symlinks
PRODUCT_PACKAGES += \
    rfs_msm_wpss_hlos_symlink \
    rfs_msm_wpss_ramdumps_symlink \
    rfs_msm_wpss_readonly_firmware_symlink \
    rfs_msm_wpss_readonly_vendor_firmware_symlink \
    rfs_msm_wpss_readwrite_symlink \
    rfs_msm_wpss_shared_symlink

endif # QCOM_BOARD_PLATFORMS
