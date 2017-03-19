ANDROID_NDK = /opt/android-ndk-r13b

FC_aarch64 = $(ANDROID_NDK)/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin/aarch64-linux-android-gfortran
FC_x86_64 = gfortran
FFLAGS = -Wall -Wfatal-errors -O2 -fPIE -std=f2008
LDFLAGS = -fPIE -pie --sysroot=$(ANDROID_NDK)/platforms/android-23/arch-arm64/

EXEC_ARM = vec_aarch64
EXEC_x86_64 = vec_x86_64
SOURCE = vec_mirror.f

.PHONY: all
all: $(EXEC_x86_64) $(EXEC_ARM)

$(EXEC_ARM): $(SOURCE)
	$(FC_aarch64) $(FFLAGS) $(SOURCE) -o $(EXEC_ARM) $(LDFLAGS)

$(EXEC_x86_64): $(SOURCE_FILES)
	$(FC_x86_64) $(FFLAGS) -o $(EXEC_x86_64) $(SOURCE)

.PHONY: clean
clean:
	rm -f $(EXEC_ARM) $(EXEC_x86_64)