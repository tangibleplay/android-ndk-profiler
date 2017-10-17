LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_CFLAGS := -fvisibility=hidden -DDEBUG
LOCAL_MODULE    := android-ndk-profiler
LOCAL_SRC_FILES := prof.c read_maps.c

ifeq ($(TARGET_ARCH_ABI), armeabi-v7a)
LOCAL_CFLAGS += -DTARGET_ARM
LOCAL_SRC_FILES += gnu_mcount.arm.S
endif

ifeq ($(TARGET_ARCH_ABI), arm64-v8a)
LOCAL_CFLAGS += -DTARGET_ARM64
LOCAL_SRC_FILES += gnu_mcount.arm64.S
endif

ifeq ($(TARGET_ARCH_ABI), x86)
LOCAL_CFLAGS += -DTARGET_X86
LOCAL_SRC_FILES += gnu_mcount.x86.S
endif

include $(BUILD_STATIC_LIBRARY)
