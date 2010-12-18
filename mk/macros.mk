################################################################################
# Embtoolkit
# Copyright(C) 2009 Abdoulaye Walsimou GAYE. All rights reserved.
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

#Decompress message
#usage $(call DECOMPRESS_MESSAGE,$(NAME_PACKAGE))
define DECOMPRESS_MESSAGE
	@echo "########################### EmbToolkit ###########################"
	@echo "Decompressing $(1)"
	@echo "##################################################################"
endef

#Configure message
#unsage $(call CONFIGURE_MESSAGE,$(NAME_PACKAGE))
define CONFIGURE_MESSAGE
	@echo "########################### EmbToolkit ###########################"
	@echo "Configuring $(1)"
	@echo "##################################################################"
endef

#Build message
#unsage $(call BUILD_MESSAGE,$(NAME_PACKAGE))
define BUILD_MESSAGE
	@echo "########################### EmbToolkit ###########################"
	@echo "Building $(1)"
	@echo "##################################################################"
endef

#Install message
#unsage $(call INSTALL_MESSAGE,$(NAME_PACKAGE))
define INSTALL_MESSAGE
	@echo "########################### EmbToolkit ###########################"
	@echo "Installing $(1)"
	@echo "##################################################################"
endef

#Generic message
#unsage $(call EMBTK_GENERIC_MESSAGE,$(GENERIC_MESSAGE))
define EMBTK_GENERIC_MESSAGE
	$(call ECHO_BLUE,"################################################################################")
	$(call ECHO_BLUE,"# EmbToolkit # $(1)")
	$(call ECHO_BLUE,"################################################################################")
endef

#Successful build of EmbToolkit message
successful_build:
	@echo "####################################### EmbToolkit ######################################"
	@echo " --------------------- "
	@echo "| Toolchain build log |"
	@echo " --------------------- "
	@echo "You successfully build your toolchain for $(GNU_TARGET)"
	@echo "Tools built (GCC compiler, Binutils, etc.) are located in:"
	@echo "    $(TOOLS)/bin"
	@echo
	@echo " ---------------------------- "
	@echo "| Root file system build log |"
	@echo " ---------------------------- "
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
	@echo "You also successfully build a root filesystem located in the root directory"
	@echo "of EmbToolkit."
else
	@echo "Build of root filesystem not selected."
endif
	@echo
	@echo " ---------------------------- "
	@echo "| Embedded systems Toolkit   |"
	@echo " ---------------------------- "
	@echo "Hope that EmbToolkit will be useful for your project !!!"
	@echo "Please report any bugs/suggestion at:"
	@echo "   http://www.embtoolkit.org/issues/projects/show/embtoolkit"
	@echo "You can also visit the wiki at:"
	@echo "   http://www.embtoolkit.org"
	@echo
	@echo "#########################################################################################"

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
