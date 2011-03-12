################################################################################
# Embtoolkit
# Copyright(C) 2009-2011 Abdoulaye Walsimou GAYE.
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
# \file         perl.mk
# \brief	perl.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2009
################################################################################

PERL_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_PERL_VERSION_STRING)))
PERL_SITE := http://www.cpan.org/src
PERL_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/perl/$(PERL_VERSION)
PERL_PACKAGE := perl-$(PERL_VERSION).tar.gz
PERL_BUILD_DIR := $(PACKAGES_BUILD)/perl-$(PERL_VERSION)
MICROPERL_BUILD_DIR := $(PACKAGES_BUILD)/perl-$(PERL_VERSION)-micro

microperl_install: $(MICROPERL_BUILD_DIR)/.installed

$(MICROPERL_BUILD_DIR)/.installed: download_perl \
	$(PERL_BUILD_DIR)/.decompressed
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	microperl-$(PERL_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(MICROPERL_BUILD_DIR) -f Makefile.micro \
	OPTIMIZE="$(TARGET_CFLAGS)" CC=$(TARGETCC_CACHED)
	$(Q)cp $(MICROPERL_BUILD_DIR)/microperl $(ROOTFS)/usr/bin
	$(Q)cd $(ROOTFS)/usr/bin; \
	ln -s microperl perl
	@touch $@

download_perl:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(PERL_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(PERL_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(PERL_PACKAGE) \
	$(PERL_SITE)/$(PERL_PACKAGE)
ifeq ($(CONFIG_EMBTK_PERL_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/perl-$(PERL_VERSION).patch || \
	wget $(PERL_PATCH_SITE)/perl-$(PERL_VERSION)-*.patch \
	-O $(DOWNLOAD_DIR)/perl-$(PERL_VERSION).patch
endif

$(PERL_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(PERL_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xzvf $(DOWNLOAD_DIR)/$(PERL_PACKAGE)
ifeq ($(CONFIG_EMBTK_PERL_NEED_PATCH),y)
	@cd $(PERL_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/perl-$(PERL_VERSION).patch
endif
ifeq ($(CONFIG_EMBTK_HAVE_MICROPERL),y)
	@cp -R $(PERL_BUILD_DIR) $(MICROPERL_BUILD_DIR)
endif
	@touch $@

microperl_clean:
	$(call EMBTK_GENERIC_MESSAGE,"Clean microperl for target...")
