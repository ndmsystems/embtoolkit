################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
################################################################################
#
# \file         termcap.mk
# \brief	termcap.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2009
################################################################################

TERMCAP_VERSION := 1.3.1
TERMCAP_SITE := ftp://ftp.gnu.org/gnu/termcap/
TERMCAP_PACKAGE := termcap-$(TERMCAP_VERSION).tar.gz
TERMCAP_TARGET_BUILD_DIR :=$(PACKAGES_BUILD)/termcap

termcap_target_install: $(TERMCAP_TARGET_BUILD_DIR)/.installed

$(TERMCAP_TARGET_BUILD_DIR)/.installed: termcap_download \
$(TERMCAP_TARGET_BUILD_DIR)/.decompressed \
$(TERMCAP_TARGET_BUILD_DIR)/.configured
	@cd $(TERMCAP_TARGET_BUILD_DIR); make $(J) ; make install

$(TERMCAP_TARGET_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring termcap-$(TERMCAP_VERSION) \
	for $(STRICT_GNU_TARGET) ...")
	@cd $(TERMCAP_TARGET_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) RANLIB=$(TARGETRANLIB) AR=$(TARGETAR) \
	$(PACKAGES_BUILD)/termcap-$(TERMCAP_VERSION)/configure \
	--host=$(STRICT_GNU_TARGET) --target=$(STRICT_GNU_TARGET) \
	--prefix=$(SYSROOT)/usr
	@touch $@

termcap_download:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(TERMCAP_PACKAGE) \
	if necessary ...")
	@test -e $(DOWNLOAD_DIR)/$(TERMCAP_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(TERMCAP_PACKAGE) \
	$(TERMCAP_SITE)/$(TERMCAP_PACKAGE)

$(TERMCAP_TARGET_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(TERMCAP_PACKAGE)")
	@cd $(PACKAGES_BUILD); test -e  termcap-$(TERMCAP_VERSION) || \
	tar xzf $(DOWNLOAD_DIR)/$(TERMCAP_PACKAGE)
	@mkdir $(TERMCAP_TARGET_BUILD_DIR)
	@touch $@
