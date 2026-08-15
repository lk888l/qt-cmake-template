qt_add_executable(${PROJECT_NAME}
    main.cpp
    MainWindow.cpp
    MainWindow.hpp
    MainWindow.ui
)

qt_add_resources(${PROJECT_NAME} "application_resources"
    PREFIX "/qtapp"
    BASE "${CMAKE_CURRENT_SOURCE_DIR}/resources"
    FILES
        resources/application.svg
        resources/default.qss
)

target_link_libraries(${PROJECT_NAME}
    PRIVATE
        ${PROJECT_NAME}::Core
        ${PROJECT_NAME}::Options
        ${PROJECT_NAME}::Warnings
        Qt6::Gui
        Qt6::Svg
        Qt6::Widgets
)

target_include_directories(${PROJECT_NAME}
    PRIVATE
        "${CMAKE_CURRENT_SOURCE_DIR}"
)

set_target_properties(${PROJECT_NAME} PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
    MACOSX_BUNDLE_GUI_IDENTIFIER "${QTAPP_APPLICATION_ID}"
    MACOSX_BUNDLE_BUNDLE_NAME "${PROJECT_NAME}"
    MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
    MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}"
    FOLDER "Applications"
)

if(WIN32)
    # Do not launch a Windows GUI executable through `cmake -E env`. CMake
    # starts that direct child with SW_HIDE, which Qt honors even after
    # QWidget::show(). A cmd wrapper supplies the same temporary PATH without
    # propagating the hidden startup state to the application.
    set(qtapp_run_script "${CMAKE_CURRENT_BINARY_DIR}/run-$<CONFIG>.cmd")
    set(qtapp_run_script_content "@echo off\r\n")
    string(APPEND qtapp_run_script_content
        "setlocal\r\n"
        "set \"PATH=$<TARGET_FILE_DIR:Qt6::Core>;%PATH%\"\r\n"
    )
    if(MSVC AND QTAPP_ENABLE_ASAN)
        get_filename_component(qtapp_compiler_runtime_dir "${CMAKE_CXX_COMPILER}" DIRECTORY)
        if(qtapp_compiler_runtime_dir)
            string(APPEND qtapp_run_script_content
                "set \"PATH=${qtapp_compiler_runtime_dir};%PATH%\"\r\n"
            )
        endif()
    endif()
    string(APPEND qtapp_run_script_content
        "\"$<TARGET_FILE:${PROJECT_NAME}>\"\r\n"
        "exit /b %ERRORLEVEL%\r\n"
    )
    file(GENERATE
        OUTPUT "${qtapp_run_script}"
        CONTENT "${qtapp_run_script_content}"
    )

    add_custom_target(run
        COMMAND "${qtapp_run_script}"
        DEPENDS ${PROJECT_NAME}
        USES_TERMINAL
        VERBATIM
        COMMENT "Running ${PROJECT_NAME} with the matching Qt runtime"
    )
else()
    add_custom_target(run
        COMMAND "${CMAKE_COMMAND}" -E env
            --modify "PATH=path_list_prepend:$<TARGET_FILE_DIR:Qt6::Core>"
            -- "$<TARGET_FILE:${PROJECT_NAME}>"
        DEPENDS ${PROJECT_NAME}
        USES_TERMINAL
        VERBATIM
        COMMENT "Running ${PROJECT_NAME} with the matching Qt runtime"
    )
endif()
set_target_properties(run PROPERTIES FOLDER "Developer Tools")
