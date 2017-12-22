# require cmake 3.9 for native CUDA support
cmake_minimum_required(VERSION 3.9)

project(mshadow LANGUAGES CXX)

# options from  "make/mshadow.mk"
#option(USE_SSE "Enable the use of SSE3" ON CACHE)
option(USE_CUDA "Use CUDA" OFF)
option(USE_CUDNN "Use CuDNN" OFF)
option(USE_CUSOLVER "Use CUSOLVER" OFF)
option(USE_BLAS "Enable BLAS" OFF)

option(MSHADOW_STANDALONE "mshadow should compile without any other libs" OFF)
option(MSHADOW_FORCE_STREAM "force user to use GPU stream" ON)

#option(USE_STATIC_MKL "When using MKL, link statically" OFF CACHE ADVANCED)
#option(MSHADOW_USE_SSE "Use SSE instructions" ${USE_SSE} CACHE ADVANCED)
# don't need option option to enable C++11 support, cmake does it
#option(MSHADOW_USE_GLOG "Enable google logging" OFF CACHE ADVANCED)

# ---{ Enable CUDA language if selected
if(USE_CUDA)
  enable_language(CUDA)
endif()

# ---[ Extra CMake Modules
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

# ---[ Dependencies
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)
include(cmake/Dependencies.cmake)

# ---[ Define installation locations
set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")
set(config_install_dir "lib/cmake/${PROJECT_NAME}")

# ---[ Main build
add_subdirectory(mshadow)
add_subdirectory(test)

# ---[ installation support
# Layout. 
#   * <prefix>/bin/
#   * <prefix>/lib/
#   * <prefix>/lib/cmake/mshadow
#   * <prefix>/include/

# Configuration

# Configure '<PROJECT-NAME>ConfigVersion.cmake'
# Use:
#   * PROJECT_VERSION
#write_basic_package_version_file("${version_config}" COMPATIBILITY SameMajorVersion)

# Configure '<PROJECT-NAME>Config.cmake'
# Use variables:
#   * TARGETS_EXPORT_NAME
#   * PROJECT_NAME
configure_package_config_file(
  "cmake/Config.cmake.in" "${project_config}" 
  INSTALL_DESTINATION "${CMAKE_INSTALL_LIBDIR}/cmake/Mshadow"
  )
