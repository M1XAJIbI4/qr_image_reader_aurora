# CMAKE_SYSTEM_PROCESSOR - CPU architecture name (armv7l, aarch64, x86_64)
# CMAKE_BUILD_TYPE       - Build mode (debug, profile, release)
# PSDK_VERSION           - Build psdk exact version
# PSDK_MAJOR             - Build psdk major version

cmake_minimum_required(VERSION 3.10)

set(PROJECT_NAME qr_image_reader_aurora)
set(PLUGIN_NAME  qr_image_reader_aurora_platform_plugin)

project(${PROJECT_NAME} LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_CXX_FLAGS "-Wall -Wextra -Wno-psabi")
set(CMAKE_CXX_FLAGS_RELEASE "-O3")

set(3RDPATRY_PATH ${CMAKE_CURRENT_SOURCE_DIR}/3rdpatry/psdk_${PSDK_MAJOR})

add_compile_definitions(PSDK_MAJOR=${PSDK_MAJOR})

find_package(PkgConfig REQUIRED)
pkg_check_modules(FlutterEmbedder REQUIRED IMPORTED_TARGET flutter-embedder)
pkg_check_modules(PNG REQUIRED IMPORTED_TARGET libpng16)

add_library(${PLUGIN_NAME} SHARED 
    qr_image_reader_aurora_plugin.cpp
)

set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::FlutterEmbedder)

################### zxing
set(ZXING_LIB_NAME "ZXing")

if(${PSDK_MAJOR} EQUAL 5)
    set(ZXING_LIB_LINK "libZXing.so.3")
    set(ZXING_LIB_LIST ${ZXING_LIB_LINK} "libZXing.so.2.1.0")
else()
    set(ZXING_LIB_LINK "libZXing.so.1")
    set(ZXING_LIB_LIST ${ZXING_LIB_LINK} "libZXing.so.1.1.1")
endif()

target_include_directories(${PLUGIN_NAME} PUBLIC ${3RDPATRY_PATH}/${ZXING_LIB_NAME}/include)
target_include_directories(${PLUGIN_NAME} PUBLIC ${3RDPATRY_PATH}/${ZXING_LIB_NAME}/include/${ZXING_LIB_NAME})

foreach (file ${ZXING_LIB_LIST})
    add_custom_command(TARGET ${PLUGIN_NAME} POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy
                    ${3RDPATRY_PATH}/${ZXING_LIB_NAME}/${CMAKE_SYSTEM_PROCESSOR}/${file}
                    ${ROOT_PROJECT_BINARY_DIR}/bundle/lib/${file})
endforeach()

add_library(${ZXING_LIB_NAME} SHARED IMPORTED)
set_property(TARGET ${ZXING_LIB_NAME} PROPERTY IMPORTED_LOCATION ${3RDPATRY_PATH}/${ZXING_LIB_NAME}/${CMAKE_SYSTEM_PROCESSOR}/${ZXING_LIB_LINK})
target_link_libraries(${PLUGIN_NAME} PUBLIC ${ZXING_LIB_NAME})
###################

#################### libtiff
set(TIFF_LIB_NAME "libtiff")
set(TIFF_LIB_LINK "libtiff.so.5")
set(TIFF_LIB_LIST ${TIFF_LIB_LINK} "libtiff.so.5.7.0")

target_include_directories(${PLUGIN_NAME} PUBLIC ${3RDPATRY_PATH}/${TIFF_LIB_NAME}/include)
target_include_directories(${PLUGIN_NAME} PUBLIC ${3RDPATRY_PATH}/${TIFF_LIB_NAME}/include/${TIFF_LIB_NAME})

foreach (file ${TIFF_LIB_LIST})
    add_custom_command(TARGET ${PLUGIN_NAME} POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy
                    ${3RDPATRY_PATH}/${TIFF_LIB_NAME}/${CMAKE_SYSTEM_PROCESSOR}/${file}
                    ${ROOT_PROJECT_BINARY_DIR}/bundle/lib/${file})
endforeach()

add_library(${TIFF_LIB_NAME} SHARED IMPORTED)
set_property(TARGET ${TIFF_LIB_NAME} PROPERTY IMPORTED_LOCATION ${3RDPATRY_PATH}/${TIFF_LIB_NAME}/${CMAKE_SYSTEM_PROCESSOR}/${TIFF_LIB_LINK})
target_link_libraries(${PLUGIN_NAME} PUBLIC ${TIFF_LIB_NAME})

set_target_properties(${PLUGIN_NAME} PROPERTIES CXX_VISIBILITY_PRESET hidden AUTOMOC ON)

target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::FlutterEmbedder PkgConfig::PNG)

target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/cimg)
target_include_directories(${PLUGIN_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/libjpeg)
target_compile_definitions(${PLUGIN_NAME} PRIVATE PLUGIN_IMPL)
