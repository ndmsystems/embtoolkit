################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         macros.mk
# \brief	macros.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

# Embtoolkit colors
EMBTK_COLOR_RED = "\E[1;31m"
EMBTK_COLOR_GREEN = "\E[1;32m"
EMBTK_COLOR_YELLOW = "\E[1;33m"
EMBTK_COLOR_BLUE = "\E[1;34m"
EMBTK_NO_COLOR = "\E[0m"

# echo colored text
#usage $(call ECHO_RED,$(TEXT))
define ECHO_RED
	@echo -e $(EMBTK_COLOR_RED)$(1)$(EMBTK_NO_COLOR)
endef
#usage $(call ECHO_GREEN,$(TEXT))
define ECHO_GREEN
	@echo -e $(EMBTK_COLOR_GREEN)$(1)$(EMBTK_NO_COLOR)
endef
#usage $(call ECHO_YELLOW,$(TEXT))
define ECHO_YELLOW
	@echo -e $(EMBTK_COLOR_YELLOW)$(1)$(EMBTK_NO_COLOR)
endef
#usage $(call ECHO_BLUE,$(TEXT))
define ECHO_BLUE
	@echo -e $(EMBTK_COLOR_BLUE)$(1)$(EMBTK_NO_COLOR)
endef

#
# wget wrapper
# usage: $(call EMBTK_WGET,$(OUTPUT_FILE),$(SITE),$(FOREIGN_FILE))
#
__WGET_OPTS = --tries=5 --timeout=10 --waitretry=5
define EMBTK_WGET
	wget $(__WGET_OPTS) -O $(DOWNLOAD_DIR)/$(strip $(1))		\
	$(strip $(2))/$(strip $(3)) ||					\
	wget $(__WGET_OPTS) --no-passive-ftp -O 			\
	$(DOWNLOAD_DIR)/$(strip $(1))	$(strip $(2))/$(strip $(3))
endef

#Decompress message
#usage $(call EMBTK_DECOMPRESS_MSG,$(NAME_PACKAGE))
define EMBTK_DECOMPRESS_MSG
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # Decompressing $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef

#Configure message
#usage $(call EMBTK_CONFIGURE_MSG,$(NAME_PACKAGE))
define EMBTK_CONFIGURE_MSG
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # Configuring $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef

#Build message
#usage $(call EMBTK_BUILD_MSG,$(NAME_PACKAGE))
define EMBTK_BUILD_MSG
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # Building $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef

#Install message
#usage $(call EMBTK_INSTALL_MSG,$(NAME_PACKAGE))
define EMBTK_INSTALL_MSG
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # Installing $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef

#Install message
#usage $(call EMBTK_ERROR_MSG,$(MESSAGE))
define EMBTK_ERROR_MSG
	$(call ECHO_RED,"################################################################################")
	$(call ECHO_RED,"# EmbToolkit # ERROR: $(1)")
	$(call ECHO_RED,"################################################################################")
endef

#Generic message
#usage $(call EMBTK_GENERIC_MESSAGE,$(GENERIC_MESSAGE))
define EMBTK_GENERIC_MESSAGE
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef
define EMBTK_GENERIC_MSG
	$(call EMBTK_GENERIC_MESSAGE,$(1))
endef

#Successful build of EmbToolkit message
successful_build:
	$(call ECHO_BLUE,"################################## EmbToolkit ##################################")
	$(call ECHO_BLUE," --------------------- ")
	$(call ECHO_BLUE,"| Toolchain build log |")
	$(call ECHO_BLUE," --------------------- ")
	$(call ECHO_BLUE,"You successfully build your toolchain for $(GNU_TARGET)")
	$(call ECHO_BLUE,"Tools built (GCC compiler, Binutils, etc.) are located in:")
	$(call ECHO_BLUE,"    $(TOOLS)/bin")
	@echo
	$(call ECHO_BLUE," ---------------------------- ")
	$(call ECHO_BLUE,"| Root file system build log |")
	$(call ECHO_BLUE," ---------------------------- ")
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
	$(call ECHO_BLUE,"You also successfully build a root filesystem located in the root directory")
	$(call ECHO_BLUE,"of EmbToolkit.")
