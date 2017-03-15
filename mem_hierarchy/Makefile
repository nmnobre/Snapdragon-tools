ANDROID_NDK = /opt/android-ndk-r13b

FC = $(ANDROID_NDK)/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-gfortran
FFLAGS = -Wall -Wfatal-errors -O2 -fPIE
LDFLAGS = -fPIE -pie --sysroot=$(ANDROID_NDK)/platforms/android-23/arch-arm64/

EXEC_ARM = vec_aarch64
SOURCE = vec.f

$(EXEC_ARM): $(SOURCE)
	$(FC) $(FFLAGS) $(SOURCE) -o $(EXEC_ARM) $(LDFLAGS)

.PHONY: clean
clean:
	rm -f $(EXEC_ARM)