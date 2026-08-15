function(qtapp_prevent_in_source_builds)
    get_filename_component(source_dir "${CMAKE_SOURCE_DIR}" REALPATH)
    get_filename_component(binary_dir "${CMAKE_BINARY_DIR}" REALPATH)

    if(source_dir STREQUAL binary_dir)
        message(FATAL_ERROR
            "In-source builds are not supported. "
            "Use a preset or configure into a separate build directory."
        )
    endif()
endfunction()
