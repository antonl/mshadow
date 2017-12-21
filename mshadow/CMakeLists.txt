# build the mshadow interface library

  # ---[ mshadow library
add_library(mshadow INTERFACE)

target_sources(mshadow PUBLIC 
  base.h
  expression.h
  extension.h
  half.h
  io.h
  logging.h
  packet-inl.h
  random.h
  tensor_container.h
  half2.h
  tensor.h
  tensor_cpu-inl.h
  tensor_gpu-inl.h
  dot_engine-inl.h
  expr_engine-inl.h
  expr_scalar-inl.h
  stream_gpu-inl.h

  cuda/tensor_gpu-inl.cuh
  cuda/reduce.cuh
  
  extension/broadcast.h
  extension/broadcast_with_axis.h
  extension/channel_pool.h
  extension/channel_unpool.h
  extension/choose.h
  extension/complex.h
  extension/concat.h
  extension/crop.h
  extension/fill.h
  extension/flip.h
  extension/implicit_gemm.h
  extension/mask.h
  extension/mirror.h
  extension/one_hot.h
  extension/pack_col2patch.h
  extension/pad.h
  extension/range.h
  extension/reduce_with_axis.h
  extension/reduceto1d.h
  extension/reshape.h
  extension/slice.h
  extension/slice_ex.h
  extension/spatial_pool.h
  extension/spatial_unpool.h
  extension/spatial_upsampling_nearest.h
  extension/swapaxis.h
  extension/take.h
  extension/take_grad.h
  extension/transpose.h
  extension/unpack_patch2col.h

  packet/plain-inl.h
  packet/sse-inl.h
 )

# ---[ Add dependencies to interface target
target_include_directories(mshadow INTERFACE ${_mshadow_INCLUDE_DIRS})
target_compile_definitions(mshadow INTERFACE ${_mshadow_DEFINES})
target_link_libraries(mshadow INTERFACE ${_mshadow_DEPENDENCY_LIBS})

# ---[ add test executables
if(USE_CUDA)
  add_executable(test test/test.cu)
  add_executable(pairtest test/pairtest.cu)
  add_executable(pair test/pair.cu)
  add_executable(pool test/pool.cu)
  add_executable(reshape test/reshape.cu)
  add_executable(unpack test/unpack.cu)

  target_link_libaries(test PRIVATE mshadow)
  target_link_libaries(pairtest PRIVATE mshadow)
  target_link_libaries(pair PRIVATE mshadow)
  target_link_libaries(pool PRIVATE mshadow)
  target_link_libaries(reshape PRIVATE mshadow)
  target_link_libaries(unpack PRIVATE mshadow)
endif()

# ---[ installation support
include(CMakePackageConfigHelpers)
include(GNUInstallDirs)
# Layout. 
#   * <prefix>/bin/
#   * <prefix>/lib/
#   * <prefix>/lib/cmake/mshadow
#   * <prefix>/include/

# Configuration
set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")
set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")

set(config_install_dir "lib/cmake/${PROJECT_NAME}")J

# Configure '<PROJECT-NAME>ConfigVersion.cmake'
# Use:
#   * PROJECT_VERSION
#write_basic_package_version_file("${version_config}" COMPATIBILITY SameMajorVersion)

# Configure '<PROJECT-NAME>Config.cmake'
# Use variables:
#   * TARGETS_EXPORT_NAME
#   * PROJECT_NAME
configure_package_config_file("cmake/Config.cmake.in"
  "${project_config}" INSTALL_DESTINATION
  "${${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}}")

install(
  TARGETS mshadow
  EXPORT "${TARGETS_EXPORT_NAME}"
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

if(USE_CUDA)
  install(
    TARGETS test
    EXPORT "${TARGETS_EXPORT_NAME}"
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  )
endif()
