#########################################################################################
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
#########################################################################################
#
# \file         macros.mk
# \brief	macros.mk of Embtoolkit
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################

#Decompress message
#unsage $(call DECOMPRESS_MESSAGE,$(NAME_PACKAGE))
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
	@echo "####################################### EmbToolkit ######################################"
	@echo "$(1)"
	@echo "#########################################################################################"
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
	$(Q)LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib32 -name *.la`; \
	for i in $$LIBTOOLS_LA_FILES; \
	do \
	sed -e "s;libdir='\/usr\/lib32';libdir='$(SYSROOT)\/usr\/lib32';" $$i \
	> $$i.new; \
	mv $$i.new $$i; \
	done
else
	$(Q)LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib -name *.la`; \
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
	$(Q)LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib32 -name *.la`; \
	for i in $$LIBTOOLS_LA_FILES; \
	do \
	sed -e "s;libdir='$(SYSROOT)\/usr\/lib32';libdir='\/usr\/lib32';" $$i \
	> $$i.new; \
	mv $$i.new $$i; \
	done
else
	$(Q)LIBTOOLS_LA_FILES=`find $(SYSROOT)/usr/lib -name *.la`; \
	for i in $$LIBTOOLS_LA_FILES; \
	do \
	sed -e "s;libdir='$(SYSROOT)\/usr\/lib';libdir='\/usr\/lib';" < $$i \
	> $$i.new; \
	mv $$i.new $$i; \
	done
endif

