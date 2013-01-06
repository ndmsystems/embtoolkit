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

CXX_SRCS		:= $(wildcard $(rootsrc)/src/*.cpp)

OBJS			:= $(patsubst %.cpp,%.o,$(CXX_SRCS))
POBJS			:= $(patsubst %.o,%.po,$(OBJS))
SOBJS			:= $(patsubst %.o,%.So,$(OBJS))

__HEADERS		:= $(wildcard $(rootsrc)/include/*)
HEADERS			:= $(filter-out $(rootsrc)/include/support,$(__HEADERS))

CC			?= gcc
CXX			?= g++

LIB			:= c++
SHAREDLIB		:= $(LIB)
SHAREDLIB_NAME		:= lib$(SHAREDLIB).so.1
SHAREDLIB_LINK		:= lib$(SHAREDLIB).so
SHAREDLIB_SONAME	:= $(SHAREDLIB_NAME)

override LDFLAGS	:= $(LDFLAGS) -shared
override LDFLAGS	+= -Wl,--warn-shared-textrel -Wl,-x

override CFLAGS		:= $(CFLAGS) -I$(rootsrc)/include
override CFLAGS		+= -DLIBCXXRT -DNO_CATGETS_SUPPORT
override CXXFLAGS	:= $(CXXFLAGS) $(CFLAGS) -nostdinc++ -std=c++0x

LDADD			:= -lcxxrt -lpthread -lrt -ldl -lc

ARADD			:= $(shell $(CC) --print-file-name=libcxxrt.a)
ARADD			+= $(shell $(CC) --print-file-name=libpthread.a)
ARADD			+= $(shell $(CC) --print-file-name=librt.a)

ARADD_P			:= $(shell $(CC) --print-file-name=libcxxrt_p.a)
#ARADD_P		+= $(shell $(CC) --print-file-name=libpthread_p.a)
#ARADD_P		+= $(shell $(CC) --print-file-name=librt_p.a)

ARADD_PIC		:= $(shell $(CC) --print-file-name=libcxxrt_pic.a)
#ARADD_PIC		+= $(shell $(CC) --print-file-name=libpthread.a)
#ARADD_PIC		+= $(shell $(CC) --print-file-name=librt.a)

ARFLAGS			:= rvs

define __lib_install
	$(if $(SYSROOT),
		mkdir -p $(SYSROOT)/usr
		mkdir -p $(SYSROOT)/usr/include
		mkdir -p $(SYSROOT)/usr/include/c++
		mkdir -p $(SYSROOT)/usr/include/c++/v1
		cp -R $(HEADERS) $(SYSROOT)/usr/include/c++/v1
		chmod 755 $(SYSROOT)/usr/include/c++/v1
		chmod 644 $(SYSROOT)/usr/include/c++/v1/*
		chmod 755 $(SYSROOT)/usr/include/c++/v1/ext
		chmod 644 $(SYSROOT)/usr/include/c++/v1/ext/*
		mkdir -p $(SYSROOT)/$(LIBDIR)
		cp -d $(SHAREDLIB_NAME) $(SYSROOT)/$(LIBDIR)/
		cp -d $(SHAREDLIB_LINK) $(SYSROOT)/$(LIBDIR)/
		cp lib$(LIB).a $(SYSROOT)/$(LIBDIR)/
		cp lib$(LIB)_pic.a $(SYSROOT)/$(LIBDIR)/
		cp lib$(LIB)_p.a $(SYSROOT)/$(LIBDIR)/)
endef

all: lib$(LIB).a lib$(LIB)_p.a lib$(LIB)_pic.a $(SHAREDLIB_NAME)
	$(Q)true

install: all
	$(Q)$(__lib_install)
	$(Q)true

$(SHAREDLIB_NAME): $(SOBJS)
	$(Q)$(CC) $(CFLAGS) $(LDFLAGS) -o $@					\
			-Wl,-soname,$(SHAREDLIB_SONAME) $(SOBJS) $(LDADD)
	$(Q)ln -fs $(SHAREDLIB_NAME) $(SHAREDLIB_LINK)

lib$(LIB).a: $(OBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(OBJS)

lib$(LIB)_p.a: $(POBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(POBJS)

lib$(LIB)_pic.a: $(SOBJS)
	$(Q)$(AR) $(ARFLAGS) $@ $(SOBJS)

%.o: %.cpp
	$(Q)$(CXX) $(CXXFLAGS) -c $< -o $@

%.po: %.cpp
	$(Q)$(CXX) $(CXXFLAGS) -pg -c $< -o $@

%.So: %.cpp
	$(Q)$(CXX) -fPIC -DPIC $(CXXFLAGS) -c $< -o $@

clean:
	$(Q)rm -rf $(OBJS) $(SOBJS) $(POBJS)
	$(Q)rm -rf lib$(LIB).a lib$(LIB)_p.a lib$(LIB)_pic.a
	$(Q)rm -rf $(SHAREDLIB_NAME) $(SHAREDLIB_LINK)

