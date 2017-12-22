# build the mshadow interface library

  # ---[ mshadow library
add_library(mshadow INTERFACE)

target_sources(mshadow INTERFACE 
  ${CMAKE_CURRENT_LIST_DIR}/base.h
  ${CMAKE_CURRENT_LIST_DIR}/expression.h
  ${CMAKE_CURRENT_LIST_DIR}/extension.h
  ${CMAKE_CURRENT_LIST_DIR}/half.h
  ${CMAKE_CURRENT_LIST_DIR}/io.h
  ${CMAKE_CURRENT_LIST_DIR}/logging.h
  ${CMAKE_CURRENT_LIST_DIR}/packet-inl.h
  ${CMAKE_CURRENT_LIST_DIR}/random.h
  ${CMAKE_CURRENT_LIST_DIR}/tensor_container.h
  ${CMAKE_CURRENT_LIST_DIR}/half2.h
  ${CMAKE_CURRENT_LIST_DIR}/tensor.h
  ${CMAKE_CURRENT_LIST_DIR}/tensor_cpu-inl.h
  ${CMAKE_CURRENT_LIST_DIR}/tensor_gpu-inl.h
  ${CMAKE_CURRENT_LIST_DIR}/dot_engine-inl.h
  ${CMAKE_CURRENT_LIST_DIR}/expr_engine-inl.h
  ${CMAKE_CURRENT_LIST_DIR}/expr_scalar-inl.h
  ${CMAKE_CURRENT_LIST_DIR}/stream_gpu-inl.h

  ${CMAKE_CURRENT_LIST_DIR}/cuda/tensor_gpu-inl.cuh
  ${CMAKE_CURRENT_LIST_DIR}/cuda/reduce.cuh

  ${CMAKE_CURRENT_LIST_DIR}/extension/broadcast.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/broadcast_with_axis.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/channel_pool.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/channel_unpool.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/choose.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/complex.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/concat.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/crop.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/fill.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/flip.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/implicit_gemm.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/mask.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/mirror.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/one_hot.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/pack_col2patch.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/pad.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/range.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/reduce_with_axis.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/reduceto1d.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/reshape.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/slice.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/slice_ex.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/spatial_pool.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/spatial_unpool.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/spatial_upsampling_nearest.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/swapaxis.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/take.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/take_grad.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/transpose.h
  ${CMAKE_CURRENT_LIST_DIR}/extension/unpack_patch2col.h

  ${CMAKE_CURRENT_LIST_DIR}/packet/plain-inl.h
  ${CMAKE_CURRENT_LIST_DIR}/packet/sse-inl.h
 )

# ---[ Add dependencies to interface target
target_include_directories(mshadow INTERFACE ${_mshadow_INCLUDE_DIRS})
target_compile_definitions(mshadow INTERFACE ${_mshadow_DEFINES})
target_link_libraries(mshadow INTERFACE ${_mshadow_DEPENDENCY_LIBS})

# ---[ Handle SSE3 flag
if(NOT MSVC) # I only want to deal with gcc-compatible things for now
  if(${USE_SSE})
    #target_compile_options(mshadow INTERFACE "-msse3") # doesn't work for nvcc 
  endif()
endif()

# ---[ Install the CMake package and header files
install(
TARGETS mshadow
EXPORT "${TARGETS_EXPORT_NAME}"
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(
  DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
  DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
  PATTERN "CMakeLists.txt" EXCLUDE
  PATTERN "README.md" EXCLUDE
  PATTERN "*.un~" EXCLUDE
)

