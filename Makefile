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
KOBJS		= $(patsubst $(SRCDIR)/kern/%.s,$(OBJDIR)/%.o,$(wildcard $(SRCDIR)/kern/*.s))
KOBJS		:= $(filter-out $(START),$(KOBJS))
UOBJS		= $(patsubst $(SRCDIR)/shell/%.s,$(OBJDIR)/%.o,$(wildcard $(SRCDIR)/shell/*.s))
OBJS		= $(KOBJS) $(UOBJS)


MAP		= $(BUILDDIR)/kernel.map
LIST		= $(BUILDDIR)/kernel.list

# Build options
CFLAGS		+= -O0 -mfpu=vfp -mfloat-abi=soft -march=armv6zk
CFLAGS		+= -mtune=arm1176jzf-s -I$(INCLUDES) -nostartfiles


.PHONY: all
all: $(TARGET) $(LIST)

info:
	@echo "This Makefile is still in progress."
	@echo "Objects: $(OBJS)"
	@echo "Source directory: $(SRCDIR)"
	@echo "Sources: $(wildcard $(SRCDIR)/*.s)"
	@echo "a.out: $(AOUT)"

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

$(START): $(SRCDIR)/start.s
	$(AS) -o $@ $<

$(OBJDIR)/%.o: $(SRCDIR)/shell/%.s $(OBJDIR)
	$(AS) -o $@ $<

$(OBJDIR)/%.o: $(SRCDIR)/kern/%.s $(OBJDIR)
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
