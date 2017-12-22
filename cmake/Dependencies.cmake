# library definition happens later, so add define flags to a list first
set(_mshadow_DEFINES)
set(_mshadow_INCLUDE_DIRS)
set(_mshadow_DEPENDENCY_LIBS)

# ---[ Initial switch to disable searching for libs
if(MSHADOW_STANDALONE)
  message(WARNING "Building mshadow in standalone mode")
  set(USE_CUDA OFF)
  set(USE_BLAS OFF)
endif()

# ---[ BLAS
if(USE_BLAS)
  set(BLAS "MKL" CACHE STRING "Selected BLAS library")
  set_property(CACHE BLAS PROPERTY STRINGS "ATLAS;OpenBLAS;MKL")
  message(STATUS "The BLAS backend of choice:" ${BLAS})

  if(BLAS STREQUAL "ATLAS")
    find_package(Atlas REQUIRED)
    list(APPEND _mshadow_INCLUDE_DIRS ${ATLAS_INCLUDE_DIRS})
    list(APPEND _mshadow_DEPENDENCY_LIBS ${ATLAS_LIBRARIES})
    list(APPEND _mshadow_DEPENDENCY_LIBS cblas)
    list(APPEND _mshadow_DEFINES MSHADOW_USE_CBLAS=1;MSHADOW_USE_MKL=0)
  elseif(BLAS STREQUAL "OpenBLAS")
    find_package(OpenBLAS REQUIRED)
    list(APPEND _mshadow_INCLUDE_DIRS ${OpenBLAS_INCLUDE_DIR})
    list(APPEND _mshadow_DEPENDENCY_LIBS ${OpenBLAS_LIB})
    list(APPEND _mshadow_DEFINES MSHADOW_USE_CBLAS=1;MSHADOW_USE_MKL=0)
  elseif(BLAS STREQUAL "MKL")
    find_package(MKL REQUIRED)
    list(APPEND _mshadow_INCLUDE_DIRS ${MKL_INCLUDE_DIR})
    list(APPEND _mshadow_DEPENDENCY_LIBS ${MKL_LIBRARIES})
    list(APPEND _mshadow_DEFINES MSHADOW_USE_CBLAS=0;MSHADOW_USE_MKL=1)
  else()
    message(FATAL_ERROR "Unrecognized blas option:" ${BLAS})
  endif()
else()
    list(APPEND _mshadow_DEFINES MSHADOW_USE_CBLAS=0;MSHADOW_USE_MKL=0)
endif(USE_BLAS)

# ---[ CUDA, CUDNN, and CUSOLVER
if(USE_CUDA)
  list(APPEND _mshadow_DEFINES MSHADOW_USE_CUDA=1)

  # ---[ CuDNN support
  if(USE_CUDNN)
    find_package(CUDNN 5.5 REQUIRED)
    list(APPEND _mshadow_INCLUDE_DIRS ${CUDNN_INCLUDE_DIRS})
    list(APPEND _mshadow_DEPENDENCY_LIBS ${CUDNN_LIBRARIES})
    list(APPEND _mshadow_DEFINES MSHADOW_USE_CUDNN=1)

  else()
    message(WARNING "CUDA enabled, but not compiling with CuDNN.")
  endif()

  # ---[ CUSOLVER support
  if(USE_CUSOLVER)
    # assume cusolver will be found if cuda is found. Not sure if true.
    #find_package(CUSOLVER REQUIRED)
    #list(APPEND _mshadow_INCLUDE_DIRS ${CUDNN_INCLUDE_DIRS})
    #list(APPEND _mshadow_DEPENDENCY_LIBS ${CUDNN_LIBRARIES})
    list(APPEND _mshadow_DEFINES MSHADOW_USE_CUSOLVER=1)
  else()
    list(APPEND _mshadow_DEFINES MSHADOW_USE_CUSOLVER=0)
    message(WARNING "CUDA enabled, but not compiling with cuSolver.")
  endif()
else(USE_CUDA)
  list(APPEND _mshadow_DEFINES STRINGS MSHADOW_USE_CUDA=0)
endif()

include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)

if(COMPILER_SUPPORTS_CXX11)
  list(APPEND _mshadow_DEFINES MSHADOW_IN_CXX11=1)
endif()

list(APPEND _mshadow_DEFINES MSHADOW_FORCE_STREAM=${MSHADOW_FORCE_STREAM})
list(APPEND _mshadow_DEFINES USE_SSE=${USE_SSE})
