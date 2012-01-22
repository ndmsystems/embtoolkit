#########################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \file         makedevs.mk
# \brief	makedevs.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
#########################################################################################

MAKEDEVS_NAME		:= makedevs
MAKEDEVS_BUILD_DIR	:= $(TOOLS_BUILD)/makedevs-build
MAKEDEVS_SRC		:= $(EMBTK_ROOT)/src/makedevs

MAKEDEVS_DIR		:= $(HOSTTOOLS)/usr/bin
MAKEDEVS_BIN		:= $(MAKEDEVS_DIR)/makedevs

makedevs_install:
	[ -e $(MAKEDEVS_BUILD_DIR)/.installed ] || 				\
				$(MAKE) $(MAKEDEVS_BUILD_DIR)/.installed

$(MAKEDEVS_BUILD_DIR)/.installed:
	$(call embtk_pinfo,"Installing makedevs...")
	$(Q)mkdir -p $(MAKEDEVS_BUILD_DIR)
	$(Q)mkdir -p $(HOSTTOOLS)/usr
	$(Q)mkdir -p $(HOSTTOOLS)/usr/bin
	$(hostcc_cached) -o $(MAKEDEVS_BIN) $(wildcard $(MAKEDEVS_SRC)/*.c)
	$(Q)touch $@

download_makedevs:
	$(call embtk_pinfo,"makedevs is in embtk source, download not needed...")
