cmake_minimum_required(VERSION 3.16)
project(placo_vendor)

find_package(ament_cmake REQUIRED)
find_package(ament_cmake_vendor_package REQUIRED)

ament_vendor(placo_external
  VCS_URL https://github.com/Rhoban/placo.git
  VCS_VERSION master
  PATCHES
    patches/0001-install-cpp-package.patch
    patches/0002-pinocchio-parent-joint.patch
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_LIBDIR=lib
)

include(CTest)
if(BUILD_TESTING)
  add_test(NAME placo_include_test
    COMMAND "${CMAKE_COMMAND}"
      "-DTEST_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}/test"
      "-DTEST_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}/test"
      "-DPLACO_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/placo_external-prefix/install"
      "-DTEST_CONFIG=$<CONFIG>"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/test/run_include_test.cmake"
  )
endif()

ament_package()
