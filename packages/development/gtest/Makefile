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

rootsrc			?= $(shell pwd)
LIBDIR			?= lib

CXX_SRCS		:= $(rootsrc)/src/gtest-all.cc
HEADERS			:= $(rootsrc)/include/gtest
OBJS			:= $(patsubst %.cc,%.o,$(CXX_SRCS))
LIB			:= gtest

CC			?= gcc
CXX			?= g++

ARFLAGS			:= rvs

override CFLAGS		:= $(CFLAGS) -W -Wall -Wextra -pthread
override CPPFLAGS	:= $(CPPFLAGS) -I. -I./include
override CXXFLAGS	:= $(CXXFLAGS) $(CFLAGS)

define __lib_install
	$(if $(SYSROOT),
		mkdir -p $(SYSROOT)/$(LIBDIR)
		mkdir -p $(SYSROOT)/usr
		mkdir -p $(SYSROOT)/usr/include
		cp lib$(LIB).a $(SYSROOT)/usr/$(LIBDIR)/
		cp -R $(HEADERS) $(SYSROOT)/usr/include/)
endef

all: lib$(LIB).a
	$(Q)true

install: all
	$(Q)$(__lib_install)
	$(Q)true

lib$(LIB).a: $(OBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(OBJS)

%.o: %.cc
	$(Q)$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $< -o $@

clean:
	$(Q)rm -rf $(OBJS) lib$(LIB).a

