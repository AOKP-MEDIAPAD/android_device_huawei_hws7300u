ifneq ($(USE_CAMERA_STUB),true)
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
ifneq ($(BUILD_TINY_ANDROID),true)

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# When zero we link against libmmcamera; when 1, we dlopen libmmcamera.
DLOPEN_LIBMMCAMERA := 1

LOCAL_CFLAGS += -DHW_ENCODE 

LOCAL_C_INCLUDES += system/media/camera/include

LOCAL_SRC_FILES := \
    QualcommCamera.cpp \
    QualcommCameraHardware.cpp \
    QCameraParameters.cpp

LOCAL_CFLAGS += -DUSE_ION
LOCAL_CFLAGS += -DNUM_PREVIEW_BUFFERS=4

LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
LOCAL_C_INCLUDES += \
    $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include \
    hardware/qcom/display-$(TARGET_QCOM_DISPLAY_VARIANT)/$(TARGET_BOARD_PLATFORM)/libgralloc \
    hardware/qcom/display-$(TARGET_QCOM_DISPLAY_VARIANT)/$(TARGET_BOARD_PLATFORM)/libgenlock \
    hardware/qcom/media-$(TARGET_QCOM_MEDIA_VARIANT)/$(TARGET_BOARD_PLATFORM)/libstagefrighthw

LOCAL_SHARED_LIBRARIES := \
    libcamera_client \
    libcutils \
    liblog \
    libui \
    libutils

LOCAL_SHARED_LIBRARIES += libgenlock libbinder

ifeq ($(DLOPEN_LIBMMCAMERA),1)
    LOCAL_SHARED_LIBRARIES += libdl
    LOCAL_CFLAGS += -DDLOPEN_LIBMMCAMERA
else
    LOCAL_SHARED_LIBRARIES += liboemcamera
endif

# Proprietary extension
LOCAL_SHARED_LIBRARIES += libmmjpeg
$(shell mkdir -p $(OUT)/obj/SHARED_LIBRARIES/libmmjpeg_intermediates/)
$(shell touch $(OUT)/obj/SHARED_LIBRARIES/libmmjpeg_intermediates/export_includes)

LOCAL_MODULE_PATH := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS := optional
include $(BUILD_SHARED_LIBRARY)

endif # BUILD_TINY_ANDROID
endif # BOARD_USES_QCOM_HARDWARE
endif # USE_CAMERA_STUB
