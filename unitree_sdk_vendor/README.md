# unitree_sdk_vendor

Vendors the latest `main` branch of
[Unitree SDK2](https://github.com/unitreerobotics/unitree_sdk2) using
`ament_cmake_vendor_package`.

Upstream ships a prebuilt static SDK library and bundled Cyclone DDS shared
libraries for **Linux x86_64 and aarch64**. This package installs those libraries
and their headers; examples are disabled. The patch exports the C++17 requirement
and installs upstream and third-party license notices alongside the SDK.

## Build and test

From a ROS 2 workspace with ROS sourced:

```sh
rosdep install --from-paths src/Vendors/unitree_sdk_vendor --ignore-src -r -y
colcon build --packages-select unitree_sdk_vendor
. install/setup.sh
colcon test --packages-select unitree_sdk_vendor --event-handlers console_direct+
colcon test-result --verbose
```

Fresh builds require GitHub access and fetch the latest commit on `main`.
The vendor build caches downloaded sources, so incremental builds reuse the
existing checkout. To fetch the latest `main` again, remove this package's build
directory and rebuild from the workspace root:

```sh
rm -rf build/unitree_sdk_vendor
colcon build --packages-select unitree_sdk_vendor
```

Tests are enabled by default (`BUILD_TESTING=ON`). The separate CMake consumer
in `test/` checks installed robot, channel, and message headers, links against
`unitree_sdk2`, and calls a compiled time utility. It does not initialize DDS or
connect to a robot. Hardware communication is outside the scope of this test.

## Use from another package

Declare `<depend>unitree_sdk_vendor</depend>` in `package.xml`, then:

```cmake
find_package(unitree_sdk_vendor REQUIRED)
find_package(unitree_sdk2 REQUIRED CONFIG)

target_link_libraries(your_target PRIVATE unitree_sdk2)
```

For example:

```cpp
#include <unitree/robot/go2/sport/sport_client.hpp>
```

The vendor environment hook adds the bundled DDS libraries to the library search
path when the workspace is sourced. The upstream target also exports the SDK
and DDS include paths and transitive link dependencies.

When upstream changes, the patch may need rebasing. Rerun the build and tests
on each supported architecture after refreshing the sources.
