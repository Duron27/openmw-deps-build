set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)

set(NG_GL4ES_VER 2c441ca11e08ccbd76c8381e0b6aa63df4e4d667)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Sisah2/NG-GL4ES
    REF ${NG_GL4ES_VER}
    SHA512 8f7485c118f1eee07a4de1a2685a2f8e888d9d9eca27c605f8d401f5c4be274c68b83eda725221a7fb4bcfd44d169dcc5f4d3c358e095069e7b49b711df59347
    HEAD_REF Openmw3
    PATCHES ${PATCHES}
)

# Fetch glslang submodule
if(NOT EXISTS "${SOURCE_PATH}/3rdparty/glslang/CMakeLists.txt")
    vcpkg_from_github(
        OUT_SOURCE_PATH glslang_source
        REPO KhronosGroup/glslang
        REF 7099c12
        SHA512 7da000c54006d0f8b49c79bb86d6cb6e1444445e5cc79f6347985d72d641949304756d81d130e96c05e76aa4a9b510f1fe3ee53d46ac95dbe6e19e38c387c81c
    )

    file(REMOVE_RECURSE "${SOURCE_PATH}/3rdparty/glslang")
    file(RENAME "${glslang_source}" "${SOURCE_PATH}/3rdparty/glslang")
endif()

# Fetch SPIRV-Cross submodule
if(NOT EXISTS "${SOURCE_PATH}/3rdparty/SPIRV-Cross/CMakeLists.txt")
    vcpkg_from_github(
        OUT_SOURCE_PATH spirv_cross_source
        REPO KhronosGroup/SPIRV-Cross
        REF adec7ac
        SHA512 23f14b8a93710bf4a6db8de9b1901f3038701cd0c8bb79a0cd57dfc1bc0b849a9dfbdea519bef17a09eedb9f35c182fd01dfc11931d2517ba2204182ceaeda8a
    )

    file(REMOVE_RECURSE "${SOURCE_PATH}/3rdparty/SPIRV-Cross")
    file(RENAME "${spirv_cross_source}" "${SOURCE_PATH}/3rdparty/SPIRV-Cross")
endif()


# Manually fetch SPIRV-Tools submodule
#if(NOT EXISTS "${SOURCE_PATH}/SPIRV-Tools/CMakeLists.txt")
#    vcpkg_from_github(
#        OUT_SOURCE_PATH spirv_tools_source
#        REPO KhronosGroup/SPIRV-Tools
#        REF 2d14d2e
#        SHA512 dfca6dba8b5e2ad37df314e77be66f4cd1d01cebfee36973c39dbf81e07f6655dd32ca36f8f8c5e4d4dea09b386acb440cf7d2c8c62e3cbb373a04279ca707c5
#    )
#    file(REMOVE_RECURSE "${SOURCE_PATH}/SPIRV-Tools")
#    file(RENAME "${spirv_tools_source}" "${SOURCE_PATH}/SPIRV-Tools")
#endif()

# Manually fetch SPIRV-headers submodule
#if(NOT EXISTS "${SOURCE_PATH}/SPIRV-headers/include/spirv/unified1/spirv.h")
#    vcpkg_from_github(
#        OUT_SOURCE_PATH spirv_headers_source
#        REPO KhronosGroup/SPIRV-Headers
#        REF 6dd7ba9
#        SHA512 4f6ae3af7e75e8a9d045024aac378395d08f42a8fe3c2a35142c23a40e3e5f4d6fdc46c537251d6174ee89581daf1ad63746c3c48a7a9d2a690271e6d94f08fc
#    )
#    file(REMOVE_RECURSE "${SOURCE_PATH}/SPIRV-headers")
#    file(RENAME "${spirv_headers_source}" "${SOURCE_PATH}/SPIRV-headers")
#endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup()
vcpkg_fixup_pkgconfig()
vcpkg_copy_pdbs()

file(COPY "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
