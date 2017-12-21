# require cmake 3.9 for native CUDA support
cmake_minimum_required(VERSION 3.9)

project(mshadow LANGUAGES CXX)

# options from  "make/mshadow.mk"
#option(USE_SSE "Enable the use of SSE3" ON CACHE)
option(USE_CUDA "Use CUDA" OFF CACHE)
option(USE_CUDNN "Use CuDNN" OFF CACHE)
option(USE_CUSOLVER "Use CUSOLVER" OFF CACHE)
option(USE_BLAS "Enable BLAS" OFF CACHE)
option(MSHADOW_STANDALONE "mshadow should compile without any other libs" OFF
  CACHE ADVANCED)
option(MSHADOW_FORCE_STREAM "force user to use GPU stream" ON CACHE ADVANCED)
#option(USE_STATIC_MKL "When using MKL, link statically" OFF CACHE ADVANCED)

# ---{ Enable CUDA language if selected
if(USE_CUDA)
  enable_language(CUDA)
endif()

# ---[ Extra CMake Modules
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

# ---[ Dependencies
include(cmake/Dependencies.cmake)

# ---[ Main build
add_subdirectory(mshadow)
