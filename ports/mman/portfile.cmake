include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO witwall/mman-win32
    REF f5ff813c53935c3078f48e1f03a6944c4e7b459c
    SHA512 49c9a63a0a3c6fa585a76e65425f6fb1fdaa23cc87e53d5afb7a1298bcd4956298c076ee78f24dd5df5f5a0c5f6244c6abb63b40818e4d2546185fa37a73bf0d
    HEAD_REF master
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    set(ENABLE_SHARED OFF)
else()
    set(ENABLE_SHARED ON)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS
        -DBUILD_SHARED_LIBS=${ENABLE_SHARED}
)

vcpkg_install_cmake()

file(INSTALL ${SOURCE_PATH}/README.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/mman RENAME copyright)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

vcpkg_copy_pdbs()
