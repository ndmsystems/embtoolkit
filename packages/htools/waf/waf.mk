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
# \file         waf.mk
# \brief	waf.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2014
################################################################################

WAF_HOST_NAME		:= waf
WAF_HOST_VERSION	:= $(call embtk_get_pkgversion,waf_host)
WAF_HOST_SITE		:= http://ftp.waf.io/pub/release
WAF_HOST_PACKAGE	:= waf-$(WAF_HOST_VERSION)
WAF_HOST_SRC_DIR	:= $(embtk_toolsb)/waf-$(WAF_HOST_VERSION)
WAF_HOST_BUILD_DIR	:= $(embtk_toolsb)/waf-$(WAF_HOST_VERSION)

define embtk_download_waf_host
	[ -e $(embtk_dldir)/$(WAF_HOST_PACKAGE) ] || \
		$(call embtk_wget,$(WAF_HOST_PACKAGE),$(WAF_HOST_SITE))
endef

define embtk_install_waf_host
	$(embtk_download_waf_host)
	[ -e $(embtk_waf) ] || $(embtk_postinstallonce_waf_host)
endef

define embtk_postinstallonce_waf_host
	install -D -m 0755 $(embtk_dldir)/$(WAF_HOST_PACKAGE) $(embtk_waf)
endef

download_waf_host waf_host_download:
	$(embtk_download_waf_host)
