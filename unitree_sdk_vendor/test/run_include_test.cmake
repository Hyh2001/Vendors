# Configure a separate consumer after the vendor has built and installed.
# This checks installed headers and target exports without source-tree includes.
execute_process(
  COMMAND "${CMAKE_COMMAND}" -S "${TEST_SOURCE_DIR}" -B "${TEST_BINARY_DIR}"
    "-DCMAKE_PREFIX_PATH=${UNITREE_PREFIX}"
  RESULT_VARIABLE result)
if(NOT result EQUAL 0)
  message(FATAL_ERROR "Unitree SDK2 consumer configuration failed: ${result}")
endif()

execute_process(
  COMMAND "${CMAKE_COMMAND}" --build "${TEST_BINARY_DIR}" --config "${TEST_CONFIG}"
  RESULT_VARIABLE result)
if(NOT result EQUAL 0)
  message(FATAL_ERROR "Unitree SDK2 include/link test failed: ${result}")
endif()

execute_process(
  COMMAND "${CMAKE_CTEST_COMMAND}" --test-dir "${TEST_BINARY_DIR}"
    -C "${TEST_CONFIG}" --output-on-failure
  RESULT_VARIABLE result)
if(NOT result EQUAL 0)
  message(FATAL_ERROR "Unitree SDK2 runtime test failed: ${result}")
endif()
