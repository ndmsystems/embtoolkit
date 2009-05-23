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
# \file         eglibc-options-parse.mk
# \brief	eglibc-options-parse.mk. Here we define a macros which parses eglibc
# \brief	options from .config.
# \author       GAYE Abdoulaye Walsimou, <walsimou@walsimou.com>
# \date         May 2009
#########################################################################################

#Parse EGLIBC options
#unsage $(call EGLIBC_OPTIONS_PARSE,$(EGLIBC_OPTIONS_DOTCONFIG))
define EGLIBC_OPTIONS_PARSE
	@echo "####################################### EmbToolkit ######################################"
	@echo "# Parsing eglibc options ...
	@echo "#########################################################################################"
	@echo "Does eglibc will support OPTION_EGLIBC_BACKTRACE?"
ifeq ($(CONFIG_OPTION_EGLIBC_BACKTRACE),)
	@echo "OPTION_EGLIBC_BACKTRACE = n" >> $(1)
else
	@echo "OPTION_EGLIBC_BACKTRACE = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_BSD?"
ifeq ($(CONFIG_OPTION_EGLIBC_BSD),)
	@echo "OPTION_EGLIBC_BSD = n" >> $(1)
else
	@echo "OPTION_EGLIBC_BSD = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_CXX_TESTS?"
ifeq ($(CONFIG_OPTION_EGLIBC_CXX_TESTS),)
	@echo "OPTION_EGLIBC_CXX_TESTS = n" >> $(1)
else
	@echo "OPTION_EGLIBC_CXX_TESTS = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_LIBM?"
ifeq ($(CONFIG_OPTION_EGLIBC_LIBM),)
	@echo "OPTION_EGLIBC_LIBM = n" >> $(1)
else
	@echo "OPTION_EGLIBC_LIBM = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_CHARSETS?"
ifeq ($(CONFIG_OPTION_EGLIBC_CHARSETS),)
	@echo "OPTION_EGLIBC_CHARSETS = n" >> $(1)
else
	@echo "OPTION_EGLIBC_CHARSETS = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_DB_ALIASES?"
ifeq ($(CONFIG_OPTION_EGLIBC_DB_ALIASES),)
	@echo "OPTION_EGLIBC_DB_ALIASES = n" >> $(1)
else
	@echo "OPTION_EGLIBC_DB_ALIASES = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_ENVZ?"
ifeq ($(CONFIG_OPTION_EGLIBC_ENVZ),)
	@echo "OPTION_EGLIBC_ENVZ = n" >> $(1)
else
	@echo "OPTION_EGLIBC_ENVZ = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_FCVT?"
ifeq ($(CONFIG_OPTION_EGLIBC_FCVT),)
	@echo "OPTION_EGLIBC_FCVT = n" >> $(1)
else
	@echo "OPTION_EGLIBC_FCVT = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_FMTMSG?"
ifeq ($(CONFIG_OPTION_EGLIBC_FMTMSG),)
	@echo "OPTION_EGLIBC_FMTMSG = n" >> $(1)
else
	@echo "OPTION_EGLIBC_FMTMSG = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_FSTAB?"
ifeq ($(CONFIG_OPTION_EGLIBC_FSTAB),)
	@echo "OPTION_EGLIBC_FSTAB = n" >> $(1)
else
	@echo "OPTION_EGLIBC_FSTAB = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_FTRAVERSE?"
ifeq ($(CONFIG_OPTION_EGLIBC_FTRAVERSE),)
	@echo "OPTION_EGLIBC_FTRAVERSE = n" >> $(1)
else
	@echo "OPTION_EGLIBC_FTRAVERSE = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_INET?"
ifeq ($(CONFIG_OPTION_EGLIBC_INET),)
	@echo "OPTION_EGLIBC_INET = n" >> $(1)
else
	@echo "OPTION_EGLIBC_INET = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_ADVANCED_INET6?"
ifeq ($(CONFIG_OPTION_EGLIBC_ADVANCED_INET6),)
	@echo "OPTION_EGLIBC_ADVANCED_INET6 = n" >> $(1)
else
	@echo "OPTION_EGLIBC_ADVANCED_INET6 = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_SUNRPC?"
ifeq ($(CONFIG_OPTION_EGLIBC_SUNRPC),)
	@echo "OPTION_EGLIBC_SUNRPC = n" >> $(1)
else
	@echo "OPTION_EGLIBC_SUNRPC = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_NIS?"
