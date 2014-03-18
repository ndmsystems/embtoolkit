################################################################################
# Copyright 2013 Abdoulaye Walsimou GAYE <awg@embtoolkit.org>. All rights reserved.
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

rootsrc/		?=
LIBDIR			?= lib

#
# Sanitizer common part
#
SANCOMMON		:= sanitizer_common
SANCOMMON_CXXSRCS	:= $(wildcard $(rootsrc/)lib/sanitizer_common/*.cc)
SANCOMMON_CXXSRCS	+= $(wildcard $(rootsrc/)lib/interception/*.cc)
SANCOMMON_CSRCS		:= $(wildcard $(rootsrc/)lib/sanitizer_common/*.c)
SANCOMMON_CSRCS		+= $(wildcard $(rootsrc/)lib/interception/*.c)

SANCOMMON_OBJS		:= $(patsubst %.cc,%.o,$(SANCOMMON_CXXSRCS))
SANCOMMON_OBJS		+= $(patsubst %.c,%.o,$(SANCOMMON_CSRCS))

SANCOMMON_EXTRA_CFLAGS	:= -fno-rtti

#
# Address sanitizer part
#
ASAN			:= asan
ASAN_CXXSRCS		:= $(wildcard $(rootsrc/)lib/asan/*.cc)
ASAN_CSRCS		:= $(wildcard $(rootsrc/)lib/asan/*.c)

ASAN_OBJS		:= $(patsubst %.cc,%.o,$(ASAN_CXXSRCS))
ASAN_OBJS		+= $(patsubst %.c,%.o,$(ASAN_CSRCS))

ASAN_EXTRA_CFLAGS	:= -fno-rtti

#
# Thread sanitizer part
#
TSAN			:= tsan
TSAN_CXXSRCS		:= $(wildcard $(rootsrc/)lib/tsan/rtl/*.cc)
TSAN_CSRCS		:= $(wildcard $(rootsrc/)lib/tsan/rtl/*.c)
TSAN_OBJS		:= $(patsubst %.cc,%.o,$(TSAN_CXXSRCS))
TSAN_OBJS		+= $(patsubst %.c,%.o,$(TSAN_CSRCS))

#
# Undefined behavior sanitizer part
#
UBSAN			:= ubsan
UBSAN_CXXSRCS		:= $(wildcard $(rootsrc/)lib/ubsan/*.cc)
UBSAN_CSRCS		:= $(wildcard $(rootsrc/)lib/ubsan/*.c)

UBSAN_OBJS		:= $(patsubst %.cc,%.o,$(UBSAN_CXXSRCS))
UBSAN_OBJS		+= $(patsubst %.c,%.o,$(UBSAN_CSRCS))

#
# Common part
#
CC			?= gcc
CXX			?= g++

SANCOMMON_CFLAGS	:= -W -Wall -fPIC -fno-builtin -fno-exceptions
SANCOMMON_CFLAGS	+= -fomit-frame-pointer -funwind-tables
SANCOMMON_CFLAGS	+= -fno-stack-protector -fvisibility=hidden -g
#
# FIXME: remove this avec full merge of compiler-rt/llvm/clang-3.3.
# The copy of compiler-rt shipped with EmbToolkit was in the middle of
# compiler-rt-3.3 development.
#
SANCOMMON_CFLAGS	+= -DASAN_ALLOCATOR_VERSION=1

ARFLAGS			:= rvs

override CFLAGS		:=  $(CFLAGS) $(SANCOMMON_CFLAGS)
override CPPFLAGS	:= $(CPPFLAGS) -I$(rootsrc/)include -I$(rootsrc/)lib
override CXXFLAGS	:= $(CXXFLAGS) $(CFLAGS)

define __lib_install
	$(if $(SYSROOT),
		mkdir -p $(SYSROOT)/usr
		mkdir -p $(SYSROOT)/usr/$(LIBDIR)
		cp lib$(SANCOMMON).a $(SYSROOT)/usr/$(LIBDIR)
		cp lib$(ASAN).a $(SYSROOT)/usr/$(LIBDIR)
		cp lib$(UBSAN).a $(SYSROOT)/usr/$(LIBDIR))
endef

all: lib$(SANCOMMON).a lib$(ASAN).a lib$(UBSAN).a
	$(Q)true

install: all
	$(Q)$(__lib_install)

lib$(SANCOMMON).a: EXTRA_CFLAGS = $(SANCOMMON_EXTRA_CFLAGS)
lib$(SANCOMMON).a: $(SANCOMMON_OBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(SANCOMMON_OBJS)

lib$(ASAN).a: EXTRA_CFLAGS = $(ASAN_EXTRA_CFLAGS)
lib$(ASAN).a: $(ASAN_OBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(ASAN_OBJS)

lib$(TSAN).a: $(TSAN_OBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(TSAN_OBJS)

lib$(UBSAN).a: $(UBSAN_OBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(UBSAN_OBJS)

%.o: %.c
	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) -c $< -o $@

%.o: %.cc
	$(Q)$(CXX) $(CXXFLAGS) $(EXTRA_CFLAGS) $(CPPFLAGS) -c $< -o $@

clean:
	$(Q)rm -rf $(SANCOMMON_OBJS) $(ASAN_OBJS) $(TSAN_OBJS) $(UBSAN_OBJS)
	$(Q)rm -rf lib$(SANCOMMON).a lib$(ASAN).a lib$(TSAN).a lib$(UBSAN).a
