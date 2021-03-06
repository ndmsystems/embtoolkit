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
#	      This parameter is optional.
define embtk_include_pkg
	$(eval $(call __embtk_include_pkg,$(1),$(2)))
endef
define __embtk_include_pkg
	$(eval __embtk_inc_pkgname	:= $(or $(2),$(PKGV)))
	$(eval __embtk_incmk		:= $(embtk_pkgincdir)/$(pkgv)/$(pkgv).mk)
	$(eval __embtk_incinstalled-y	:= $(if $(wildcard $(__embtk_pkg_dotinstalled_f)),y))
	$(eval __embtk_incenabled-y	:= $(CONFIG_EMBTK_HAVE_$(__embtk_inc_pkgname)))
	$(eval __embtk_incmk-y		:= $(if $(__embtk_incenabled-y)$(__embtk_incinstalled-y),y))
	# Is it necessary to include the .mk file?
	$(eval __embtk_incmk-y		:= $(if $(findstring $(__embtk_incmk),$(MAKEFILE_LIST)),,$(__embtk_incmk-y)))
	ifeq (x$(__embtk_incmk-y),xy)
		include $(__embtk_incmk)
	endif
	ifeq (x$(__embtk_incenabled-y),xy)
		ROOTFS_COMPONENTS-y		+= $(pkgv)_install
		# also include old package kconfig entries if any
		-include $(__embtk_pkg_dotkconfig_f)
	else ifeq (x$(__embtk_incinstalled-y),xy)
		ROOTFS_COMPONENTS-		+= $(pkgv)_install
	endif
	# Preset build system installed variable for this packages, if installed
	ifeq (x$(__embtk_incinstalled-y),xy)
		__embtk_$(pkgv)_installed = y
	else
		__embtk_$(pkgv)_installed =
	endif
	# preset some variables
	$(eval __embtk_$(pkgv)_category  := $(call __embtk_mk_uquote,$(or $(CONFIG_EMBTK_$(PKGV)_REFSPEC),$(CONFIG_EMBTK_$(PKGV)_CATEGORY))))
	$(eval __embtk_xpkg_category     := $(lastword $(subst /,$(embtk_space),$(embtk_pkgincdir))))
	__embtk_$(pkgv)_category         := $(or $(__embtk_$(pkgv)_category),$(__embtk_xpkg_category))
endef

define embtk_include_hostpkg
	$(eval $(call __embtk_include_hostpkg,$(1),$(2)))
endef
define __embtk_include_hostpkg
	$(eval __embtk_inc_pkgname	:= $(or $(2),$(PKGV)))
	# Case where foo and foo_host are in the same .mk file
	$(eval __embtk_incmk0		:= $(embtk_pkgincdir)/$(pkgv)/$(pkgv).mk)
	$(eval __embtk_incmk1		:= $(embtk_pkgincdir)/$(patsubst %_host,%,$(pkgv))/$(patsubst %_host,%,$(pkgv)).mk)
	$(eval __embtk_incmk		:= $(or $(wildcard $(__embtk_incmk0)),$(wildcard $(__embtk_incmk1)),$(wildcard $(__embtk_incmk0))))
	$(eval __embtk_incinstalled-y	:= $(if $(wildcard $(__embtk_pkg_dotinstalled_f)),y))
	$(eval __embtk_incenabled-y	:= $(CONFIG_EMBTK_HOST_HAVE_$(patsubst %_HOST,%,$(__embtk_inc_pkgname))))
	$(eval __embtk_incmk-y		:= $(if $(__embtk_incenabled-y)$(__embtk_incinstalled-y),y))
	# Is it necessary to include the .mk file?
	$(eval __embtk_incmk-y		:= $(if $(findstring $(__embtk_incmk),$(MAKEFILE_LIST)),,$(__embtk_incmk-y)))
	ifeq (x$(__embtk_incmk-y),xy)
		include $(__embtk_incmk)
	endif
	ifeq (x$(__embtk_incenabled-y),xy)
		HOSTTOOLS_COMPONENTS-y		+= $(pkgv)_install
		# also include old package kconfig entries if any
		-include $(__embtk_pkg_dotkconfig_f)
	else ifeq (x$(__embtk_incinstalled-y),xy)
		HOSTTOOLS_COMPONENTS-		+= $(pkgv)_install
	endif
	# Preset build system installed variable for this packages, if installed
	ifeq (x$(__embtk_incinstalled-y),xy)
		__embtk_$(pkgv)_installed = y
	else
		__embtk_$(pkgv)_installed =
	endif
