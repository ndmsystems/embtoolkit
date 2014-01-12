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
#	$(1): pkgname => pkgname/pkgname.mk should exist (required)
#	$(2): kconfig: package specific kconfig symbol name used in .kconfig
#	      This is parameter is optional.
define embtk_include_pkg
	$(eval $(call __embtk_include_pkg,$(1),$(2)))
endef
define __embtk_include_pkg
	# Is it necessary to include .mk file?
	$(eval __embtk_inckconfig	:= $(or $(2),$(PKGV)))
	$(eval __embtk_incdir		:= $(dir $(lastword $(MAKEFILE_LIST))))
	$(eval __embtk_incinstalled-y	:= $(if $(wildcard $(__embtk_pkg_dotinstalled_f)),y))
	$(eval __embtk_incenabled-y	:= $(CONFIG_EMBTK_HAVE_$(__embtk_inckconfig)))
	$(eval __embtk_incmk-y		:= $(if $(__embtk_incenabled-y)$(__embtk_incinstalled-y),y))
	ifeq (x$(__embtk_incmk-y),xy)
		include $(__embtk_incdir)$(pkgv)/$(pkgv).mk
	endif
	ifeq (x$(__embtk_incenabled-y),xy)
		ROOTFS_COMPONENTS-y		+= $(pkgv)_install
	else ifeq (x$(__embtk_incinstalled-y),xy)
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
