# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    CMakeLists.txt                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: abelov <abelov@student.42london.com>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2026/08/31 01:40:22 by abelov            #+#    #+#              #
#    Updated: 2026/08/31 01:40:25 by abelov           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

cmake_minimum_required(VERSION 3.10.0)

set(CMAKE_SYSTEM_PROCESSOR i686)
#set(CMAKE_C_COMPILER clang)
set(CMAKE_C_COMPILER gcc)
#set(CMAKE_CPP_COMPILER g++)
set(CMAKE_CPP_COMPILER g++-9)
set(CMAKE_C_COMPILER gcc-9)

project("RainFall" VERSION 0.1.0 LANGUAGES C CXX ASM ASM_NASM)

set(CMAKE_C_STANDARD 11)

set(TARGET_EXE_NAME "${PROJECT_NAME}")

set(PROJECT_CFLAGS
        -m32
        -O0
        -g3
        -Wa,-L
        -no-pie -fno-pie
        -fno-reorder-blocks
        -fno-tree-vectorize
        -fno-builtin-memcpy
        -fno-builtin-memmove
        -fno-unroll-loops
        -fcf-protection=none
        -fno-stack-protector
        -fno-verbose-asm
        -fno-omit-frame-pointer
)

set(PROJECT_CXXFLAGS
        -m32
        -Wa,-L
        -no-pie
        -fno-pie
        -ggdb3 -gdwarf-5
        -maccumulate-outgoing-args
        -fcf-protection=none -mmanual-endbr
        -fno-omit-frame-pointer
        -fno-eliminate-unused-debug-symbols
        -fno-eliminate-unused-debug-types
        -femit-class-debug-always
)

