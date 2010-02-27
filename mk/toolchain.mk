################################################################################
# GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# Copyright(C) 2009 GAYE Abdoulaye Walsimou. All rights reserved.
#
# This program is free software; you can distribute it and/or modify it
# under the terms of the GNU General Public License
# (Version 2 or later) published by the Free Software Foundation.
#
# This program is distributed in the hope it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
################################################################################
#
# \file         toolchain.mk
# \brief	toolchain.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
################################################################################

TARGETCC := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-gcc
TARGETCXX := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-g++
TARGETAR := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-ar
TARGETRANLIB := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-ranlib
TARGETLD := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-ld
TARGETNM := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-nm
TARGETSTRIP := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-strip
TARGETOBJDUMP := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-objdump
TARGETOBJCOPY := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-objcopy
TARGET_CFLAGS = $(subst ",,$(strip $(CONFIG_EMBTK_TARGET_COMPILER_CFLAGS)))
CROSS_COMPILE := $(TOOLS)/bin/$(STRICT_GNU_TARGET)-

export TARGETCC TARGETCXX TARGETAR TARGETRANLIB TARGETLD TARGETNM
export TARGETSTRIP TARGETOBJDUMP TARGETOBJCOPY TARGET_CFLAGS CROSS_COMPILE

ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
LIBDIR=lib32
else
LIBDIR=lib
endif
export LIBDIR

#ccache on host
include $(EMBTK_ROOT)/mk/ccache.mk

#GMP on host
include $(EMBTK_ROOT)/mk/gmphost.mk

#MPFR
include $(EMBTK_ROOT)/mk/mpfrhost.mk

#MPC
include $(EMBTK_ROOT)/mk/mpchost.mk

#binutils
include $(EMBTK_ROOT)/mk/binutils.mk

#GCC
include $(EMBTK_ROOT)/mk/gcc.mk

#linux kernel headers
include $(EMBTK_ROOT)/mk/kernel-headers.mk

#Autotools
include $(EMBTK_ROOT)/mk/autoconf.mk
include $(EMBTK_ROOT)/mk/automake.mk
include $(EMBTK_ROOT)/mk/m4.mk


ifeq ($(CONFIG_EMBTK_CLIB_EGLIBC),y)
#EGLIBC
include $(EMBTK_ROOT)/mk/eglibc.mk
TOOLCHAINBUILD := mkinitialpath m4_install autoconf_install automake_install \
		kernel-headers_install ccachehost_install \
		gmphost_install mpfrhost_install mpchost_install \
		binutils_install gcc1_install eglibc-headers_install \
		gcc2_install eglibc_install gcc3_install
else
#uClibc
include $(EMBTK_ROOT)/mk/uclibc.mk
TOOLCHAINBUILD := mkinitialpath m4_install autoconf_install automake_install \
		kernel-headers_install ccachehost_install \
		gmphost_install mpfrhost_install mpchost_install \
		binutils_install gcc1_install uclibc_install gcc3_install
endif

#targets
buildtoolchain: $(TOOLCHAINBUILD)
	$(call EMBTK_GENERIC_MESSAGE,"You successfully build a toolchain for \
	$(STRICT_GNU_TARGET) !!!")

symlink_tools:
	@cd $(TOOLS)/bin/; export TOOLS_LIST="`ls`"; \
	for i in $$TOOLS_LIST;do \
	TOOLS_NAME=$$TOOLS_NAME" ""`echo $$i | sed 's/$(STRICT_GNU_TARGET)-*//'`" ; \
	done; \
	export TOOLS_NAME; \
	for i in $$TOOLS_NAME;do \
	ln -s $(STRICT_GNU_TARGET)-$$i $(GNU_TARGET)-$$i; \
	done

