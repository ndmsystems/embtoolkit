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

MAKEDEVS_DIR := $(HOSTTOOLS)/usr/local/makedevs

makedevs_install: $(MAKEDEVS_DIR)/.installed

$(MAKEDEVS_DIR)/.installed:
	$(call EMBTK_GENERIC_MESSAGE,"Installing makedevs...")
	@mkdir -p $(MAKEDEVS_DIR)
	$(subst ",,$(strip $(HOSTCC_CACHED))) -o $(MAKEDEVS_DIR)/makedevs $(EMBTK_ROOT)/src/makedevs/makedevs.c
	@touch $@
