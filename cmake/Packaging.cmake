include(GNUInstallDirs)

macro(qtapp_configure_packaging target)
    install(TARGETS ${target}
        BUNDLE DESTINATION .
        RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
    )

    set(qtapp_deploy_options "")
    if(MSVC)
        list(APPEND qtapp_deploy_options NO_COMPILER_RUNTIME)
    endif()

    qt_generate_deploy_app_script(
        TARGET ${target}
        OUTPUT_SCRIPT qtapp_deploy_script
        NO_UNSUPPORTED_PLATFORM_ERROR
        ${qtapp_deploy_options}
    )
    install(SCRIPT "${qtapp_deploy_script}")

    set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
    set(CPACK_PACKAGE_VENDOR "${QTAPP_ORGANIZATION_NAME}")
    set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_DESCRIPTION}")
    set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
    set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PROJECT_NAME}")
    set(CPACK_PACKAGE_DIRECTORY "${PROJECT_BINARY_DIR}/packages")
    set(CPACK_PACKAGE_CHECKSUM SHA256)

    if(MSVC)
        set(qtapp_compiler_tag "msvc")
    elseif(MINGW)
        set(qtapp_compiler_tag "mingw")
    else()
        string(TOLOWER "${CMAKE_CXX_COMPILER_ID}" qtapp_compiler_tag)
        string(REGEX REPLACE "[^a-z0-9_.-]" "-" qtapp_compiler_tag "${qtapp_compiler_tag}")
    endif()

    set(CPACK_PACKAGE_FILE_NAME
        "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}-${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}-${qtapp_compiler_tag}"
    )

    if(WIN32)
        set(CPACK_GENERATOR ZIP)
    elseif(APPLE)
        set(CPACK_GENERATOR DragNDrop)
    else()
        set(CPACK_GENERATOR TGZ)
    endif()

    include(CPack)
endmacro()
