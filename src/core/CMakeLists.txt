add_library(qtapp_core STATIC)
add_library(${PROJECT_NAME}::Core ALIAS qtapp_core)

target_sources(qtapp_core
    PRIVATE
        ApplicationInfo.cpp
    PUBLIC
        FILE_SET public_headers
        TYPE HEADERS
        BASE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/include"
        FILES
            include/app/core/ApplicationInfo.hpp
)

target_include_directories(qtapp_core
    PRIVATE
        "${PROJECT_BINARY_DIR}/generated"
)

target_link_libraries(qtapp_core
    PUBLIC
        Qt6::Core
    PRIVATE
        ${PROJECT_NAME}::Options
        ${PROJECT_NAME}::Warnings
)

set_target_properties(qtapp_core PROPERTIES
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN YES
    FOLDER "Libraries"
)