endef

#
# Macros to include toolchain packages in the build system
#	$(1): pkgname => pkgname/pkgname.mk should exist (required)
#	$(2): xtool component: toolchain_predeps, toolchain_deps or
#             toolchain_addons_deps (required).
#	$(3): kconfig: package specific kconfig symbol name used in .kconfig
#	      This parameter is optional.

define embtk_include_xtoolpkg
	$(eval $(call __embtk_include_xtoolpkg,$(1),$(2),$(3)))
endef
define __embtk_include_xtoolpkg
	$(eval __embtk_inc_pkgname	:= $(or $(3),$(PKGV)))
	# Case where foo and foo_host are in the same .mk file
	$(eval __embtk_incmk0		:= $(embtk_pkgincdir)/$(pkgv)/$(pkgv).mk)
	$(eval __embtk_incmk1		:= $(embtk_pkgincdir)/$(patsubst %_host,%,$(pkgv))/$(patsubst %_host,%,$(pkgv)).mk)
	$(eval __embtk_incmk		:= $(or $(wildcard $(__embtk_incmk0)),$(wildcard $(__embtk_incmk1)),$(wildcard $(__embtk_incmk0))))
	$(eval __embtk_incinstalled-y	:= $(if $(wildcard $(__embtk_pkg_dotinstalled_f)),y))
	$(eval __embtk_incenabled0-y	:= $(CONFIG_EMBTK_HAVE_$(__embtk_inc_pkgname)))
	$(eval __embtk_incenabled1-y	:= $(CONFIG_EMBTK_HOST_HAVE_$(patsubst %_HOST,%,$(__embtk_inc_pkgname))))
	$(eval __embtk_incenabled-y	:= $(or $(__embtk_incenabled0-y),$(__embtk_incenabled1-y)))
	$(eval __embtk_incmk-y		:= $(if $(__embtk_incenabled-y)$(__embtk_incinstalled-y),y))
	# Is it necessary to include the .mk file?
	$(eval __embtk_incmk-y		:= $(if $(findstring $(__embtk_incmk),$(MAKEFILE_LIST)),,$(__embtk_incmk-y)))
	ifeq (x$(__embtk_incmk-y),xy)
		include $(__embtk_incmk)
	endif
	ifeq (x$(__embtk_incenabled-y),xy)
		EMBTK_$(call embtk_ucase,$(2))-y += $(pkgv)_install
		# also include old package kconfig entries if any
		-include $(__embtk_pkg_dotkconfig_f)
	else ifeq (x$(__embtk_incinstalled-y),xy)
		EMBTK_$(call embtk_ucase,$(2))-  += $(pkgv)_install
	endif
	# Preset build system installed variable for this packages, if installed
	ifeq (x$(__embtk_incinstalled-y),xy)
		__embtk_$(pkgv)_installed = y
	else
		__embtk_$(pkgv)_installed =
	endif
	# preset some variables
	$(eval __embtk_$(pkgv)_category  := $(call __embtk_mk_uquote,$(or $(CONFIG_EMBTK_$(PKGV)_REFSPEC),$(CONFIG_EMBTK_$(PKGV)_CATEGORY))))
	__embtk_$(pkgv)_category         := $(or $(__embtk_$(pkgv)_category),$(2))
endef
