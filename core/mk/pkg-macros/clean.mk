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
# \file         clean.mk
# \brief	clean.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2014
################################################################################


#
# A macro to clean installed packages from sysroot.
# Usage:
# $(call embtk_cleanup_pkg,pkgname)
#
define __embtk_cleanup_pkg
	$(eval __embtk_$(pkgv)_installed =)
	$(if $(embtk_cleanup_$(pkgv)),$(embtk_cleanup_$(pkgv)))
	$(if $(__embtk_pkg_etc),
		rm -rf $(addprefix $(embtk_sysroot)/etc/,$(__embtk_pkg_etc)))
	$(if $(__embtk_pkg_bins),
		rm -rf $(addprefix $(embtk_sysroot)/usr/bin/,$(__embtk_pkg_bins)))
	$(if $(__embtk_pkg_sbins),
		rm -rf $(addprefix $(embtk_sysroot)/usr/sbin/,$(__embtk_pkg_sbins)))
	$(if $(__embtk_pkg_includes),
		rm -rf $(addprefix $(embtk_sysroot)/usr/include/,$(__embtk_pkg_includes)))
	$(if $(__embtk_pkg_libs),
		rm -rf $(addprefix $(embtk_sysroot)/usr/$(LIBDIR)/,$(__embtk_pkg_libs)))
	$(if $(__embtk_pkg_libexecs),
		rm -rf $(addprefix $(embtk_sysroot)/usr/libexec/,$(__embtk_pkg_libexecs)))
	$(if $(__embtk_pkg_pkgconfigs),
		rm -rf $(addprefix $(embtk_sysroot)/usr/$(LIBDIR)/pkgconfig/,$(__embtk_pkg_pkgconfigs))
		rm -rf $(addprefix $(embtk_sysroot)/usr/share/pkgconfig/,$(__embtk_pkg_pkgconfigs)))
	$(if $(__embtk_pkg_shares),
		rm -rf $(addprefix $(embtk_sysroot)/usr/share/,$(__embtk_pkg_shares)))
	$(if $(__embtk_pkg_usegit)$(__embtk_pkg_usesvn),
		$(call __embtk_unsetconfigured_pkg,$(1))
		$(call __embtk_unsetinstalled_pkg,$(1)),
		$(if $(__embtk_pkg_srcdir),rm -rf $(__embtk_pkg_srcdir)*)
		$(if $(__embtk_pkg_builddir),rm -rf $(__embtk_pkg_builddir)*))
	$(if $(__embtk_pkg_statedir),rm -rf $(__embtk_pkg_statedir))
endef

define embtk_cleanup_pkg
	$(if $(EMBTK_BUILDSYS_DEBUG),
		$(call embtk_pinfo,"Cleanup $(__embtk_pkg_name)..."))
	$(Q)$(call __embtk_cleanup_pkg,$(1))
endef
