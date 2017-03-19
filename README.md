<img src="https://image.freepik.com/free-icon/wrench-and-pick-hammer-outline_318-44758.jpg" height="256"> <img src="https://cdn3.iconfinder.com/data/icons/google-material-design-icons/48/ic_keyboard_arrow_right_48px-256.png" height="256"> <img src="http://www.qualcomm.cn/sites/regional/files/styles/optimize/public/component-item/flexible-block/chip_0.png?itok=PpoXam0G" height="256">

# snapdragon tools

A set of tools to probe the cache system and dynamically scale the frequency of the Qualcomm® Snapdragon™ 820 processor.

## Probing the cache hierarchy

Under `./mem_hierarchy/` there are two files, `vec_consecutive.f` and `vec_mirror.f`, which contain Fortran source code based on an older version written in 1997 by Mark Bull.

`vec_consecutive.f` does repeated sums over equally spaced elements of an increasingly bigger vector. As the total number of operations performed by the CPU would otherwise change with the size of the vector, the program does as many passes though the vector as necessary to keep them (approximately) constant across the different sized vectors. This version improves on Bull's work by reversing the vector initialization loop so that fewer misses occur during the first pass through the vector. This seems to make the "cliffs" corresponding to cache size limits more unambiguous. Additionally, an effort was made to make the code compliant with the Fortran 2008 standard and to print the timing and performance results as consistently as possible by normalizing the values with respect to the number of operations actually performed.

`vec_mirror.f` does essentially the same as the above with the exception that the vector elements are not fetched consecutively using some constant stride but instead using a mirror image style scheme. The easiest way to visualise this is by imagining that the *n* elements used in a given vector pass are determined *a priori* and then fetched in the following order: 1, *n*, 2, *n*-1, 3, *n*-2,... The aim of such ordering is hardening the task of software (via compilers) and hardware (via prefetchers) loop optimizations that can hide cache misses.

Additionally, a `Makefile` is provided to automate the compiling process. By default, strict conformance to the Fortran 2008 standard is required and the optimization flag `-O2` is passed to the compiler. Starting with Android™ 5.0, position-independent executables are mandatory and, as such, `-fPIE` is also passed to the compiler and `-fPIE -pie` to the linker. In addition to the rule targeting AArch64, there is also a rule targeting x86_64 for comparison purposes. Please note that you will need a Fortran compiler that can target ARM® Android™ devices. Such an example can be found [here](https://github.com/buffer51/android-gfortran "android-gfortran"). This is an excellent tutorial on how to extend the GNU toolchain bundled with the Android™ NDK with Fortran support that also includes prebuilt versions ready to use. As you probably do not want to mess with your vanilla Android™ NDK installation, you can simple change the `ANDROID_NDK` variable inside said `Makefile` to point to the modified version, i.e., the one with `gfortran`.

## Dynamic frequency scaling

To be written...