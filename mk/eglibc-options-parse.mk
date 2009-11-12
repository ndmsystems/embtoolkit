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
# \file         eglibc-options-parse.mk
# \brief	eglibc-options-parse.mk. Here we define a target which parses
# \brief	eglibc options from .config.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
################################################################################

ifeq ($(CONFIG_EMBTK_EGLIBC_VERSION_2_11),y)
include $(EMBTK_ROOT)/mk/eglibc-2.11-options.mk
endif

ifeq ($(CONFIG_EMBTK_EGLIBC_VERSION_2_10),y)
include $(EMBTK_ROOT)/mk/eglibc-2.10-options.mk
endif

ifeq ($(CONFIG_EMBTK_EGLIBC_VERSION_2_9),y)
include $(EMBTK_ROOT)/mk/eglibc-2.9-options.mk
endif

ifeq ($(CONFIG_EMBTK_EGLIBC_VERSION_TRUNK),y)
include $(EMBTK_ROOT)/mk/eglibc-trunk-options.mk
endif

EGLIBC_OPTIONS_PARSE:
	@echo "####################################### EmbToolkit #############\
	#########################"
	@echo "# Parsing eglibc options ...                                    \
	                        #"
	@echo "################################################################\
	#########################"
	@for i in $(EGLIBC_OPTIONS); \
	do \
	echo "Does eglibc will support $$i?"; \
	if grep -q CONFIG_$$i=y $(EMBTK_ROOT)/.config ; \
	then \
	echo "You said yes"; \
	echo "$$i = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config; \
	echo "$$i = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config; \
	else \
	echo "You said no"; \
	echo "$$i = n" >> $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config; \
	echo "$$i = n" >> $(EGLIBC_BUILD_DIR)/option-groups.config; \
	fi \
	done

