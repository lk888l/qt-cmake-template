qt_add_executable(qtapp_core_tests
    core/ApplicationInfoTest.cpp
)

target_link_libraries(qtapp_core_tests
    PRIVATE
        ${PROJECT_NAME}::Core
        ${PROJECT_NAME}::Options
        ${PROJECT_NAME}::Warnings
        Qt6::Test
)

add_test(NAME core.application_info COMMAND qtapp_core_tests)
set_tests_properties(core.application_info PROPERTIES
    LABELS "unit"
    TIMEOUT 10
    ENVIRONMENT_MODIFICATION "PATH=path_list_prepend:$<TARGET_FILE_DIR:Qt6::Core>"
)

if(MSVC AND QTAPP_ENABLE_ASAN)
    get_filename_component(qtapp_compiler_runtime_dir "${CMAKE_CXX_COMPILER}" DIRECTORY)
    if(qtapp_compiler_runtime_dir)
        set_property(TEST core.application_info APPEND PROPERTY
            ENVIRONMENT_MODIFICATION
            "PATH=path_list_prepend:${qtapp_compiler_runtime_dir}"
        )
    else()
        message(WARNING "Could not infer the MSVC ASan runtime directory from CMAKE_CXX_COMPILER")
    endif()
endif()

set_target_properties(qtapp_core_tests PROPERTIES FOLDER "Tests")
