include(vcpkg_common_functions)
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO mosra/magnum-plugins
    REF f0ddc63385e30c3bae362789855a95de7c46f8a7 
    SHA512 d0afda7be75efd2dec731e9435732220a76e735ef58d860f7119f206b1d5828af6e70aca3517b0f930c83440930ed62cb03e6c123e37771b72c50ddb44676945
    HEAD_REF master
)

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES
        ${CMAKE_CURRENT_LIST_DIR}/001-tools-path.patch
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
        -DWITH_STBIMAGECONVERTER=ON
        -DWITH_STBIMAGEIMPORTER=ON
        -DWITH_STBTRUETYPEFONT=ON
        -DWITH_STBTRUETYPEFONT=ON
        -DWITH_MINIEXRIMAGECONVERTER=ON
        -DWITH_OPENGEXIMPORTER=ON
        -DWITH_OPENGEXIMPORTER=ON
        -DWITH_STANFORDIMPORTER=ON
        -DWITH_DRWAVAUDIOIMPORTER=ON
        -DWITH_ANYAUDIOIMPORTER=ON
        -DWITH_ANYIMAGECONVERTER=ON
        -DWITH_ANYSCENEIMPORTER=ON
        -DBUILD_STATIC=${BUILD_STATIC}
        -DBUILD_PLUGINS_STATIC=${BUILD_PLUGINS_STATIC}
        -DMAGNUM_PLUGINS_DEBUG_DIR=${CURRENT_INSTALLED_DIR}/debug/bin/magnum-d
        -DMAGNUM_PLUGINS_RELEASE_DIR=${CURRENT_INSTALLED_DIR}/bin/magnum
)

vcpkg_install_cmake()

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
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include)
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib)
   file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib)
   # hint vcpkg
   set(VCPKG_POLICY_EMPTY_INCLUDE_FOLDER enabled)
   set(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)
endif()

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/magnum-plugins)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/magnum-plugins/COPYING ${CURRENT_PACKAGES_DIR}/share/magnum-plugins/copyright)

vcpkg_copy_pdbs()