IF(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    LIST(APPEND PROJECT_CFLAGS
            -fno-thread-jumps
            -fno-reorder-blocks-and-partition
            -fif-conversion
            -fif-conversion2
            -mmanual-endbr
            -mno-red-zone
            -fno-stack-protector
            -minline-all-stringops
            -mstringop-strategy=libcall
            -mmemcpy-strategy=loop:0:align,libcall:-1:align
    )
ENDIF()

set(COMMON_LDFLAGS
        -m32
#        -nodefaultlibs

)

if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
    LIST(APPEND PROJECT_CFLAGS
            -Wdocumentation
    )
ENDIF()

set(NASM_FLAGS -f elf64 -g -F dwarf -w+all -w-reloc-rel-dword)

set(TARGET_NAME "level0")
set(TARGET_SOURCE_DIR "level0/exploit/src")

file(GLOB_RECURSE TARGET_HEADERS "${TARGET_SOURCE_DIR}/*.h")
file(GLOB_RECURSE TARGET_SOURCES "${TARGET_SOURCE_DIR}/*.c")

add_executable(${TARGET_NAME}
        ${TARGET_HEADERS}
        ${TARGET_SOURCES}
        level0/study/src/test.c)

target_include_directories(${TARGET_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}
        /usr/include
        /usr/include/x86_64-linux-gnu)

target_link_libraries(${TARGET_NAME} "${TARGET_LIBRARIES}")
target_link_options(${TARGET_NAME} PRIVATE ${COMMON_LDFLAGS})
target_compile_options(${TARGET_NAME}
        PRIVATE "${PROJECT_CFLAGS}"
)

set(TARGET_NAME "level2")
set(TARGET_SOURCE_DIR "level2/exploit/src")

file(GLOB_RECURSE TARGET_HEADERS "${TARGET_SOURCE_DIR}/*.h")
file(GLOB_RECURSE TARGET_SOURCES "${TARGET_SOURCE_DIR}/*.c")

add_executable(${TARGET_NAME}
        ${TARGET_HEADERS}
        ${TARGET_SOURCES}
        level7/study/src/main.c)

target_include_directories(${TARGET_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}
        /usr/include
        /usr/include/x86_64-linux-gnu)

target_link_libraries(${TARGET_NAME} "${TARGET_LIBRARIES}")
target_link_options(${TARGET_NAME} PRIVATE ${COMMON_LDFLAGS})
target_compile_options(${TARGET_NAME}
        PRIVATE "${PROJECT_CFLAGS}"
        PUBLIC
        ${SDL2_CFLAGS_OTHER}
        ${SDL2_MIXER_CFLAGS_OTHER}
        ${FREETYPE2_CFLAGS_OTHER}
)

set(TARGET_NAME "level3")
set(TARGET_SOURCE_DIR "level3/study/src")

file(GLOB_RECURSE TARGET_HEADERS "${TARGET_SOURCE_DIR}/*.h")
file(GLOB_RECURSE TARGET_SOURCES "${TARGET_SOURCE_DIR}/*.c")

add_executable(${TARGET_NAME}
        ${TARGET_HEADERS}
        ${TARGET_SOURCES})

target_include_directories(${TARGET_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}
        /usr/include
        /usr/include/x86_64-linux-gnu)

target_link_libraries(${TARGET_NAME} "${TARGET_LIBRARIES}")
target_link_options(${TARGET_NAME} PRIVATE ${COMMON_LDFLAGS})
target_compile_options(${TARGET_NAME}
        PRIVATE "${PROJECT_CFLAGS}"
)


set(TARGET_NAME "level6")
set(TARGET_SOURCE_DIR "level6/study/src")

file(GLOB_RECURSE TARGET_HEADERS "${TARGET_SOURCE_DIR}/*.h")
file(GLOB_RECURSE TARGET_SOURCES "${TARGET_SOURCE_DIR}/*.c")

add_executable(${TARGET_NAME}
        ${TARGET_HEADERS}
        ${TARGET_SOURCES})

target_include_directories(${TARGET_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}
        /usr/include
        /usr/include/x86_64-linux-gnu)

target_link_libraries(${TARGET_NAME} "${TARGET_LIBRARIES}")
target_link_options(${TARGET_NAME} PRIVATE ${COMMON_LDFLAGS})
target_compile_options(${TARGET_NAME}
        PRIVATE "${PROJECT_CFLAGS}"
)

set(TARGET_NAME "level7")
set(TARGET_SOURCE_DIR "level7/study/src")

file(GLOB_RECURSE TARGET_HEADERS "${TARGET_SOURCE_DIR}/*.h")
file(GLOB_RECURSE TARGET_SOURCES "${TARGET_SOURCE_DIR}/*.c")

add_executable(${TARGET_NAME}
        ${TARGET_HEADERS}
        ${TARGET_SOURCES})

target_include_directories(${TARGET_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}
        /usr/include
        /usr/include/x86_64-linux-gnu)

target_link_libraries(${TARGET_NAME} "${TARGET_LIBRARIES}")
target_link_options(${TARGET_NAME} PRIVATE ${COMMON_LDFLAGS})
target_compile_options(${TARGET_NAME}
        PRIVATE "${PROJECT_CFLAGS}"
)


set(TARGET_NAME "level9")
set(TARGET_SOURCE_DIR "level9/study/src")

file(GLOB_RECURSE TARGET_HEADERS "${TARGET_SOURCE_DIR}/*.hpp")
file(GLOB_RECURSE TARGET_SOURCES "${TARGET_SOURCE_DIR}/*.cpp")

add_executable(${TARGET_NAME}
        ${TARGET_HEADERS}
        ${TARGET_SOURCES})

target_include_directories(${TARGET_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}
        /usr/include
        /usr/include/x86_64-linux-gnu)

target_link_libraries(${TARGET_NAME} "${TARGET_LIBRARIES}")
target_link_options(${TARGET_NAME}
        PRIVATE -m32
				-no-pie
				-Wl,-z,norelro
				-fno-stack-protector
				-Wl,-z,execstack
)
target_compile_options(${TARGET_NAME}
        PRIVATE "${PROJECT_CXXFLAGS}"
)

