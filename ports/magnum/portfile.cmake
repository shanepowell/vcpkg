include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mosra/magnum
    REF 68953f8c872b7c08f792c6082b8ab152f2119560
    SHA512 00b507b85ed3454f81fe7098e1fc349d4048a2372e3b2aceabccc0c4287540ed3850f8dd9cdcd9cfb9542ba9af741e30e43e2b03bbc5490b552f862da34369b1
    HEAD_REF master
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/001-sdl-includes.patch 
        ${CMAKE_CURRENT_LIST_DIR}/002-tools-path.patch
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    set(BUILD_STATIC 1)
    set(BUILD_PLUGINS_STATIC 1)
else()
    set(BUILD_STATIC 0)
    set(BUILD_PLUGINS_STATIC 0)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS
        -DWITH_SDL2APPLICATION=ON
        -DWITH_WINDOWLESSWGLAPPLICATION=ON
        -DWITH_WGLCONTEXT=ON
        -DWITH_OPENGLTESTER=ON
        -DWITH_AUDIO=ON
        -DWITH_WAVAUDIOIMPORTER=ON
        -DWITH_MAGNUMFONT=ON
        -DWITH_MAGNUMFONTCONVERTER=ON
        -DWITH_OBJIMPORTER=ON
        -DWITH_TGAIMPORTER=ON
        -DWITH_DISTANCEFIELDCONVERTER=ON
        -DWITH_FONTCONVERTER=ON
        -DWITH_TGAIMAGECONVERTER=ON
        -DBUILD_STATIC=${BUILD_STATIC}
        -DBUILD_PLUGINS_STATIC=${BUILD_PLUGINS_STATIC}
        -DMAGNUM_PLUGINS_DEBUG_DIR=${CURRENT_INSTALLED_DIR}/debug/bin/magnum-d
        -DMAGNUM_PLUGINS_RELEASE_DIR=${CURRENT_INSTALLED_DIR}/bin/magnum
)

vcpkg_install_cmake()

# Drop a copy of tools
file(COPY ${CURRENT_PACKAGES_DIR}/bin/magnum-distancefieldconverter.exe DESTINATION ${CURRENT_PACKAGES_DIR}/tools/magnum)
file(COPY ${CURRENT_PACKAGES_DIR}/bin/magnum-fontconverter.exe DESTINATION ${CURRENT_PACKAGES_DIR}/tools/magnum)

# Tools require dlls
vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/magnum)

file(GLOB_RECURSE TO_REMOVE 
   ${CURRENT_PACKAGES_DIR}/bin/*.exe
   ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
file(REMOVE ${TO_REMOVE})


file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin)
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/bin)
   # move plugin libs to conventional place
   file(GLOB_RECURSE LIB_TO_MOVE ${CURRENT_PACKAGES_DIR}/lib/magnum/*)
   file(COPY ${LIB_TO_MOVE} DESTINATION ${CURRENT_PACKAGES_DIR}/lib)
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/magnum)
   file(GLOB_RECURSE LIB_TO_MOVE_DBG ${CURRENT_PACKAGES_DIR}/debug/lib/magnum/*)
   file(COPY ${LIB_TO_MOVE_DBG} DESTINATION ${CURRENT_PACKAGES_DIR}/debug/lib)
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/magnum)
else()
   # remove headers and libs for plugins
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include/MagnumPlugins)
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/magnum)
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/magnum-d)
endif()

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/magnum)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/magnum/COPYING ${CURRENT_PACKAGES_DIR}/share/magnum/copyright)

vcpkg_copy_pdbs()