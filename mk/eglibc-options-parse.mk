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

EGLIBC_OPTIONS_PARSE:
	@echo "####################################### EmbToolkit ######################################"
	@echo "# Parsing eglibc options ...                                                            #"
	@echo "#########################################################################################"
	@echo "Does eglibc will support OPTION_EGLIBC_BACKTRACE?"
ifeq ($(CONFIG_OPTION_EGLIBC_BACKTRACE),)
	@echo "OPTION_EGLIBC_BACKTRACE = n" >> $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_BACKTRACE = n" >> $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_BACKTRACE = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_BACKTRACE = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_BSD?"
ifeq ($(CONFIG_OPTION_EGLIBC_BSD),)
	@echo "OPTION_EGLIBC_BSD = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_BSD = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_BSD = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_BSD = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_CXX_TESTS?"
ifeq ($(CONFIG_OPTION_EGLIBC_CXX_TESTS),)
	@echo "OPTION_EGLIBC_CXX_TESTS = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_CXX_TESTS = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_CXX_TESTS = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_CXX_TESTS = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_LIBM?"
ifeq ($(CONFIG_OPTION_EGLIBC_LIBM),)
	@echo "OPTION_EGLIBC_LIBM = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_LIBM = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_LIBM = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_LIBM = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_CHARSETS?"
ifeq ($(CONFIG_OPTION_EGLIBC_CHARSETS),)
	@echo "OPTION_EGLIBC_CHARSETS = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_CHARSETS = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_CHARSETS = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_CHARSETS = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_DB_ALIASES?"
ifeq ($(CONFIG_OPTION_EGLIBC_DB_ALIASES),)
	@echo "OPTION_EGLIBC_DB_ALIASES = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_DB_ALIASES = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_DB_ALIASES = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_DB_ALIASES = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_ENVZ?"
ifeq ($(CONFIG_OPTION_EGLIBC_ENVZ),)
	@echo "OPTION_EGLIBC_ENVZ = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_ENVZ = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_ENVZ = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_ENVZ = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_FCVT?"
ifeq ($(CONFIG_OPTION_EGLIBC_FCVT),)
	@echo "OPTION_EGLIBC_FCVT = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_FCVT = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_FCVT = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_FCVT = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_FMTMSG?"
ifeq ($(CONFIG_OPTION_EGLIBC_FMTMSG),)
	@echo "OPTION_EGLIBC_FMTMSG = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_FMTMSG = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_FMTMSG = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_FSTAB?"
ifeq ($(CONFIG_OPTION_EGLIBC_FSTAB),)
	@echo "OPTION_EGLIBC_FSTAB = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_FSTAB = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_FSTAB = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_FSTAB = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_FTRAVERSE?"
ifeq ($(CONFIG_OPTION_EGLIBC_FTRAVERSE),)
	@echo "OPTION_EGLIBC_FTRAVERSE = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_FTRAVERSE = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_FTRAVERSE = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_FTRAVERSE = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_INET?"
ifeq ($(CONFIG_OPTION_EGLIBC_INET),)
	@echo "OPTION_EGLIBC_INET = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_INET = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_INET = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_INET = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_ADVANCED_INET6?"
ifeq ($(CONFIG_OPTION_EGLIBC_ADVANCED_INET6),)
	@echo "OPTION_EGLIBC_ADVANCED_INET6 = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_ADVANCED_INET6 = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_ADVANCED_INET6 = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_ADVANCED_INET6 = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_SUNRPC?"
ifeq ($(CONFIG_OPTION_EGLIBC_SUNRPC),)
	@echo "OPTION_EGLIBC_SUNRPC = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_SUNRPC = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_SUNRPC = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_SUNRPC = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_NIS?"
ifeq ($(CONFIG_OPTION_EGLIBC_NIS),)
	@echo "OPTION_EGLIBC_NIS = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_NIS = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_NIS = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_NIS = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_RCMD?"
ifeq ($(CONFIG_OPTION_EGLIBC_RCMD),)
	@echo "OPTION_EGLIBC_RCMD = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_RCMD = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_RCMD = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_RCMD = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_LOCALES?"
