# The Micro controller ,clock frequency and all used flags are configured in this file
PROJECT_NAME := $(notdir $(CURDIR))

MCU ?= atmega32
F_CPU ?= 8000000

CFLAGS ?= -mmcu=$(MCU) -DF_CPU=$(F_CPU) -std=gnu99 -Os -Wall


# Lib Makefile Directories
LIB_MAKE_FILE := ./lib 

M_BUILD_DIR := ./build
M_DEPS_DIR := ./build/dependencies
M_LIBS_DIR := ./build/libraries
M_OBJS_DIR := ./build/objects
M_PROGS_DIR := ./build/programs
M_SRCS_DIR := ./src

L_BUILD_DIR := ../build
L_DEPS_DIR := ../build/dependencies
L_LIBS_DIR := ../build/libraries
L_OBJS_DIR := ../build/objects
L_SRCS_DIR := .

CC := avr-gcc
AR := avr-ar
OBJCOPY := avr-objcopy
SIZE := avr-size