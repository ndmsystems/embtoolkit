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
	$(eval __embtk_inckconfig	:= $(or $(2),$(PKGV)))
	$(eval __embtk_incmk		:= $(embtk_pkgincdir)/$(pkgv)/$(pkgv).mk)
	$(eval __embtk_incinstalled-y	:= $(if $(wildcard $(__embtk_pkg_dotinstalled_f)),y))
	$(eval __embtk_incenabled-y	:= $(CONFIG_EMBTK_HAVE_$(__embtk_inckconfig)))
	$(eval __embtk_incmk-y		:= $(if $(__embtk_incenabled-y)$(__embtk_incinstalled-y),y))
	# Is it necessary to include the .mk file?
	$(eval __embtk_incmk-y		:= $(if $(findstring $(__embtk_incmk),$(MAKEFILE_LIST)),,$(__embtk_incmk-y)))
	ifeq (x$(__embtk_incmk-y),xy)
		include $(__embtk_incmk)
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
	$(eval __embtk_inckconfig	:= $(or $(2),$(PKGV)))
	# Case where foo and foo_host are in the same .mk file
	$(eval __embtk_incmk0		:= $(embtk_pkgincdir)/$(pkgv)/$(pkgv).mk)
	$(eval __embtk_incmk1		:= $(embtk_pkgincdir)/$(patsubst %_host,%,$(pkgv))/$(patsubst %_host,%,$(pkgv)).mk)
	$(eval __embtk_incmk		:= $(or $(wildcard $(__embtk_incmk0)),$(wildcard $(__embtk_incmk1)),$(wildcard $(__embtk_incmk0))))
	$(eval __embtk_incinstalled-y	:= $(if $(wildcard $(__embtk_pkg_dotinstalled_f)),y))
	$(eval __embtk_incenabled-y	:= $(CONFIG_EMBTK_HOST_HAVE_$(patsubst %_HOST,%,$(__embtk_inckconfig))))
	$(eval __embtk_incmk-y		:= $(if $(__embtk_incenabled-y)$(__embtk_incinstalled-y),y))
	# Is it necessary to include the .mk file?
	$(eval __embtk_incmk-y		:= $(if $(findstring $(__embtk_incmk),$(MAKEFILE_LIST)),,$(__embtk_incmk-y)))
	ifeq (x$(__embtk_incmk-y),xy)
		include $(__embtk_incmk)
	endif
	ifeq (x$(__embtk_incenabled-y),xy)
		HOSTTOOLS_COMPONENTS-y		+= $(pkgv)_install
	else ifeq (x$(__embtk_incinstalled-y),xy)
		HOSTTOOLS_COMPONENTS-		+= $(pkgv)_install
	endif
endef
