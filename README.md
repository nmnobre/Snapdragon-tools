<img src="https://image.freepik.com/free-icon/wrench-and-pick-hammer-outline_318-44758.jpg" height="256"> <img src="https://cdn3.iconfinder.com/data/icons/google-material-design-icons/48/ic_keyboard_arrow_right_48px-256.png" height="256"> <img src="http://www.qualcomm.cn/sites/regional/files/styles/optimize/public/component-item/flexible-block/chip_0.png?itok=PpoXam0G" height="256">

# snapdragon tools

A set of tools to probe the cache system and dynamically scale the frequency of the Qualcomm® Snapdragon™ 820 processor.

## Probing the cache hierarchy

Under ./mem_hierarchy/ there are two files, vec_consecutive.f and vec_mirror.f, which contain Fortran source code based on an older version written in 1997 by Mark Bull.
The former does repeated sums over equally spaced elements of an increasingly bigger vector. As the total number of operations performed by the CPU would otherwise change with the size of the vector, the program does as many passes though the vector as necessary to keep them (approximately) constant across the different sized vectors. This version improves on Bull's work by reversing the vector initialization loop so that fewer misses occur during the first pass through the vector. This seems to make the "cliffs" corresponding to cache size limits more unambiguous.
The latter