else
	$(call ECHO_GREEN,"Build of root filesystem not selected.")
endif
	@echo
	$(call ECHO_BLUE," ---------------------------- ")
	$(call ECHO_BLUE,"| Embedded systems Toolkit   |")
	$(call ECHO_BLUE," ---------------------------- ")
	$(call ECHO_BLUE,"Hope that EmbToolkit will be useful for your project !!!")
	$(call ECHO_BLUE,"Please report any bugs/suggestion at:")
	$(call ECHO_BLUE,"   http://www.embtoolkit.org/issues/projects/show/embtoolkit")
	$(call ECHO_BLUE,"You can also visit the wiki at:")
	$(call ECHO_BLUE,"   http://www.embtoolkit.org")
	@echo
	$(call ECHO_BLUE,"################################################################################")

#Macro to adapt libtool files (*.la) for cross compiling
libtool_files_adapt:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib32 -name *.la`; \
	for i in $$LIBTOOLS_LA_FILES; \
	do \
	sed -e "s;libdir='\/usr\/lib32';libdir='$(SYSROOT)\/usr\/lib32';" $$i \
	> $$i.new; \
	mv $$i.new $$i; \
	done
else
	@LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib -name *.la`; \
	for i in $$LIBTOOLS_LA_FILES; \
	do \
	sed -e "s;libdir='\/usr\/lib';libdir='$(SYSROOT)\/usr\/lib';" < $$i \
	> $$i.new; \
	mv $$i.new $$i; \
	done
endif

#Macro to restore libtool files (*.la)
libtool_files_restore:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib32 -name *.la`; \
	for i in $$LIBTOOLS_LA_FILES; \
	do \
	sed -e "s;libdir='$(SYSROOT)\/usr\/lib32';libdir='\/usr\/lib32';" $$i \
	> $$i.new; \
	mv $$i.new $$i; \
	done
else
	@LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib -name *.la`; \
	for i in $$LIBTOOLS_LA_FILES; \
	do \
	sed -e "s;libdir='$(SYSROOT)\/usr\/lib';libdir='\/usr\/lib';" < $$i \
	> $$i.new; \
	mv $$i.new $$i; \
	done
endif

#Macro to adapt pkg-config files for cross compiling
pkgconfig_files_adapt:
ifeq ($(CONFIG_EMBTK_64BITS_FS_COMPAT32),y)
	@PKGCONF_FILES=`find $(SYSROOT)/usr/lib32/pkgconfig -name *.pc`; \
	for i in $$PKGCONF_FILES; \
	do \
	sed -e 's;prefix=.*;prefix=$(SYSROOT)/usr;' \
	-e 's;includedir=$${prefix}/include;includedir=$(SYSROOT)/usr/include;' \
	-e 's;libdir=.*;libdir=$(SYSROOT)/usr/lib32;' < $$i > $$i.new; \
	mv $$i.new $$i; \
	done
else
	@PKGCONF_FILES=`find $(SYSROOT)/usr/lib/pkgconfig -name *.pc`; \
	for i in $$PKGCONF_FILES; \
	do \
	sed -e 's;prefix=.*;prefix=$(SYSROOT)/usr;' \
	-e 's;includedir=$${prefix}/include;includedir=$(SYSROOT)/usr/include;' \
	-e 's;libdir=.*;libdir=$(SYSROOT)/usr/lib;' < $$i > $$i.new; \
	mv $$i.new $$i; \
	done
endif

#A macro to remove rpath in packages that use libtool -rpath
define EMBTK_KILL_LT_RPATH
	@cd $(1); \
	LOCAL_LT_FILES=`find -type f -name libtool`; \
	for i in $$LOCAL_LT_FILES; \
	do \
	sed -i 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' $$i; \
	sed -i 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' $$i; \
	done
endef

