cmake_minimum_required(VERSION 3.16)
project(unitree_sdk_include_test LANGUAGES CXX)

find_package(unitree_sdk2 REQUIRED CONFIG)

add_executable(unitree_sdk_include_test include_test.cpp)
target_link_libraries(unitree_sdk_include_test PRIVATE unitree_sdk2)

enable_testing()
add_test(NAME include_and_link COMMAND unitree_sdk_include_test)
