# Assigning Variables
MK_DIR = if not exist $(subst /,\,$1) mkdir $(subst /,\,$1)
DEL_ALL = if exist $(subst /,\,$1) rmdir /s /q $(subst /,\,$1)

# including config file
-include ../config.mk

# Lib Makefile Directories Variables
L_BUILD_DIR ?= ../build
L_DEPS_DIR ?= ../build/dependencies
L_LIBS_DIR ?= ../build/libraries
L_OBJS_DIR ?= ../build/objects
L_SRCS_DIR ?= .

# Compiler Flags
CC ?= avr-gcc
AR ?= avr-ar

# Uc Specs
MCU ?= atmega32
F_CPU ?= 8000000

CFLAGS ?= -mmcu=$(MCU) -DF_CPU=$(F_CPU) -std=gnu99 -O2 -Wall

L_SRCS = $(wildcard $(L_SRCS_DIR)/*.c)

# Use the part of the filename before the underscore
BASE_NAMES := $(foreach src,$(notdir $(L_SRCS)),$(firstword $(subst _, ,$(basename $(src)))))

# Objects dependencies and libraries files
OBJS := $(addprefix $(L_OBJS_DIR)/, $(addsuffix .o, $(BASE_NAMES)))
DEPS := $(addprefix $(L_DEPS_DIR)/, $(addsuffix .d, $(BASE_NAMES)))
LIBS := $(addprefix $(L_LIBS_DIR)/lib, $(addsuffix .a, $(BASE_NAMES)))

# Preserve intermediate files
.PRECIOUS: $(L_OBJS_DIR)/%.o

# Default target
all: $(LIBS)

# compile source files into an object files also creates dependencies 
$(L_OBJS_DIR)/%.o: $(L_SRCS_DIR)/%*.c
	@$(call MK_DIR,$(L_BUILD_DIR))
	@$(call MK_DIR,$(L_OBJS_DIR))
	@$(call MK_DIR,$(L_DEPS_DIR))
	@$(call MK_DIR,$(L_LIBS_DIR))
	@$(CC) $(CFLAGS) -MD -MP -MF $(L_DEPS_DIR)/$*.d -c $< -o $@

# Include dependencies
-include $(DEPS)

# create static libraries
$(L_LIBS_DIR)/lib%.a : $(L_OBJS_DIR)/%.o
	@$(AR) rcs $@ $<
	@echo "Generated Library: $(notdir $@) Generation Time: $(DATE_CMD)" >> $(L_BUILD_DIR)/Libraries_Status_Report.txt
	@echo "Generated Library: $(notdir $@) Generation Time: $(DATE_CMD)"

# clean all generated files
clean:
	@$(call DEL_ALL,$(L_BUILD_DIR))
	@echo "Cleanup complete. All generated files have been removed."

# Status rule
status:
	@$(REPORT)


# Phony targets
.PHONY: all clean status help

# Delete on error so no corrupt files
.DELETE_ON_ERROR: