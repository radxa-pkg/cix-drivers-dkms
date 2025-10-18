targets := gpu/drivers/base/arm/memory_group_manager/memory_group_manager.ko \
		   gpu/drivers/base/arm/protected_memory_allocator/protected_memory_allocator.ko \
		   gpu/drivers/gpu/arm/midgard/mali_kbase.ko \
		   vpu/bin/aarch64-linux-gnu/amvx.ko \
		   isp/armcb_isp_v4l2.ko \
		   npu/driver/aipu.ko

all: $(targets)

gpu/drivers/base/arm/memory_group_manager/memory_group_manager.ko \
gpu/drivers/base/arm/protected_memory_allocator/protected_memory_allocator.ko \
gpu/drivers/gpu/arm/midgard/mali_kbase.ko &:
	$(MAKE) -C gpu all

vpu/bin/aarch64-linux-gnu/amvx.ko:
	scons -j$(shell nproc) target=linux

isp/armcb_isp_v4l2.ko:
	ln -sf $(KDIR) linux
	cd isp && $(MAKE) -C . build \
		PATH_ROOT=$(PWD) \
		ARCH=arm64 \
		CROSS_COMPILE=

npu/driver/aipu.ko:
	cd npu/driver && $(MAKE) -C $(KDIR) M=$(PWD)/npu/driver modules \
		COMPASS_DRV_BTENVAR_KPATH=$(KDIR) \
		BUILD_AIPU_VERSION_KMD=BUILD_ZHOUYI_V3 \
		COMPASS_DRV_BTENVAR_KMD_VERSION=5.11.0 \
		BUILD_TARGET_PLATFORM_KMD=BUILD_PLATFORM_SKY1 \
		BUILD_NPU_DEVFREQ=y

clean:
	$(MAKE) -C gpu clean
	scons -C vpu --clean
	$(MAKE) -C isp clean
	$(MAKE) -C npu/driver clean
	rm linux
