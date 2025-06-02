cmake_minimum_required(VERSION 3.13)
project(runner LANGUAGES CXX)

# Define the application target. To change its name, change BINARY_NAME in the
# top-level CMakeLists.txt, not the value here, or `flutter run` will no longer
# work.
#
# Any new source files that you add to the application should be added here.
add_executable(${BINARY_NAME}
  "main.cc"
  "my_application.cc"
  "get-buffer-test/buffer.cpp"
  "get-buffer-test/display/texture.cpp"
  "get-buffer-test/get_buffer_test.cpp"
  "get-buffer-test/protocols/hyprland-toplevel-export-v1-protocol.cpp"
  "get-buffer-test/protocols/wlr-foreign-toplevel-management-unstable-v1-protocol.cpp"
  "get-buffer-test/protocols/wlr-screencopy-unstable-v1-protocol.cpp"
  "get-buffer-test/protocols/xdg-output-unstable-v1-protocol.cpp"
  "${FLUTTER_MANAGED_DIR}/generated_plugin_registrant.cc"
)

# Custom
include_directories("get-buffer-test/protocols/")
pkg_get_variable(WaylandScanner wayland-scanner wayland_scanner)
message(STATUS "Found WaylandScanner at ${WaylandScanner}")
pkg_get_variable(WAYLAND_PROTOCOLS_DIR wayland-protocols pkgdatadir)
message(STATUS "Found wayland-protocols at ${WAYLAND_PROTOCOLS_DIR}")
pkg_get_variable(WAYLAND_SERVER_DIR wayland-server pkgdatadir)

function(protocol protoPath protoName external)
  if (external)
    execute_process(
      COMMAND ${WaylandScanner} client-header ${protoPath} get-buffer-test/protocols/${protoName}-protocol.h
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    execute_process(
      COMMAND ${WaylandScanner} private-code ${protoPath} get-buffer-test/protocols/${protoName}-protocol.c
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    target_sources(${BINARY_NAME} PRIVATE get-buffer-test/protocols/${protoName}-protocol.cpp)
  else()
    execute_process(
      COMMAND ${WaylandScanner} client-header ${WAYLAND_PROTOCOLS_DIR}/${protoPath} get-buffer-test/protocols/${protoName}-protocol.h
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    execute_process(
      COMMAND ${WaylandScanner} private-code ${WAYLAND_PROTOCOLS_DIR}/${protoPath} get-buffer-test/protocols/${protoName}-protocol.c
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    target_sources(${BINARY_NAME} PRIVATE get-buffer-test/protocols/${protoName}-protocol.cpp)
  endif()
endfunction()

protocol("protocol/hyprland-toplevel-export-v1.xml" "hyprland-toplevel-export-v1" true)
protocol("protocol/wlr-foreign-toplevel-management-unstable-v1.xml" "wlr-foreign-toplevel-management-unstable-v1" true)
protocol("protocol/wlr-screencopy-unstable-v1.xml" "wlr-screencopy-unstable-v1" true)
protocol("protocol/xdg-output-unstable-v1.xml" "xdg-output-unstable-v1" true)
# END CUSTOM



# Apply the standard set of build settings. This can be removed for applications
# that need different build settings.
apply_standard_settings(${BINARY_NAME})

# Add preprocessor definitions for the application ID.
add_definitions(-DAPPLICATION_ID="${APPLICATION_ID}")

# Add dependency libraries. Add any application-specific dependencies here.
target_link_libraries(${BINARY_NAME} PRIVATE flutter)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTK)

target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::WAYLANDCLIENT)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::WAYLANDPROTOS)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::GTKLAYERSHELL)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::LIBEGL)
target_link_libraries(${BINARY_NAME} PRIVATE PkgConfig::EPOXY)


target_include_directories(${BINARY_NAME} PRIVATE "${CMAKE_SOURCE_DIR}")
