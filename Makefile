# Set up cross-compilation toolchain
TOOLCHAIN	= arm-none-eabi
CC		= $(TOOLCHAIN)-gcc
AS		= $(TOOLCHAIN)-as
LD		= $(TOOLCHAIN)-ld
OBJCOPY		= $(TOOLCHAIN)-objcopy
OBJDUMP		= $(TOOLCHAIN)-objdump

# Targets
BUILDDIR	= build
OBJDIR		= objs
INCLUDES	= include
SRCDIR		= src
TARGET		= kernel.img
LINKER		= pious.ld
AOUT		= $(BUILDDIR)/kernel.elf

START		= $(OBJDIR)/start.o
OBJS		= $(patsubst $(SRCDIR)/%.s,$(OBJDIR)/%.o,$(wildcard $(SRCDIR)/*.s))
OBJS		:= $(filter-out $(START),$(OBJS))

MAP		= $(BUILDDIR)/kernel.map
LIST		= $(BUILDDIR)/kernel.list

# Build options
CFLAGS		+= -O0 -mfpu=vfp -mfloat-abi=soft -march=armv6zk
CFLAGS		+= -mtune=arm1176jzf-s -I$(INCLUDES) -nostartfiles


#all:
#	@echo "This Makefile is still in progress."
#	@echo "Objects: $(OBJS)"
#	@echo "Source directory: $(SRCDIR)"
#	@echo "Sources: $(wildcard $(SRCDIR)/*.s)"
#	@echo "a.out: $(AOUT)"

.PHONY: all
all: $(TARGET) $(LIST)

$(BUILDDIR):
	mkdir $(BUILDDIR)

$(OBJDIR):
	mkdir $(OBJDIR)

$(TARGET): $(AOUT) $(BUILDDIR)
	$(OBJCOPY) $(AOUT) -O binary $@

$(AOUT): $(OBJS) $(LINKER) $(START) $(BUILDDIR)
	$(LD) -Map $(MAP) -o $@ -T $(LINKER) $(OBJS)

$(LIST): $(AOUT) $(BUILDDIR)
	$(OBJDUMP) -d $(AOUT) > $@

obj-no-start:
	echo "OBJS: $(filter-out $(START),$(OBJS))"

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(OBJDIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJDIR)/%.o: $(SRCDIR)/%.s $(OBJDIR)
	$(AS) -o $@ $<

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(START)
	rm -f $(OBJDIR)/*.d
	rm -f $(TARGET)
	rm -f $(AOUT)
	rm -f $(MAP)
	rm -f $(LIST)
