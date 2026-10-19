cmake_minimum_required(VERSION 3.16)
project(unitree_sdk_vendor)

find_package(ament_cmake REQUIRED)
find_package(ament_cmake_vendor_package REQUIRED)

if(NOT CMAKE_SYSTEM_NAME STREQUAL "Linux" OR
    NOT CMAKE_SYSTEM_PROCESSOR MATCHES "^(x86_64|aarch64)$")
  message(FATAL_ERROR "Unitree SDK2 provides prebuilt libraries only for Linux x86_64 and aarch64")
endif()

ament_vendor(unitree_sdk2_external
  VCS_URL https://github.com/unitreerobotics/unitree_sdk2.git
  VCS_VERSION main
  PATCHES patches/0001-export-standard-and-install-licenses.patch
  CMAKE_ARGS
    -DBUILD_EXAMPLES=OFF
    -DCMAKE_BUILD_TYPE=Release
    -DCMAKE_INSTALL_LIBDIR=lib
)

include(CTest)
if(BUILD_TESTING)
  add_test(NAME unitree_sdk_include_test
    COMMAND "${CMAKE_COMMAND}"
      "-DTEST_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}/test"
      "-DTEST_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}/test"
      "-DUNITREE_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/unitree_sdk2_external-prefix/install"
      "-DTEST_CONFIG=$<CONFIG>"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/test/run_include_test.cmake"
  )
endif()

ament_package()