ifeq ($(CONFIG_OPTION_EGLIBC_NIS),)
	@echo "OPTION_EGLIBC_NIS = n" >> $(1)
else
	@echo "OPTION_EGLIBC_NIS = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_RCMD?"
ifeq ($(CONFIG_OPTION_EGLIBC_RCMD),)
	@echo "OPTION_EGLIBC_RCMD = n" >> $(1)
else
	@echo "OPTION_EGLIBC_RCMD = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_LOCALES?"
ifeq ($(CONFIG_OPTION_EGLIBC_LOCALES),)
	@echo "OPTION_EGLIBC_LOCALES = n" >> $(1)
else
	@echo "OPTION_EGLIBC_LOCALES = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_NSSWITCH?"
ifeq ($(CONFIG_OPTION_EGLIBC_NSSWITCH),)
	@echo "OPTION_EGLIBC_NSSWITCH = n" >> $(1)
else
	@echo "OPTION_EGLIBC_NSSWITCH = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_SPAWN?"
ifeq ($(CONFIG_OPTION_EGLIBC_SPAWN),)
	@echo "OPTION_EGLIBC_SPAWN = n" >> $(1)
else
	@echo "OPTION_EGLIBC_SPAWN = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_STREAMS?"
ifeq ($(CONFIG_OPTION_EGLIBC_STREAMS),)
	@echo "OPTION_EGLIBC_STREAMS = n" >> $(1)
else
	@echo "OPTION_EGLIBC_STREAMS = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_UTMP?"
ifeq ($(CONFIG_OPTION_EGLIBC_UTMP),)
	@echo "OPTION_EGLIBC_UTMP = n" >> $(1)
else
	@echo "OPTION_EGLIBC_UTMP = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_GETLOGIN?"
ifeq ($(CONFIG_OPTION_EGLIBC_GETLOGIN),)
	@echo "OPTION_EGLIBC_GETLOGIN = n" >> $(1)
else
	@echo "OPTION_EGLIBC_GETLOGIN = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_UTMPX?"
ifeq ($(CONFIG_OPTION_EGLIBC_UTMPX),)
	@echo "OPTION_EGLIBC_UTMPX = n" >> $(1)
else
	@echo "OPTION_EGLIBC_UTMPX = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_WORDEXP?"
ifeq ($(CONFIG_OPTION_EGLIBC_WORDEXP),)
	@echo "OPTION_EGLIBC_WORDEXP = n" >> $(1)
else
	@echo "OPTION_EGLIBC_WORDEXP = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_POSIX_C_LANG_WIDE_CHAR?"
ifeq ($(CONFIG_OPTION_POSIX_C_LANG_WIDE_CHAR),)
	@echo "OPTION_POSIX_C_LANG_WIDE_CHAR = n" >> $(1)
else
	@echo "OPTION_POSIX_C_LANG_WIDE_CHAR = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_LOCALE_CODE?"
ifeq ($(CONFIG_OPTION_EGLIBC_LOCALE_CODE),)
	@echo "OPTION_EGLIBC_LOCALE_CODE = n" >> $(1)
else
	@echo "OPTION_EGLIBC_LOCALE_CODE = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_EGLIBC_CATGETS?"
ifeq ($(CONFIG_OPTION_EGLIBC_CATGETS),)
	@echo "OPTION_EGLIBC_CATGETS = n" >> $(1)
else
	@echo "OPTION_EGLIBC_CATGETS = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_POSIX_WIDE_CHAR_DEVICE_IO?"
ifeq ($(CONFIG_OPTION_POSIX_WIDE_CHAR_DEVICE_IO),)
	@echo "OPTION_POSIX_WIDE_CHAR_DEVICE_IO = n" >> $(1)
else
	@echo "OPTION_POSIX_WIDE_CHAR_DEVICE_IO = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_POSIX_REGEXP?"
ifeq ($(CONFIG_OPTION_POSIX_REGEXP),)
	@echo "OPTION_POSIX_REGEXP = n" >> $(1)
else
	@echo "OPTION_POSIX_REGEXP = y" >> $(1)
endif
	@echo "Does eglibc will support OPTION_POSIX_REGEXP_GLIBC?"
ifeq ($(CONFIG_OPTION_POSIX_REGEXP_GLIBC),)
	@echo "OPTION_POSIX_REGEXP_GLIBC = n" >> $(1)
else
	@echo "OPTION_POSIX_REGEXP_GLIBC = y" >> $(1)
endif
endef