#
# A macro to get packages version from .config file.
# usage: $(call EMBTK_GET_PKG_VERSION,PACKAGE)
#
EMBTK_GET_PKG_VERSION = $(subst ",,$(strip $(CONFIG_EMBTK_$(1)_VERSION_STRING)))

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package and sets environment variables correctly.
# Usage:
# $(call EMBTK_CONFIGURE_PKG,PACKAGE)
#
define EMBTK_CONFIGURE_AUTORECONF_PKG
@if [ "x$(CONFIG_EMBTK_$(1)_NEED_AUTORECONF)" == "xy" ]; then		\
	cd $($(1)_SRC_DIR);						\
	$(AUTORECONF) --install -f;					\
fi
endef
define EMBTK_PRINT_CONFIGURE_OPTS
	$(call ECHO_BLUE,"Configure options:")
	@for i in `echo $(1) | tr " " "\n"`; \
	do echo -e $(EMBTK_COLOR_BLUE)$$i$(EMBTK_NO_COLOR); done
endef
define EMBTK_CONFIGURE_PKG
	$(call EMBTK_GENERIC_MSG,"Configure $($(1)_PACKAGE)...")
	@test -e $($(1)_SRC_DIR)/configure.ac || exit 1
	$(call  EMBTK_CONFIGURE_AUTORECONF_PKG,$(1))
	$(call EMBTK_PRINT_CONFIGURE_OPTS,"$($(1)_CONFIGURE_OPTS)")
	@cd $($(1)_BUILD_DIR);						\
	CC=$(TARGETCC_CACHED)						\
	CXX=$(TARGETCXX_CACHED)						\
	AR=$(TARGETAR)							\
	RANLIB=$(TARGETRANLIB)						\
	AS=$(CROSS_COMPILE)as						\
	LD=$(TARGETLD)							\
	NM=$(TARGETNM)							\
	STRIP=$(TARGETSTRIP)						\
	OBJDUMP=$(TARGETOBJDUMP)					\
	OBJCOPY=$(TARGETOBJCOPY)					\
	CFLAGS="$(TARGET_CFLAGS)"					\
	CXXFLAGS="$(TARGET_CFLAGS)"					\
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)"	\
	CPPFLAGS="-I$(SYSROOT)/usr/include"				\
	PKG_CONFIG=$(PKGCONFIG_BIN)					\
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH)				\
	$(CONFIG_SHELL) $($(1)_SRC_DIR)/configure			\
	--build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET)		\
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR)		\
	--prefix=/usr $($(1)_CONFIGURE_OPTS)
	@touch $($(1)_BUILD_DIR)/.configured
	$(call EMBTK_KILL_LT_RPATH,"$($(1)_BUILD_DIR)")
endef

#
# A macro which downloads a package.
# Usage:
# $(call EMBTK_DOWNLOAD_PKG,PACKAGE)
#
define EMBTK_DOWNLOAD_PKG_PATCHES
@if [ "x$(CONFIG_EMBTK_$(1)_NEED_PATCH)" == "xy" ]; then		\
	test -e $(DOWNLOAD_DIR)/$($(1)_NAME)-$($(1)_VERSION).patch ||	\
	$(call EMBTK_WGET,						\
		$($(1)_NAME)-$($(1)_VERSION).patch,			\
		$($(1)_PATCH_SITE),					\
		$($(1)_NAME)-$($(1)_VERSION)-*.patch);			\
fi
endef

define EMBTK_DOWNLOAD_PKG_FROM_MIRROR
if [ "x$($(1)_SITE_MIRROR$(2))" == "x" ]; then 				\
	false;								\
else									\
	$(call EMBTK_WGET,						\
		$($(1)_PACKAGE),					\
		$($(1)_SITE_MIRROR$(2)),				\
		$($(1)_PACKAGE)); 					\
fi
endef
define EMBTK_DOWNLOAD_PKG
	$(call EMBTK_GENERIC_MSG,"Download $($(1)_PACKAGE) if necessary...")
	@test -e $(DOWNLOAD_DIR)/$($(1)_PACKAGE) ||			\
	$(call EMBTK_WGET,						\
		$($(1)_PACKAGE),					\
		$($(1)_SITE),						\
		$($(1)_PACKAGE))||					\
	$(call EMBTK_DOWNLOAD_PKG_FROM_MIRROR,$(1),1) ||		\
	$(call EMBTK_DOWNLOAD_PKG_FROM_MIRROR,$(1),2) ||		\
	$(call EMBTK_DOWNLOAD_PKG_FROM_MIRROR,$(1),3) || exit 1
	$(call EMBTK_DOWNLOAD_PKG_PATCHES,$(1))
endef
