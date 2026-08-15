macro(qtapp_enable_static_analyzers)
    if(QTAPP_ENABLE_CLANG_TIDY OR QTAPP_ENABLE_CPPCHECK)
        if(NOT CMAKE_GENERATOR MATCHES "Ninja|Makefiles")
            message(FATAL_ERROR
                "clang-tidy/cppcheck integration requires a Ninja or Makefiles generator. "
                "Use the MinGW Ninja preset, or configure MSVC Ninja from a VS Developer shell."
            )
        endif()
    endif()

    if(QTAPP_ENABLE_CLANG_TIDY)
        find_program(QTAPP_CLANG_TIDY_EXECUTABLE NAMES clang-tidy REQUIRED)
        set(CMAKE_CXX_CLANG_TIDY
            "${QTAPP_CLANG_TIDY_EXECUTABLE};--config-file=${PROJECT_SOURCE_DIR}/.clang-tidy"
        )
    endif()

    if(QTAPP_ENABLE_CPPCHECK)
        find_program(QTAPP_CPPCHECK_EXECUTABLE NAMES cppcheck REQUIRED)
        set(CMAKE_CXX_CPPCHECK
            "${QTAPP_CPPCHECK_EXECUTABLE};--enable=warning,performance,portability;--inline-suppr;--suppress=missingIncludeSystem"
        )
    endif()
endmacro()
