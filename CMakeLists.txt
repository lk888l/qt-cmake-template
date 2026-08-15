cmake_minimum_required(VERSION 3.25...4.4)

project(
    QtAppTemplate
    VERSION 0.1.0
    DESCRIPTION "A production-ready Qt Widgets application template"
    LANGUAGES CXX
)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(PreventInSourceBuilds)
qtapp_prevent_in_source_builds()

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(QTAPP_ORGANIZATION_NAME "Your Organization" CACHE STRING "Organization shown in application metadata")
set(QTAPP_ORGANIZATION_DOMAIN "example.com" CACHE STRING "Organization domain used by QSettings")
set(QTAPP_APPLICATION_ID "com.example.qt-app-template" CACHE STRING "Reverse-DNS application identifier")

include(CTest)
include(ProjectOptions)
qtapp_setup_project_options()

include(StaticAnalyzers)
qtapp_enable_static_analyzers()

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Svg Widgets)
if(BUILD_TESTING)
    find_package(Qt6 6.5 REQUIRED COMPONENTS Test)
endif()

qt_standard_project_setup(REQUIRES 6.5)

include(StringUtilities)
qtapp_escape_cpp_string("${PROJECT_NAME}" QTAPP_CONFIG_PROJECT_NAME)
qtapp_escape_cpp_string("${PROJECT_VERSION}" QTAPP_CONFIG_PROJECT_VERSION)
qtapp_escape_cpp_string("${PROJECT_DESCRIPTION}" QTAPP_CONFIG_PROJECT_DESCRIPTION)
qtapp_escape_cpp_string("${QTAPP_ORGANIZATION_NAME}" QTAPP_CONFIG_ORGANIZATION_NAME)
qtapp_escape_cpp_string("${QTAPP_ORGANIZATION_DOMAIN}" QTAPP_CONFIG_ORGANIZATION_DOMAIN)
qtapp_escape_cpp_string("${QTAPP_APPLICATION_ID}" QTAPP_CONFIG_APPLICATION_ID)

configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/ProjectConfig.hpp.in"
    "${CMAKE_CURRENT_BINARY_DIR}/generated/app/ProjectConfig.hpp"
    @ONLY
)

add_subdirectory(src)

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()

include(DeveloperTools)
qtapp_add_developer_targets()

include(Packaging)
qtapp_configure_packaging(${PROJECT_NAME})
