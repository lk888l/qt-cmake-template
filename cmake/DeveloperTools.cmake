function(qtapp_add_developer_targets)
    find_program(QTAPP_CLANG_FORMAT_EXECUTABLE
        NAMES clang-format clang-format-20 clang-format-19 clang-format-18 clang-format-17
    )

    if(NOT QTAPP_CLANG_FORMAT_EXECUTABLE)
        message(STATUS "clang-format was not found; format targets will not be generated")
        return()
    endif()

    file(GLOB_RECURSE format_files CONFIGURE_DEPENDS
        "${PROJECT_SOURCE_DIR}/src/*.cpp"
        "${PROJECT_SOURCE_DIR}/src/*.hpp"
        "${PROJECT_SOURCE_DIR}/tests/*.cpp"
        "${PROJECT_SOURCE_DIR}/tests/*.hpp"
    )

    add_custom_target(format
        COMMAND "${QTAPP_CLANG_FORMAT_EXECUTABLE}" -i ${format_files}
        COMMAND_EXPAND_LISTS
        VERBATIM
        COMMENT "Formatting C++ sources"
    )

    add_custom_target(format-check
        COMMAND "${QTAPP_CLANG_FORMAT_EXECUTABLE}" --dry-run --Werror ${format_files}
        COMMAND_EXPAND_LISTS
        VERBATIM
        COMMENT "Checking C++ source formatting"
    )

    set_target_properties(format format-check PROPERTIES FOLDER "Developer Tools")
endfunction()
