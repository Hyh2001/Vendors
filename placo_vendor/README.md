# placo_vendor

Vendors the C++ library from [PlaCo](https://placo.readthedocs.io/en/latest/),
a whole-body inverse kinematics and dynamics solver, using
`ament_cmake_vendor_package`. Upstream tracks the latest commit on the
`master` branch when sources are fetched.

The patch disables Python bindings and stub generation, installs public headers
(including the bundled qpmad headers), and exports a relocatable `placo::placo`
CMake target. A second patch uses the current Pinocchio `parentJoint` frame
member for compatibility with Pinocchio 3 and 4. Python users can install the upstream `placo` distribution separately.
Upstream MIT and qpmad Apache-2.0 license notices are installed with the library.

## Build

From your ROS 2 workspace, with ROS sourced:

```sh
rosdep install --from-paths src/Vendors/placo_vendor --ignore-src -r -y
colcon build --packages-select placo_vendor
. install/setup.sh
```

The build fetches the `master` branch from GitHub. Eigen, Pinocchio (including
its transitive dependencies), and JsonCpp must be available through CMake.
For dependencies installed outside the ROS or system prefix, add their prefix
to `CMAKE_PREFIX_PATH` before building. No upstream system installation script
is run by this package.

## Test

After building, run:

```sh
colcon test --packages-select placo_vendor --event-handlers console_direct+
colcon test-result --verbose
```

The `test/` folder contains a separate CMake consumer that includes the installed
kinematics, dynamics, and problem headers, links against `placo::placo`, and
solves `x = 1`. Missing headers, broken CMake exports, link errors, or an incorrect
solver result fail the test. Build with `BUILD_TESTING=ON` (the default) to enable it.

## Use from another package

Declare `<depend>placo_vendor</depend>` in `package.xml`, then:

```cmake
find_package(placo_vendor REQUIRED)
find_package(placo REQUIRED CONFIG)

target_link_libraries(your_target PRIVATE placo::placo)
```

For example, public headers can be included as
`#include <placo/kinematics/kinematics_solver.h>`.

The vendor build caches downloaded sources. To fetch the latest `master` again,
remove `build/placo_vendor` and rebuild the package. Upstream changes may require
updating the patches in `patches/`; verify a build and downstream CMake consumer
after refreshing sources.
