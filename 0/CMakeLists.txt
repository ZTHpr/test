cmake_minimum_required(VERSION 3.7)




###############################################################################
# Compiler information                                                        #
###############################################################################
set(CMAKE_C_COMPILER /usr/bin/gcc)
set(CMAKE_CXX_COMPILER /usr/bin/g++)
# set(CMAKE_FIND_ROOT_PATH /usr/local/bin/)


###############################################################################
# Compiler configure                                                          #
###############################################################################
add_compile_options(-std=c++2a -g -pg -fno-omit-frame-pointer -fPIC)

PROJECT(TEST)
set(CMAKE_VERBOSE_MAKEFILE ON)

SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/lib)
SET(CMAKE_INSTALL_PREFIX ${PROJECT_BINARY_DIR}/install)

set(G_THIRD_PARTY_DIR ${TARGET_TMPROOTFS_DIR}/lib)

add_executable(test main.cpp)

# include_directories(
#     ${CMAKE_SOURCE_DIR}
#     ${CMAKE_SOURCE_DIR}/include/
#     ${CMAKE_SOURCE_DIR}/include/3rdparty  
#     ${TARGET_TMPROOTFS_DIR}/include/
# )

# target_link_libraries(diag_service PUBLIC 
# diagnose
# diagproto
# diag
# ${CMAKE_SOURCE_DIR}/lib/communication/libcommunication.so
# ${CMAKE_SOURCE_DIR}/lib/proto/libprotobuf.a
# ${CMAKE_SOURCE_DIR}/lib/libadasdiagproto.a
# ${CMAKE_SOURCE_DIR}/lib/libalog.so
# ${CMAKE_SOURCE_DIR}/lib/libzmq.a
# ${CMAKE_SOURCE_DIR}/lib/libfmt.a
# ${CMAKE_SOURCE_DIR}/lib/libjsoncpp.a
# ${CMAKE_SOURCE_DIR}/lib/libhlog.so
# ${G_THIRD_PARTY_DIR}/libhbspihal.so
# ${G_THIRD_PARTY_DIR}/libdiaglib.so
# libpthread.so
# librt.so
# libm.so)


# #install bin
# INSTALL(TARGETS diag_service
# RUNTIME DESTINATION bin
# )

# #install .h file
# set(head_files
# ${ROOTDIR}/include/public/diagcomm/diag_comm_lib.h
# ${ROOTDIR}/include/public/diaglib/diag_lib.h
# )
# set(OUTPUT_INCLUDE_DIR ${PROJECT_BINARY_DIR}/install/include)
# install(FILES ${head_files} DESTINATION  ${OUTPUT_INCLUDE_DIR})


# # install config file
# set(OUTPUT_CONFIG_DIR ${PROJECT_BINARY_DIR}/install/etc)
# install(DIRECTORY "${ROOTDIR}/config"
# DESTINATION ${OUTPUT_CONFIG_DIR}
# )

