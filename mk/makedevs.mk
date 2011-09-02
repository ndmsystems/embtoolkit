#########################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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

MAKEDEVS_SRC	:= $(EMBTK_ROOT)/src/makedevs/makedevs.c
MAKEDEVS_DIR	:= $(HOSTTOOLS)/usr/bin
MAKEDEVS_BIN	:= $(MAKEDEVS_DIR)/makedevs

makedevs_install: $(MAKEDEVS_DIR)/.installed
	$(call embtk_pinfo,"Successfully installed makedevs")

$(MAKEDEVS_DIR)/.installed:
	$(call embtk_pinfo,"Installing makedevs...")
	$(Q)mkdir -p $(MAKEDEVS_DIR)/usr
	$(Q)mkdir -p $(MAKEDEVS_DIR)/usr/bin
	$(hostcc_cached) -o $(MAKEDEVS_BIN) $(MAKEDEVS_SRC)
	$(Q)touch $@

download_makedevs:
	$(call embtk_pinfo,"makedevs is in embtk source, download not needed...")
