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
# \file         libevent.mk
# \brief	libevent.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

LIBEVENT_NAME := libevent
LIBEVENT_VERSION := $(call EMBTK_GET_PKG_VERSION,LIBEVENT)
LIBEVENT_SITE := http://www.monkey.org/~provos
LIBEVENT_SITE_MIRROR3 := ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
LIBEVENT_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/libevent/$(LIBEVENT_VERSION)
LIBEVENT_PACKAGE := libevent-$(LIBEVENT_VERSION).tar.gz
LIBEVENT_SRC_DIR := $(PACKAGES_BUILD)/libevent-$(LIBEVENT_VERSION)
LIBEVENT_BUILD_DIR := $(PACKAGES_BUILD)/libevent-$(LIBEVENT_VERSION)

LIBEVENT_BINS = event_rpcgen.py
LIBEVENT_SBINS =
LIBEVENT_INCLUDES = evdns.h event-config.h event.h evhttp.h evrpc.h evutil.h
LIBEVENT_LIBS = libevent*
LIBEVENT_PKGCONFIGS =

LIBEVENT_DEPS :=

libevent_install:
	$(call EMBTK_INSTALL_PKG,LIBEVENT)

download_libevent:
	$(call EMBTK_DOWNLOAD_PKG,LIBEVENT)

libevent_clean:
	$(call EMBTK_CLEANUP_PKG,LIBEVENT)
