# file-format: 1.0.0
cmake_minimum_required(VERSION 3.20)

set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)

include(cmake/target.cmake)
include(cmake/${TOOLCHAIN_FILE})

project(C5LCD)
add_executable(C5LCD)
include(cmake/files.cmake)
include(cmake/flags.cmake)
include(cmake/components.cmake)

# Stubs to be able to add compiler flag overrides, e.g. -Os
target_sources(${CMAKE_PROJECT_NAME} PRIVATE
  OpenSource/letter-shell-master/src/shell.c
  OpenSource/letter-shell-master/src/shell_cmd_list.c
  OpenSource/letter-shell-master/src/shell_companion.c
  OpenSource/letter-shell-master/src/shell_ext.c
  lettershell_adapt/shell_port.c
)

target_include_directories(${CMAKE_PROJECT_NAME} PUBLIC
  OpenSource/letter-shell-master/src
  lettershell_adapt/
)

target_compile_definitions(${CMAKE_PROJECT_NAME} PUBLIC
  # Add additional defined symbols here
)

target_compile_options(${CMAKE_PROJECT_NAME} PUBLIC
  # Add additional compiler flags here
)

target_link_options(${CMAKE_PROJECT_NAME} PUBLIC
  # Add additional linker flags here
)

target_link_directories(${CMAKE_PROJECT_NAME} PUBLIC
  # Add additional linker search directories here
)

target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC
  # Add additional linker libraries here
)

add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_OBJCOPY} -O binary
          $<TARGET_FILE:${CMAKE_PROJECT_NAME}>
          $<TARGET_FILE_DIR:${CMAKE_PROJECT_NAME}>/${CMAKE_PROJECT_NAME}.bin
  COMMENT "Generating ${CMAKE_PROJECT_NAME}.bin"
)
