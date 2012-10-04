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

PERL_NAME	:= perl
PERL_VERSION	:= $(call embtk_get_pkgversion,perl)
PERL_SITE	:= http://www.cpan.org/src
PERL_PACKAGE	:= perl-$(PERL_VERSION).tar.gz
PERL_SRC_DIR	:= $(embtk_pkgb)/perl-$(PERL_VERSION)
PERL_BUILD_DIR	:= $(embtk_pkgb)/perl-$(PERL_VERSION)


#
# microperl
#
MICROPERL_NAME		:= $(PERL_NAME)
MICROPERL_VERSION	:= $(PERL_VERSION)
MICROPERL_SITE		:= $(PERL_SITE)
MICROPERL_PACKAGE	:= $(PERL_PACKAGE)
MICROPERL_SRC_DIR	:= $(PERL_SRC_DIR)
MICROPERL_BUILD_DIR	:= $(embtk_pkgb)/perl-$(PERL_VERSION)

microperl_install: $(MICROPERL_BUILD_DIR)/.installed
	$(call embtk_pinfo,"Successfully installed microperl")

$(MICROPERL_BUILD_DIR)/.installed: download_microperl \
	$(PERL_BUILD_DIR)/.decompressed
	$(call embtk_pinfo,"Compiling and installing \
	microperl-$(PERL_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(MICROPERL_BUILD_DIR) -f Makefile.micro \
		OPTIMIZE="$(TARGET_CFLAGS)" CC=$(TARGETCC_CACHED)
	$(Q)mkdir -p $(embtk_rootfs)
	$(Q)mkdir -p $(embtk_rootfs)/usr
	$(Q)mkdir -p $(embtk_rootfs)/usr/bin
	$(Q)cp $(MICROPERL_BUILD_DIR)/microperl $(embtk_rootfs)/usr/bin
	$(Q)cd $(embtk_rootfs)/usr/bin; ln -sf microperl perl
	$(Q)touch $@

$(PERL_BUILD_DIR)/.decompressed:
	$(call embtk_decompress_pkg,perl)

microperl_clean:
	$(call embtk_cleanup_pkg,perl)

download_microperl download_perl:
	$(call embtk_download_pkg,perl)
