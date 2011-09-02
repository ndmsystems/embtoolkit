################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
################################################################################
#
# \file         macros.mk
# \brief	macros.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

# Embtoolkit colors
__embtk_color_red	= "\E[1;31m"
__embtk_color_green	= "\E[1;32m"
__embtk_color_yellow	= "\E[1;33m"
__embtk_color_blue	= "\E[1;34m"
__embtk_no_color	= "\E[0m"

# echo colored text
#usage $(call embtk_echo_red,$(TEXT))
define embtk_echo_red
	echo -e $(__embtk_color_red)$(1)$(__embtk_no_color)
endef
#usage $(call embtk_echo_green,$(TEXT))
define embtk_echo_green
	echo -e $(__embtk_color_green)$(1)$(__embtk_no_color)
endef
#usage $(call embtk_echo_yellow,$(TEXT))
define embtk_echo_yellow
	echo -e $(__embtk_color_yellow)$(1)$(__embtk_no_color)
endef
#usage $(call embtk_echo_blue,$(TEXT))
define embtk_echo_blue
	echo -e $(__embtk_color_blue)$(1)$(__embtk_no_color)
endef

#
# __embtk_mk_strcmp:
# A macro for two strings comparison. It returns y if the strings are identical
# and nothing if not.
# Note: This macro strips passed parameters
# Usage:
# $(call __embtk_mk_strcmp,str1,str2)
#
__embtk_mk_strcmp=$(shell [ $(strip $(1)) = $(strip $(2)) ] && echo y)

#Decompress message
#usage $(call EMBTK_DECOMPRESS_MSG,$(NAME_PACKAGE))
define EMBTK_DECOMPRESS_MSG
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # Decompressing $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef

#Configure message
#usage $(call EMBTK_CONFIGURE_MSG,$(NAME_PACKAGE))
define EMBTK_CONFIGURE_MSG
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # Configuring $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef

#Build message
#usage $(call EMBTK_BUILD_MSG,$(NAME_PACKAGE))
define EMBTK_BUILD_MSG
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # Building $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef

#Install message
#usage $(call EMBTK_INSTALL_MSG,$(NAME_PACKAGE))
define EMBTK_INSTALL_MSG
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # Installing $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef

# Print warning message
define embtk_pwarning
	$(call embtk_echo_yellow,"################################################################################")
	$(call embtk_echo_yellow,"# EmbToolkit # WARNING: $(1)")
	$(call embtk_echo_yellow,"################################################################################")
endef

# Print error message
define embtk_perror
	$(call embtk_echo_red,"################################################################################")
	$(call embtk_echo_red,"# EmbToolkit # ERROR: $(1)")
	$(call embtk_echo_red,"################################################################################")
endef

# Print info message
define embtk_pinfo
	$(call embtk_echo_blue,"################################################################################")
	$(call embtk_echo_blue,"# EmbToolkit # $(1)")
	$(call embtk_echo_blue,"################################################################################")
endef

# Successful build of EmbToolkit message
successful_build:
	$(call embtk_echo_blue," --------------------- ")
	$(call embtk_echo_blue,"| Toolchain build log |")
	$(call embtk_echo_blue," --------------------- ")
	$(call embtk_echo_blue,"You successfully build your toolchain for $(GNU_TARGET)")
	$(call embtk_echo_blue,"Tools built (GCC compiler, Binutils, etc.) are located in:")
	$(call embtk_echo_blue,"    $(TOOLS)/bin")
	@echo
	$(call embtk_echo_blue," ---------------------------- ")
	$(call embtk_echo_blue,"| Root file system build log |")
	$(call embtk_echo_blue," ---------------------------- ")
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
	$(call embtk_echo_blue,"You also successfully build root filesystem(s) located in the")
	$(call embtk_echo_blue,"'generated' sub-directory of EmbToolkit.")
else
	$(call embtk_echo_green,"Build of root filesystem not selected.")
endif
	@echo
	$(call embtk_echo_blue," ---------------------------- ")
	$(call embtk_echo_blue,"| Embedded systems Toolkit   |")
	$(call embtk_echo_blue," ---------------------------- ")
	$(call embtk_echo_blue,"Hope that EmbToolkit will be useful for your project !!!")
	$(call embtk_echo_blue,"Please report any bugs/suggestion at:")
	$(call embtk_echo_blue,"   http://www.embtoolkit.org/issues/projects/show/embtoolkit")
	$(call embtk_echo_blue,"You can also visit the wiki at:")
	$(call embtk_echo_blue,"   http://www.embtoolkit.org")
	@echo
	$(call embtk_echo_blue,"################################################################################")

# Packages management macros
include $(EMBTK_ROOT)/mk/macros.packages.mk
