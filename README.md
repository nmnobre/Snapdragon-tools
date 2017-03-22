<img src="https://image.freepik.com/free-icon/wrench-and-pick-hammer-outline_318-44758.jpg" height="256"> <img src="https://cdn3.iconfinder.com/data/icons/google-material-design-icons/48/ic_keyboard_arrow_right_48px-256.png" height="256"> <img src="http://www.qualcomm.cn/sites/regional/files/styles/optimize/public/component-item/flexible-block/chip_0.png?itok=PpoXam0G" height="256">

# snapdragon tools

A set of tools to probe the cache system and dynamically scale the frequency of the Qualcomm Snapdragon 820 processor on Android devices.

## Probing the cache hierarchy

Under `./mem_hierarchy/` there are three files of which two, `vec_consecutive.f` and `vec_mirror.f`, contain Fortran source code based on an older version written in 1997 by Mark Bull.

The following is a brief explanation of *what* the code does. For information on *how* to actually use the compiled binaries, please run them with the `-h` flag.

`vec_consecutive.f` does repeated sums over equally spaced elements of an increasingly bigger vector. As the total number of operations performed by the CPU would otherwise change with the size of the vector, the program does as many passes though the vector as necessary to keep them (approximately) constant across the different sized vectors. This version improves on Bull's work by reversing the vector initialization loop so that fewer misses occur during the first pass through the vector. This seems to make the "cliffs" corresponding to cache size limits more unambiguous. Additionally, an attempt was made to comply with the modern Fortran 2008 standard and to print the timing and performance results as consistently as possible by normalizing the values with respect to the number of operations actually performed.

`vec_mirror.f` does essentially the same as the above with the exception that the vector elements are not fetched consecutively using some constant stride but instead using a mirror image style scheme. The easiest way to visualise this is by imagining that the *n* elements used in a given vector pass are determined *a priori* and then fetched in the following order: 1, *n*, 2, *n*-1, 3, *n*-2,... The aim of such ordering is hardening the task of compilers performing loop optimizations and hardware prefetchers that can effectively hide cache misses.

Additionally, a `Makefile` is provided to automate the compiling process. By default, strict conformance to the Fortran 2008 standard is required and the optimization flag `-O2` is passed to the compiler. Starting with Android 5.0, position-independent executables are mandatory and, as such, `-fPIE` is also passed to the compiler and `-fPIE -pie` to the linker. In addition to the rule targeting AArch64 (`vec_aarch64`), there is also a rule targeting x86_64 (`vec_x86_64`) for comparison purposes. The default rule simply builds both binaries from `vec_mirror.f`. The latter can be changed by modifying the `SOURCE` variable. Please note that you will need a Fortran compiler that can target ARM Android devices. Such an example can be found [here](https://github.com/buffer51/android-gfortran "android-gfortran"). This is an excellent tutorial on how to extend the GNU toolchain bundled with the Android NDK with Fortran support that also includes prebuilt versions ready to use. As you probably do not want to mess with your vanilla Android NDK installation, you can simple change the `ANDROID_NDK` variable inside said `Makefile` to point to the modified version, i.e., the one with `gfortran`.

## Dynamic frequency scaling

Under `./freq_scaling/` there are three utilities, `check.sh`, `scaling.sh` and `switch.sh`, under the form of shell scripts. These were written from the ground up with MirBSD Korn Shell (`mksh`) compatibility in mind. This is a bourne-compatible and mostly POSIX 2008 compliant UNIX shell, similar to the original AT&T Korn shell, that is included with Android and, thus, invoked when one runs `$ adb shell`. The syntax used is also compatible with the widely used Bourne-Again Shell (`bash`).

The following is a brief explanation of *what* the tools are supposed to do. For information on *how* to actually use said tools, please run them with the `-h` flag.

`check.sh` is arguably the most simple utility of the collection as it just repeatedly fetches and prints the frequencies of each and every core (physical cores or logical cores in the case of simultaneous multithreading) in the host CPU at constant time intervals. This is the only tool of the set which has also been tested to run *as is* on Linux x86_64 machines.

`scaling.sh` is perhaps the most powerful tool as it allows changing the governor and dinamically set the speed of the cores of individual clusters of the Qualcomm Snapdragon 820. It is possible to control the speed of the low-power cluster cores only, of the high-performance cluster cores only or both.

`switch.sh` allows switching specific cores on/off. As it name would suggest, the tool behaves exactly like a switch: if the specified core is on, it is turned off, and vice-versa. Please be aware that on the testbed system used, the Open-Q 820 development kit, turning off cores (even the low-power/low-performance ones) results in weird slowness not yet fully understood. For this reason, any information/results gathered after using this tool (or any other method of managing online/offline cores) should be carefully analysed.