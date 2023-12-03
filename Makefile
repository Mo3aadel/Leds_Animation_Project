# Assigning variables
MK_DIR = if not exist $(subst /,\,$1) mkdir $(subst /,\,$1)
DEL_ALL = if exist $(subst /,\,$1) rmdir /s /q $(subst /,\,$1)
DATE_CMD = %date% %time%
REPORT = if exist $(subst /,\,$(M_BUILD_DIR))\Binaries_Status_Report.txt \
(type $(subst /,\,$(M_BUILD_DIR))\Binaries_Status_Report.txt) \

-include config.mk

LIB_MAKE_FILE ?= ./lib 

M_BUILD_DIR ?= ./build
M_DEPS_DIR ?= ./build/dependencies
M_LIBS_DIR ?= ./build/libraries
M_OBJS_DIR ?= ./build/objects
M_PROGS_DIR ?= ./build/programs
M_SRCS_DIR ?= ./src

# compiler flags
CC ?= avr-gcc
OBJCOPY ?= avr-objcopy
SIZE ?= avr-size

MCU ?= atmega32
F_CPU ?= 8000000

CFLAGS ?= -mmcu=$(MCU) -DF_CPU=$(F_CPU) -std=gnu99 -O2 -Wall
LDFLAGS ?= -L$(M_LIBS_DIR)

SRCS = $(wildcard $(M_SRCS_DIR)/*.c)
OBJS = $(patsubst $(M_SRCS_DIR)/%.c,$(M_OBJS_DIR)/%.o,$(SRCS))
DEPS = $(patsubst $(M_SRCS_DIR)/%.c,$(M_DEPS_DIR)/%.d,$(SRCS))
ELFS = $(patsubst $(M_SRCS_DIR)/%.c,$(M_PROGS_DIR)/%.elf,$(SRCS))
HEXS = $(patsubst $(M_SRCS_DIR)/%.c,$(M_PROGS_DIR)/%.hex,$(SRCS))


LIBS = $(wildcard $(M_LIBS_DIR)/*.a)

# Preserve intermediate files
.PRECIOUS: $(M_PROGS_DIR)/%.elf $(M_OBJS_DIR)/%.o

# Default target
all: libs $(HEXS)

# Phony Target to always check if the lib makefile is up to date or not
libs:
	@$(MAKE) -C $(LIB_MAKE_FILE) CFLAGS="$(CFLAGS)"

# compile source files into an object files also creates dependencies  
$(M_OBJS_DIR)/%.o: $(M_SRCS_DIR)/%.c
	@$(CC) $(CFLAGS) -MD -MP -MF $(M_DEPS_DIR)/$*.d -c $< -o $@

# Include dependencies
-include $(DEPS)

# create .elf files also generates binary report with the same source file name
$(M_PROGS_DIR)/%.elf: $(M_OBJS_DIR)/%.o $(LIBS)
	@$(call MK_DIR,$(M_PROGS_DIR))
	@$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@ $(LIBS)
	@$(SIZE) --format=avr --mcu=$(MCU) $@ > $(M_PROGS_DIR)/binaryReport_$*.txt
	@echo "Generated Binary: $(notdir $@) Generation Time: $(DATE_CMD)" >> $(M_BUILD_DIR)/Binaries_Status_Report.txt
	@echo "Generated Binary: $(notdir $@) Generation Time: $(DATE_CMD)"

# create .hex files 
$(M_PROGS_DIR)/%.hex: $(M_PROGS_DIR)/%.elf
	@$(OBJCOPY) -j .text -j .data -O ihex $< $@
	@echo "Generated Binary: $(notdir $@) Generation Time: $(DATE_CMD)" >> $(M_BUILD_DIR)/Binaries_Status_Report.txt
	@echo "Generated Binary: $(notdir $@) Generation Time: $(DATE_CMD)"
	@$(BINARY_REPORT)
 
# clean all generated files
clean:
	@$(call DEL_ALL,$(M_BUILD_DIR))
	@echo "Cleanup complete. All generated files have been removed."

# Status rule
status:
	@$(REPORT)

# Phony targets
.PHONY: all libs clean status help

# Delete on error so no corrupt files
.DELETE_ON_ERROR: