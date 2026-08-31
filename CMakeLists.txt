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

cmake_minimum_required(VERSION 3.8.2)

#set(CMAKE_C_COMPILER clang)
set(CMAKE_C_COMPILER gcc)
set(CMAKE_C_COMPILER gcc-9)

project("RainFall" VERSION 0.1.0 LANGUAGES C ASM ASM_NASM)

set(CMAKE_C_STANDARD 11)

set(TARGET_EXE_NAME "${PROJECT_NAME}")

set(PROJECT_CFLAGS
        -Og
        -g3
        -Wa,-L
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

IF(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    LIST(APPEND PROJECT_CFLAGS
            -fno-thread-jumps
            -fno-reorder-blocks-and-partition
            -fif-conversion
            -fif-conversion2
            -mmanual-endbr
            -mno-red-zone
            -minline-all-stringops
            -mstringop-strategy=libcall
            -mmemcpy-strategy=loop:0:align,libcall:-1:align
    )
ENDIF()

if(CMAKE_C_COMPILER_ID STREQUAL "Clang")
    LIST(APPEND PROJECT_CFLAGS
            -Wdocumentation
    )
ENDIF()

set(NASM_FLAGS -f elf64 -g -F dwarf -w+all -w-reloc-rel-dword)
