cmake_minimum_required(VERSION 3.16)
project(placo_include_test LANGUAGES CXX)

find_package(placo REQUIRED CONFIG)

add_executable(placo_include_test include_test.cpp)
target_link_libraries(placo_include_test PRIVATE placo::placo)

enable_testing()
add_test(NAME include_and_solve COMMAND placo_include_test)
