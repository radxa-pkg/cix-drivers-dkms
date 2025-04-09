all:
	$(MAKE) -C gpu/drivers/gpu/arm \
		CONFIG_MALI_BASE_MODULES=y \
		CONFIG_MALI_PLATFORM_NAME="sky1" \
		CONFIG_MALI_CSF_SUPPORT=y \
		CONFIG_MALI_CIX_POWER_MODEL=y

	$(MAKE) -C gpu/drivers/base/arm \
		CONFIG_MALI_BASE_MODULES=y \
		CONFIG_MALI_PLATFORM_NAME="sky1" \
		CONFIG_MALI_CSF_SUPPORT=y \
		CONFIG_MALI_MEMORY_GROUP_MANAGER=y \
		CONFIG_MALI_PROTECTED_MEMORY_ALLOCATOR=y \
		CONFIG_MALI_CIX_POWER_MODEL=y

	scons -j$(shell nproc) -C vpu

	ln -sf $(KSRC) linux
	cd isp && $(MAKE) -C . build \
		PATH_ROOT=$(PWD) \
		ARCH=arm64 \
		CROSS_COMPILE=

	cd npu/driver && $(MAKE) -C $(KSRC) M=$(PWD)/npu/driver modules \
		COMPASS_DRV_BTENVAR_KPATH=$(KSRC) \
		BUILD_AIPU_VERSION_KMD=BUILD_ZHOUYI_V3 \
		COMPASS_DRV_BTENVAR_KMD_VERSION=5.8.0 \
		BUILD_TARGET_PLATFORM_KMD=BUILD_PLATFORM_SKY1 \
		BUILD_NPU_DEVFREQ=y

clean:
	$(MAKE) -C gpu/drivers/gpu/arm clean
	$(MAKE) -C gpu/drivers/base/arm clean
	scons -C vpu --clean
	$(MAKE) -C isp clean
	$(MAKE) -C npu/driver clean
	rm linux
