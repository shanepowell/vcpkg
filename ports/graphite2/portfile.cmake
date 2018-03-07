
include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO silnrsi/graphite
    REF 99658129785a218556929db0595a002a668b40b0
    SHA512 50cf6f727a2ea13ccbf55b4dad282358c40973aa0a0d97db6d721208b70fe848791aab183062c7bed8ce5b0dc3fecd6b604f6defdd5ae89b46ce267069ee0ed1
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

# file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/gr2fonttest.exe)
# file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/gr2fonttest.exe)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/graphite2)
file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/graphite2 RENAME copyright)