ifeq ($(CONFIG_OPTION_EGLIBC_LOCALES),)
	@echo "OPTION_EGLIBC_LOCALES = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_LOCALES = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_LOCALES = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_LOCALES = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_NSSWITCH?"
ifeq ($(CONFIG_OPTION_EGLIBC_NSSWITCH),)
	@echo "OPTION_EGLIBC_NSSWITCH = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_NSSWITCH = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_NSSWITCH = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_NSSWITCH = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_SPAWN?"
ifeq ($(CONFIG_OPTION_EGLIBC_SPAWN),)
	@echo "OPTION_EGLIBC_SPAWN = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_SPAWN = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_SPAWN = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_SPAWN = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_STREAMS?"
ifeq ($(CONFIG_OPTION_EGLIBC_STREAMS),)
	@echo "OPTION_EGLIBC_STREAMS = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_STREAMS = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_STREAMS = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_STREAMS = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_UTMP?"
ifeq ($(CONFIG_OPTION_EGLIBC_UTMP),)
	@echo "OPTION_EGLIBC_UTMP = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_UTMP = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_UTMP = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_UTMP = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_GETLOGIN?"
ifeq ($(CONFIG_OPTION_EGLIBC_GETLOGIN),)
	@echo "OPTION_EGLIBC_GETLOGIN = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_GETLOGIN = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_GETLOGIN = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_GETLOGIN = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_UTMPX?"
ifeq ($(CONFIG_OPTION_EGLIBC_UTMPX),)
	@echo "OPTION_EGLIBC_UTMPX = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_UTMPX = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_UTMPX = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_UTMPX = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_WORDEXP?"
ifeq ($(CONFIG_OPTION_EGLIBC_WORDEXP),)
	@echo "OPTION_EGLIBC_WORDEXP = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_WORDEXP = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_WORDEXP = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_WORDEXP = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_POSIX_C_LANG_WIDE_CHAR?"
ifeq ($(CONFIG_OPTION_POSIX_C_LANG_WIDE_CHAR),)
	@echo "OPTION_POSIX_C_LANG_WIDE_CHAR = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_POSIX_C_LANG_WIDE_CHAR = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_POSIX_C_LANG_WIDE_CHAR = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_POSIX_C_LANG_WIDE_CHAR = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_LOCALE_CODE?"
ifeq ($(CONFIG_OPTION_EGLIBC_LOCALE_CODE),)
	@echo "OPTION_EGLIBC_LOCALE_CODE = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_LOCALE_CODE = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_LOCALE_CODE = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_LOCALE_CODE = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_EGLIBC_CATGETS?"
ifeq ($(CONFIG_OPTION_EGLIBC_CATGETS),)
	@echo "OPTION_EGLIBC_CATGETS = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_CATGETS = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_EGLIBC_CATGETS = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_EGLIBC_CATGETS = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_POSIX_WIDE_CHAR_DEVICE_IO?"
ifeq ($(CONFIG_OPTION_POSIX_WIDE_CHAR_DEVICE_IO),)
	@echo "OPTION_POSIX_WIDE_CHAR_DEVICE_IO = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_POSIX_WIDE_CHAR_DEVICE_IO = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_POSIX_WIDE_CHAR_DEVICE_IO = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_POSIX_WIDE_CHAR_DEVICE_IO = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_POSIX_REGEXP?"
ifeq ($(CONFIG_OPTION_POSIX_REGEXP),)
	@echo "OPTION_POSIX_REGEXP = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_POSIX_REGEXP = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_POSIX_REGEXP = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_POSIX_REGEXP = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif
	@echo "Does eglibc will support OPTION_POSIX_REGEXP_GLIBC?"
ifeq ($(CONFIG_OPTION_POSIX_REGEXP_GLIBC),)
	@echo "OPTION_POSIX_REGEXP_GLIBC = n" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_POSIX_REGEXP_GLIBC = n" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
else
	@echo "OPTION_POSIX_REGEXP_GLIBC = y" >>  $(EGLIBC_HEADERS_BUILD_DIR)/option-groups.config
	@echo "OPTION_POSIX_REGEXP_GLIBC = y" >>  $(EGLIBC_BUILD_DIR)/option-groups.config
endif

