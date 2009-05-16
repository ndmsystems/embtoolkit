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
