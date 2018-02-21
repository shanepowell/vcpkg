include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO CGAL/cgal
    REF releases/CGAL-4.11
    SHA512 91e555d5988bee387afa31331e1e3a8990206468fd8c774fd82979d9ff169e9c4835ecc6ba3d576cda617b6cb2cd52d27657d2434e38b29ce0e7e643436810ab
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCGAL_INSTALL_CMAKE_DIR=share/cgal
)

vcpkg_install_cmake()

vcpkg_fixup_cmake_targets()

vcpkg_copy_pdbs()

# Clean
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(READ ${CURRENT_PACKAGES_DIR}/share/cgal/CGALConfig.cmake _contents)
string(REPLACE "CGAL_IGNORE_PRECONFIGURED_GMP" "1" _contents "${_contents}")
string(REPLACE "CGAL_IGNORE_PRECONFIGURED_MPFR" "1" _contents "${_contents}")
file(WRITE ${CURRENT_PACKAGES_DIR}/share/cgal/CGALConfig.cmake "${_contents}")

# Handle copyright of suitesparse and metis
file(COPY ${SOURCE_PATH}/copyright DESTINATION ${CURRENT_PACKAGES_DIR}/share/cgal)
