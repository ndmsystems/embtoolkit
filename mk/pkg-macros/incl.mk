################################################################################
# Embtoolkit
# Copyright(C) 2014 Abdoulaye Walsimou GAYE.
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
# \file         include.mk
# \brief	include.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2014
################################################################################

#
# Macros to include a package in the build system
#
define embtk_include_pkg
	$(eval $(call __embtk_include_pkg,$(1)))
endef
define __embtk_include_pkg
	# Is it necessary to include .mk file?
	ifeq (x$(__embtk_pkg_inc_mkinclude),xy)
		include $(dir $(lastword $(MAKEFILE_LIST)))$(pkgv)/$(pkgv).mk
	endif
	ifeq (x$(CONFIG_EMBTK_HAVE_$(PKGV)),xy)
		ROOTFS_COMPONENTS-y		+= $(pkgv)_install
	else ifeq (x$(__embtk_pkg_inc_curinstalled),xy)
		ROOTFS_COMPONENTS-		+= $(pkgv)_install
	endif
endef

define embtk_include_hostpkg
	$(eval $(call __embtk_include_hostpkg,$(1)))
endef
define __embtk_include_hostpkg
	# Is it necessary to include .mk file?
	ifeq (x$(__embtk_pkg_inc_hostmkinclude),xy)
		include $(dir $(lastword $(MAKEFILE_LIST)))$(pkgv)/$(pkgv).mk
	endif
	ifeq (x$(CONFIG_EMBTK_HOST_HAVE_$(PKGV)),xy)
		HOSTTOOLS_COMPONENTS-y		+= $(pkgv)_install
	else ifeq (x$(__embtk_pkg_inc_curinstalled),xy)
		HOSTTOOLS_COMPONENTS-		+= $(pkgv)_install
	endif
endef

__embtk_pkg_inc_currinstalled	= $(if $(wildcard $(__embtk_pkg_dotinstalled_f)),y)
__embtk_pkg_inc_mkinclude	= $(if $(CONFIG_EMBTK_HAVE_$(PKGV))$(__embtk_pkg_currinstalled),y)
__embtk_pkg_inc_hostmkinclude	= $(if $(CONFIG_EMBTK_HOST_HAVE_$(PKGV))$(__embtk_pkg_currinstalled),y)
