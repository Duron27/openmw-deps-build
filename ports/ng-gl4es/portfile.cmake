set(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)

set(NG_GL4ES_VER f7a8370852579d6a11154178929a02e0cf60d574)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Sisah2/NG-GL4ES
    REF ${NG_GL4ES_VER}
    SHA512 7c6be54ff772daf8ff02d330ddd5875292e1bc601c995a505c9d4aea8c59f2a551b03efca0bc44c90963126d5d175eea73e66cf2e7b2cde253b55570ddf794c8
    HEAD_REF Openmw3
    PATCHES gl4es.patch
)

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
if(NOT EXISTS "${SOURCE_PATH}/SPIRV-Tools/CMakeLists.txt")
    vcpkg_from_github(
        OUT_SOURCE_PATH spirv_tools_source
        REPO KhronosGroup/SPIRV-Tools
        REF 2d14d2e
        SHA512 dfca6dba8b5e2ad37df314e77be66f4cd1d01cebfee36973c39dbf81e07f6655dd32ca36f8f8c5e4d4dea09b386acb440cf7d2c8c62e3cbb373a04279ca707c5
    )
    file(REMOVE_RECURSE "${SOURCE_PATH}/3rdparty/SPIRV-Tools")
    file(RENAME "${spirv_tools_source}" "${SOURCE_PATH}/3rdparty/SPIRV-Tools")
endif()

# Manually fetch SPIRV-headers submodule
if(NOT EXISTS "${SOURCE_PATH}/SPIRV-Headers/CMakeLists.txt")
    vcpkg_from_github(
        OUT_SOURCE_PATH spirv_headers_source
        REPO KhronosGroup/SPIRV-Headers
        REF 6dd7ba9
        SHA512 4f6ae3af7e75e8a9d045024aac378395d08f42a8fe3c2a35142c23a40e3e5f4d6fdc46c537251d6174ee89581daf1ad63746c3c48a7a9d2a690271e6d94f08fc
    )
    file(REMOVE_RECURSE "${SOURCE_PATH}/3rdparty/SPIRV-Headers")
    file(RENAME "${spirv_headers_source}" "${SOURCE_PATH}/3rdparty/SPIRV-Headers")
endif()


vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
file(REMOVE_RECURSE
    "${CURRENT_PACKAGES_DIR}/debug/include"
    "${CURRENT_PACKAGES_DIR}/debug/share"
)

# Install public headers
file(INSTALL
    "${SOURCE_PATH}/include/"
    DESTINATION "${CURRENT_PACKAGES_DIR}/include"
)

# Release
file(INSTALL
    "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/libng_gl4es.so"
    DESTINATION "${CURRENT_PACKAGES_DIR}/lib"
)

# Debug
file(INSTALL
    "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg/libng_gl4es.so"
    DESTINATION "${CURRENT_PACKAGES_DIR}/debug/lib"
)

vcpkg_fixup_pkgconfig()

