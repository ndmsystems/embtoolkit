################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
# \file         headers.mk
# \brief	linux headers installation
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################


ifneq ($(CONFIG_EMBTK_LINUX_VERSION_GIT),)
  CONFIG_EMBTK_LINUX_HEADERS_VERSION_GIT = $(CONFIG_EMBTK_LINUX_VERSION_GIT)
endif

ifneq ($(CONFIG_EMBTK_LINUX_GIT_REVISION),)
  CONFIG_EMBTK_LINUX_HEADERS_GIT_REVISION = $(CONFIG_EMBTK_LINUX_GIT_REVISION)
endif

ifneq ($(CONFIG_EMBTK_LINUX_GIT_BRANCH),)
  CONFIG_EMBTK_LINUX_HEADERS_GIT_BRANCH = $(CONFIG_EMBTK_LINUX_GIT_BRANCH)
endif

ifneq ($(CONFIG_EMBTK_LINUX_GIT_SITE),)
  CONFIG_EMBTK_LINUX_HEADERS_GIT_SITE = $(CONFIG_EMBTK_LINUX_GIT_SITE)
endif

LINUX_HEADERS_NAME	:= linux
LINUX_HEADERS_VERSION	:= $(LINUX_VERSION)
LINUX_HEADERS_GIT_SITE	:= $(LINUX_GIT_SITE)
LINUX_HEADERS_SITE	:= $(LINUX_SITE)
LINUX_HEADERS_PACKAGE	:= $(LINUX_PACKAGE)
LINUX_HEADERS_SRC_DIR	:= $(LINUX_SRC_DIR)
LINUX_HEADERS_BUILD_DIR	:= $(LINUX_BUILD_DIR)
LINUX_HEADERS_KEEP_SRC_DIR  := $(LINUX_KEEP_SRC_DIR)
LINUX_HEADERS_KCONFIGS_NAME := LINUX

LINUX_HEADERS_MAKE_OPTS := $(LINUX_MAKE_OPTS)
LINUX_HEADERS_MAKE_OPTS += CROSS_COMPILE=""
LINUX_HEADERS_MAKE_OPTS += INSTALL_HDR_PATH=$(embtk_sysroot)/usr

#
# linux headers install
#
ifeq ($(embtk_buildhost_os),macos)
define embtk_beforeinstall_linux_headers
	cp $(EMBTK_ROOT)/scripts/unifdef.c					\
		$(LINUX_HEADERS_SRC_DIR)/scripts/unifdef.c
endef
endif

define embtk_install_linux_headers
	$(MAKE) -C $(LINUX_HEADERS_BUILD_DIR) $(LINUX_HEADERS_MAKE_OPTS)	\
		headers_install
endef

define embtk_cleanup_linux_headers
	[ -d $(LINUX_BUILD_DIR) ] && $(call __embtk_unsetinstalled_pkg,linux_headers) ||:
endef
