include(CheckIPOSupported)
include(CompilerWarnings)
include(Sanitizers)

option(QTAPP_WARNINGS_AS_ERRORS "Treat compiler warnings as errors" OFF)
option(QTAPP_ENABLE_IPO "Enable interprocedural optimization for release builds" OFF)
option(QTAPP_ENABLE_ASAN "Enable AddressSanitizer" OFF)
option(QTAPP_ENABLE_UBSAN "Enable UndefinedBehaviorSanitizer" OFF)
option(QTAPP_ENABLE_CLANG_TIDY "Run clang-tidy while compiling" OFF)
option(QTAPP_ENABLE_CPPCHECK "Run cppcheck while compiling" OFF)

function(qtapp_setup_project_options)
    add_library(qtapp_project_options INTERFACE)
    add_library(${PROJECT_NAME}::Options ALIAS qtapp_project_options)
    target_compile_features(qtapp_project_options INTERFACE cxx_std_20)

    add_library(qtapp_project_warnings INTERFACE)
    add_library(${PROJECT_NAME}::Warnings ALIAS qtapp_project_warnings)
    qtapp_set_project_warnings(qtapp_project_warnings ${QTAPP_WARNINGS_AS_ERRORS})

    qtapp_enable_sanitizers(
        qtapp_project_options
        ${QTAPP_ENABLE_ASAN}
        ${QTAPP_ENABLE_UBSAN}
    )

    if(QTAPP_ENABLE_IPO)
        check_ipo_supported(RESULT ipo_supported OUTPUT ipo_error LANGUAGES CXX)
        if(NOT ipo_supported)
            message(FATAL_ERROR "Interprocedural optimization is unavailable: ${ipo_error}")
        endif()

        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON PARENT_SCOPE)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELWITHDEBINFO ON PARENT_SCOPE)
    endif()

    set_target_properties(qtapp_project_options qtapp_project_warnings PROPERTIES
        FOLDER "Build Support"
    )
endfunction()
