function(qtapp_set_project_warnings target warnings_as_errors)
    if(MSVC)
        set(warnings
            /W4
            /permissive-
            /Zc:__cplusplus
            /Zc:preprocessor
            /utf-8
        )

        if(warnings_as_errors)
            list(APPEND warnings /WX)
        endif()
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
        set(warnings
            -Wall
            -Wextra
            -Wpedantic
            -Wconversion
            -Wsign-conversion
            -Wshadow
            -Wnon-virtual-dtor
            -Wold-style-cast
            -Wcast-align
            -Woverloaded-virtual
            -Wnull-dereference
            -Wdouble-promotion
            -Wformat=2
        )

        if(warnings_as_errors)
            list(APPEND warnings -Werror)
        endif()
    else()
        message(WARNING "No project warning profile is defined for ${CMAKE_CXX_COMPILER_ID}")
    endif()

    target_compile_options(${target} INTERFACE ${warnings})
endfunction()
