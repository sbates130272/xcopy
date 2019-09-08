########################################################################
##
## Eideticom
## Copyright (c) 2019, Eideticom
##
## This program is free software; you can redistribute it and/or modify it
## under the terms and conditions of the GNU General Public License,
## version 2, as published by the Free Software Foundation.
##
## This program is distributed in the hope it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
## FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
## more details.
##
########################################################################

OBJDIR=build

DESTDIR ?=

CPPFLAGS=-Iinc -Ibuild
CFLAGS=-std=gnu99 -g -O2 -fPIC -Wall -Werror
DEPFLAGS= -MT $@ -MMD -MP -MF $(OBJDIR)/$*.d
LDLIBS+=

EXE=xcopy
SRCS=$(wildcard src/*.c)
OBJS=$(addprefix $(OBJDIR)/, $(patsubst %.c,%.o, $(SRCS)))

ifneq ($(V), 1)
Q=@
MAKEFLAGS+=-s --no-print-directory
else
NQ=:
endif

compile: $(EXE)

clean:
	@$(NQ) echo "  CLEAN  $(EXE)"
	$(Q)rm -rf $(EXE) build *~ ./src/*~

$(OBJDIR)/version.h $(OBJDIR)/version.mk: FORCE $(OBJDIR)
	@$(SHELL_PATH) ./VERSION-GEN
$(OBJDIR)/src/main.o: $(OBJDIR)/version.h
-include $(OBJDIR)/version.mk

$(OBJDIR):
	$(Q)mkdir -p $(OBJDIR)/src

$(OBJDIR)/%.o: %.c | $(OBJDIR)
	@$(NQ) echo "  CC     $<"
	$(Q)$(COMPILE.c) $(DEPFLAGS) $< -o $@

$(EXE): $(OBJS)
	@$(NQ) echo "  LD     $@"
	$(Q)$(LINK.o) $^ $(LDLIBS) -o $@

.PHONY: clean compile FORCE

-include $(patsubst %.o,%.d,$(OBJS))
