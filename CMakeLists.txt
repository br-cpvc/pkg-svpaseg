
cmake_minimum_required(VERSION 2.8.12)
PROJECT (SVPASEG)

INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_SOURCE_DIR}/src)
link_directories( ${CMAKE_BINARY_DIR}/bin)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR}/bin)

if (MSVC)
    add_definitions(/D "_CRT_SECURE_NO_WARNINGS")
endif (MSVC)

FIND_PACKAGE(OpenMP)
if(OPENMP_FOUND)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${OpenMP_C_FLAGS}")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${OpenMP_CXX_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${OpenMP_EXE_LINKER_FLAGS}")
endif(OPENMP_FOUND)

set(SVPASEG_DIR "${PROJECT_SOURCE_DIR}/deps/SVPASEG")

set(svpaseg_SRC
    ${SVPASEG_DIR}/src/analyze.c
    ${SVPASEG_DIR}/src/znzlib.c
    ${SVPASEG_DIR}/src/nifti1_io.c
    ${SVPASEG_DIR}/src/atlasspec.c
    ${SVPASEG_DIR}/src/nhmrf.c
    ${SVPASEG_DIR}/src/svpaseg.c
)

set(svpaseg_HEADERS
    ${SVPASEG_DIR}/src/nhmrf.h
    ${SVPASEG_DIR}/src/atlasspec.h
    ${SVPASEG_DIR}/src/analyze.h
)

set_source_files_properties(${svpaseg_SRC} PROPERTIES LANGUAGE CXX)
add_executable(svpaseg ${svpaseg_SRC} ${svpaseg_HEADERS})

set(gamixture_SRC
    ${SVPASEG_DIR}/src/analyze.c
    ${SVPASEG_DIR}/src/znzlib.c
    ${SVPASEG_DIR}/src/nifti1_io.c
    ${SVPASEG_DIR}/src/nhmrf.c
    ${SVPASEG_DIR}/src/parzen.c
    ${SVPASEG_DIR}/src/atlasspec.c
    ${SVPASEG_DIR}/src/gamixture.c
    ${SVPASEG_DIR}/src/gamixturemain.c
)
if(EXISTS ${SVPASEG_DIR}/src/RFRandom.c)
    list(APPEND gamixture_SRC ${SVPASEG_DIR}/src/RFRandom.c)
endif(EXISTS ${SVPASEG_DIR}/src/RFRandom.c)

set(gamixture_HEADERS
    ${SVPASEG_DIR}/src/gamixture.h
    ${SVPASEG_DIR}/src/parzen.h
    ${SVPASEG_DIR}/src/analyze.h
    ${SVPASEG_DIR}/src/nhmrf.h
    ${SVPASEG_DIR}/src/atlasspec.h
)
if(EXISTS ${SVPASEG_DIR}/src/RFRandom.h)
    list(APPEND gamixture_HEADERS ${SVPASEG_DIR}/src/RFRandom.h)
endif(EXISTS ${SVPASEG_DIR}/src/RFRandom.h)

set_source_files_properties(${gamixture_SRC} PROPERTIES LANGUAGE CXX)
add_executable(gamixture ${gamixture_SRC} ${gamixture_HEADERS})

set(conf_atlas_dirs_SRC
    ${SVPASEG_DIR}/src/atlasspec.c
    ${SVPASEG_DIR}/src/analyze.c
    ${SVPASEG_DIR}/src/znzlib.c
    ${SVPASEG_DIR}/src/nifti1_io.c
    ${SVPASEG_DIR}/src/config_atlas_dirs.c
)

set(conf_atlas_dirs_HEADERS
    ${SVPASEG_DIR}/src/atlasspec.h
    ${SVPASEG_DIR}/src/analyze.h
)

set_source_files_properties(${conf_atlas_dirs_SRC} PROPERTIES LANGUAGE CXX)
add_executable(conf_atlas_dirs ${conf_atlas_dirs_SRC} ${conf_atlas_dirs_HEADERS})

INSTALL(TARGETS svpaseg DESTINATION bin/)
INSTALL(TARGETS gamixture DESTINATION bin/)
INSTALL(TARGETS conf_atlas_dirs DESTINATION bin/)
INSTALL(DIRECTORY ${SVPASEG_DIR}/atlasspecs DESTINATION share/svpaseg/)
