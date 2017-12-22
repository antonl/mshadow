# ---[ add test executables
if(USE_CUDA)
  set(mshadow_INCLUDE_DIRS ${CMAKE_SOURCE_DIR})
  add_executable(cu_test test.cu test.h)

  # none of the tests seem to work now

  #add_executable(cu_pairtest pairtest.cu)
  #add_executable(cu_pool pool.cu)
  #add_executable(cu_unpack unpack.cu)
  #add_executable(cu_reshape reshape.cu)

  target_link_libraries(cu_test PRIVATE mshadow)
  target_include_directories(cu_test PRIVATE ${mshadow_INCLUDE_DIRS})
  set_target_properties(cu_test PROPERTIES LINKER_LANGUAGE CUDA)
  target_compile_features(cu_test PUBLIC cxx_std_11)

  target_compile_definitions(cu_test PRIVATE MSHADOW_FORCE_STREAM=0) # will not run otherwise

  #target_link_libraries(cu_pairtest PRIVATE mshadow)
  #target_include_directories(cu_pairtest PRIVATE ${mshadow_INCLUDE_DIRS})
  #set_target_properties(cu_pairtest PROPERTIES LINKER_LANGUAGE CUDA)
  #target_compile_features(cu_pairtest PUBLIC cxx_std_11)

  #target_link_libraries(cu_pool PRIVATE mshadow)
  #target_include_directories(cu_pool PRIVATE ${mshadow_INCLUDE_DIRS})
  #set_target_properties(cu_pool PROPERTIES LINKER_LANGUAGE CUDA)
  #target_compile_features(cu_pool PUBLIC cxx_std_11)

  #target_link_libraries(cu_reshape PRIVATE mshadow)
  #target_include_directories(cu_reshape PRIVATE ${mshadow_INCLUDE_DIRS})
  #set_target_properties(cu_reshape PROPERTIES LINKER_LANGUAGE CUDA)
  #target_compile_features(cu_reshape PUBLIC cxx_std_11)

  #target_link_libraries(cu_unpack PRIVATE mshadow)
  #target_include_directories(cu_unpack PRIVATE ${mshadow_INCLUDE_DIRS})
  #set_target_properties(cu_unpack PROPERTIES LINKER_LANGUAGE CUDA)
  #target_compile_features(cu_unpack PUBLIC cxx_std_11)

  install(
    TARGETS 
      cu_test 
      #cu_pairtest 
      #cu_pool 
      #cu_unpack 
      #cu_reshape 
    #EXPORT "${TARGETS_EXPORT_NAME}"
    RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
  )
endif()
