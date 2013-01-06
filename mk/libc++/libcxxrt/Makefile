################################################################################
# Copyright 2012 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS
# IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

rootsrc			?= $(shell pwd)
LIBDIR			?= lib

__NO_C_SRCS		:= $(addprefix $(rootsrc)/src/,cxa_atexit.c cxa_finalize.c)
C_SRCS			:= $(wildcard $(rootsrc)/src/*.c)
C_SRCS			:= $(filter-out $(__NO_C_SRCS),$(C_SRCS))

CXX_SRCS		:= $(wildcard $(rootsrc)/src/*.cc)

__HEADERS		:= cxxabi.h unwind-arm.h unwind.h unwind-itanium.h
HEADERS			:= $(addprefix $(rootsrc)/src/,$(__HEADERS))

OBJS			:= $(patsubst %.c,%.o,$(C_SRCS))
OBJS			+= $(patsubst %.cc,%.o,$(CXX_SRCS))
POBJS			:= $(patsubst %.o,%.po,$(OBJS))
SOBJS			:= $(patsubst %.o,%.So,$(OBJS))

LIB			:= cxxrt
SHAREDLIB		:= $(LIB)
SHAREDLIB_NAME		:= lib$(SHAREDLIB).so.1
SHAREDLIB_LINK		:= lib$(SHAREDLIB).so
SHAREDLIB_SONAME	:= $(SHAREDLIB_NAME)

CC			?= gcc
CXX			?= g++

ARFLAGS			:= rvs
ARADD			:= $(shell $(CC) --print-file-name=libgcc.a)
ARADD			+= $(shell $(CC) --print-file-name=libgcc_eh.a)

override CFLAGS		:= $(CFLAGS) -I$(rootsrc)/src
override CXXFLAGS	:= $(CXXFLAGS) $(CFLAGS)

define __lib_install
	$(if $(SYSROOT),
		mkdir -p $(SYSROOT)/$(LIBDIR)
		mkdir -p $(SYSROOT)/usr
		mkdir -p $(SYSROOT)/usr/include
		mkdir -p $(SYSROOT)/usr/include/c++
		mkdir -p $(SYSROOT)/usr/include/c++/v1
		cp lib$(LIB).a $(SYSROOT)/$(LIBDIR)/
		cp lib$(LIB)_pic.a $(SYSROOT)/$(LIBDIR)/
		cp lib$(LIB)_p.a $(SYSROOT)/$(LIBDIR)/
		cp $(HEADERS) $(SYSROOT)/usr/include/c++/v1/)
endef

all: lib$(LIB).a lib$(LIB)_p.a lib$(LIB)_pic.a
	$(Q)true

install: all
	$(Q)$(__lib_install)
	$(Q)true

lib$(LIB).a: $(OBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(OBJS) $(ARADD)

lib$(LIB)_p.a: $(POBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(POBJS) $(ARADD)

lib$(LIB)_pic.a: $(SOBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(SOBJS) $(ARADD)

%.o: %.c
	$(Q)$(CC) $(CFLAGS) -c $< -o $@

%.o: %.cc
	$(Q)$(CXX) $(CXXFLAGS) -c $< -o $@

%.po: %.c
	$(Q)$(CC) $(CFLAGS) -pg -c $< -o $@

%.po: %.cc
	$(Q)$(CXX) $(CXXFLAGS) -pg -c $< -o $@

%.So: %.c
	$(Q)$(CC) -fPIC -DPIC $(CFLAGS) -c $< -o $@

%.So: %.cc
	$(Q)$(CXX) $(CXXFLAGS) -fPIC -DPIC $(CXXFLAGS) -c $< -o $@

clean:
	$(Q)rm -rf $(OBJS) $(SOBJS) $(POBJS)
	$(Q)rm -rf lib$(LIB).a lib$(LIB)_p.a lib$(LIB)_pic.a

