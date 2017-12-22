# build the mshadow interface library

# ---[ enable openmp support
find_package(OpenMP)

# ---[ mshadow library
add_library(mshadow INTERFACE)

target_sources(mshadow INTERFACE)

# hack together adding our own dir to interface
target_include_directories(mshadow INTERFACE 
		$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>  
    $<INSTALL_INTERFACE:include>)

# ---[ Add dependencies to interface target
target_include_directories(mshadow INTERFACE ${_mshadow_INCLUDE_DIRS})
target_compile_definitions(mshadow INTERFACE ${_mshadow_DEFINES})
target_link_libraries(mshadow INTERFACE ${_mshadow_DEPENDENCY_LIBS} OpenMP::OpenMP_CUDA)

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
