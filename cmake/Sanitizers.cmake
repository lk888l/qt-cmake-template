function(qtapp_enable_sanitizers target enable_asan enable_ubsan)
    if(NOT enable_asan AND NOT enable_ubsan)
        return()
    endif()

    if(MSVC)
        if(enable_ubsan)
            message(FATAL_ERROR "UndefinedBehaviorSanitizer is not supported by this MSVC profile")
        endif()

        target_compile_options(${target} INTERFACE /fsanitize=address)
        target_link_options(${target} INTERFACE /INCREMENTAL:NO)
        return()
    endif()

    if(NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
        message(FATAL_ERROR "Sanitizers are not configured for ${CMAKE_CXX_COMPILER_ID}")
    endif()

    set(sanitizers "")
    if(enable_asan)
        list(APPEND sanitizers address)
    endif()
    if(enable_ubsan)
        list(APPEND sanitizers undefined)
    endif()
    list(JOIN sanitizers "," sanitizer_list)

    target_compile_options(${target} INTERFACE
        -fsanitize=${sanitizer_list}
        -fno-omit-frame-pointer
    )
    target_link_options(${target} INTERFACE -fsanitize=${sanitizer_list})
endfunction()
