################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         utillinuxng.mk
# \brief	utillinuxng.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2010
################################################################################

UTILLINUXNG_MAJOR_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_UTILLINUXNG_MAJOR_VERSION_STRING)))
UTILLINUXNG_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_UTILLINUXNG_VERSION_STRING)))
UTILLINUXNG_SITE := ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/$(UTILLINUXNG_MAJOR_VERSION)
UTILLINUXNG_PATCH_SITE := ftp://ftp.embtoolkit.org/embtoolkit.org/util-linux-ng/$(UTILLINUXNG_VERSION)
UTILLINUXNG_PACKAGE := util-linux-ng-$(UTILLINUXNG_VERSION).tar.bz2
UTILLINUXNG_BUILD_DIR := $(PACKAGES_BUILD)/util-linux-ng-$(UTILLINUXNG_VERSION)
UTILLINUXNG_HOST_BUILD_DIR := $(TOOLS_BUILD)/util-linux-ng-$(UTILLINUXNG_VERSION)

################################
# util-linux-ng for the target #
################################

UTILLINUXNG_BINS =
UTILLINUXNG_SBINS =
UTILLINUXNG_INCLUDES = uuid
UTILLINUXNG_LIBS = libuuid.*
UTILLINUXNG_PKGCONFIGS = uuid.pc

UTILLINUXNG_CONFIGURE_OPTS := --without-audit --without-selinux \
	--without-pam --without-slang --without-ncurses \
	--disable-makeinstall-setuid --disable-makeinstall-chown \
	--disable-use-tty-group --disable-require-password --disable-pg-bell \
	--disable-login-stat-mail --disable-login-chown-vcs \
	--disable-chsh-only-listed --disable-write --disable-wall \
	--disable-schedutils --disable-login-utils --disable-reset \
	--disable-rename --disable-raw --disable-partx --disable-mesg \
	--disable-last --disable-kill  --disable-init --disable-elvtune \
	--disable-unshare --disable-fallocate --disable-pivot_root \
	--disable-switch_root --disable-cramfs --disable-agetty \
	--disable-arch --disable-rpath --disable-nls --disable-libmount \
	--disable-libblkid --disable-uuidd --enable-libuuid --disable-fsck \
	--disable-mount  --disable-tls

UTILLINUXNG_DEPS =

utillinuxng_install:
	@test -e $(UTILLINUXNG_BUILD_DIR)/.installed || \
	$(MAKE) $(UTILLINUXNG_BUILD_DIR)/.installed

$(UTILLINUXNG_BUILD_DIR)/.installed: $(UTILLINUXNG_DEPS) download_utillinuxng \
	$(UTILLINUXNG_BUILD_DIR)/.decompressed \
	$(UTILLINUXNG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	util-linux-ng-$(UTILLINUXNG_VERSION) in your root filesystem...")
	$(call EMBTK_KILL_LT_RPATH,$(UTILLINUXNG_BUILD_DIR))
	$(Q)$(MAKE) -C $(UTILLINUXNG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(UTILLINUXNG_BUILD_DIR)/shlibs/uuid DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

$(UTILLINUXNG_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(UTILLINUXNG_PACKAGE) ...")
	@tar -C $(PACKAGES_BUILD) -xjf $(DOWNLOAD_DIR)/$(UTILLINUXNG_PACKAGE)
ifeq ($(CONFIG_EMBTK_UTILLINUXNG_NEED_PATCH),y)
	@cd $(UTILLINUXNG_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/util-linux-ng-$(UTILLINUXNG_VERSION).patch
endif
	@touch $@

$(UTILLINUXNG_BUILD_DIR)/.configured:
	$(Q)cd $(UTILLINUXNG_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) \
	CXX=$(TARGETCXX_CACHED) \
	AR=$(TARGETAR) \
	RANLIB=$(TARGETRANLIB) \
	AS=$(CROSS_COMPILE)as \
	LD=$(TARGETLD) \
	NM=$(TARGETNM) \
	STRIP=$(TARGETSTRIP) \
	OBJDUMP=$(TARGETOBJDUMP) \
	OBJCOPY=$(TARGETOBJCOPY) \
	CFLAGS="$(TARGET_CFLAGS)" \
	CXXFLAGS="$(TARGET_CFLAGS)" \
	LDFLAGS="-L$(SYSROOT)/$(LIBDIR) -L$(SYSROOT)/usr/$(LIBDIR)" \
	CPPFLGAS="-I$(SYSROOT)/usr/include" \
	PKG_CONFIG=$(PKGCONFIG_BIN) \
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	./configure --build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR) \
	--prefix=/usr $(UTILLINUXNG_CONFIGURE_OPTS)
	@touch $@

utillinuxng_clean:
	$(call EMBTK_GENERIC_MESSAGE,"cleanup util-linux-ng...")
	$(Q)-cd $(SYSROOT)/usr/bin; rm -rf $(UTILLINUXNG_BINS)
	$(Q)-cd $(SYSROOT)/usr/sbin; rm -rf $(UTILLINUXNG_SBINS)
	$(Q)-cd $(SYSROOT)/usr/include; rm -rf $(UTILLINUXNG_INCLUDES)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR); rm -rf $(UTILLINUXNG_LIBS)
	$(Q)-cd $(SYSROOT)/usr/$(LIBDIR)/pkgconfig; rm -rf $(UTILLINUXNG_PKGCONFIGS)
	$(Q)-rm -rf $(UTILLINUXNG_BUILD_DIR)*

##################################################
# util-linux-ng for the host development machine #
##################################################

UTILLINUXNG_HOST_CONFIGURE_OPTS := --without-audit --without-selinux \
	--without-pam --without-slang --without-ncurses \
	--disable-makeinstall-setuid --disable-makeinstall-chown \
	--disable-use-tty-group --disable-require-password --disable-pg-bell \
	--disable-login-stat-mail --disable-login-chown-vcs \
	--disable-chsh-only-listed --disable-write --disable-wall \
	--disable-schedutils --disable-login-utils --disable-reset \
	--disable-rename --disable-raw --disable-partx --disable-mesg \
	--disable-last --disable-kill  --disable-init --disable-elvtune \
	--disable-unshare --disable-fallocate --disable-pivot_root \
	--disable-switch_root --disable-cramfs --disable-agetty \
	--disable-arch --disable-rpath --disable-nls --disable-libmount \
	--disable-libblkid --disable-uuidd --enable-libuuid --disable-fsck \
	--disable-mount  --disable-tls

UTILLINUXNG_HOST_DEPS =

utillinuxng_host_install:
	test -e $(UTILLINUXNG_HOST_BUILD_DIR)/.installed || \
	$(MAKE) $(UTILLINUXNG_HOST_BUILD_DIR)/.installed

$(UTILLINUXNG_HOST_BUILD_DIR)/.installed: $(UTILLINUXNG_HOST_DEPS) \
	download_utillinuxng $(UTILLINUXNG_HOST_BUILD_DIR)/.decompressed \
	$(UTILLINUXNG_HOST_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MESSAGE,"Compiling and installing \
	util-linux-ng-$(UTILLINUXNG_VERSION) in host tools...")
	$(Q)$(MAKE) -C $(UTILLINUXNG_HOST_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(UTILLINUXNG_HOST_BUILD_DIR)/shlibs/uuid install
	@touch $@

$(UTILLINUXNG_HOST_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(UTILLINUXNG_PACKAGE) ...")
	@tar -C $(TOOLS_BUILD) -xjf $(DOWNLOAD_DIR)/$(UTILLINUXNG_PACKAGE)
ifeq ($(CONFIG_EMBTK_UTILLINUXNG_NEED_PATCH),y)
	@cd $(UTILLINUXNG_HOST_BUILD_DIR); \
	patch -p1 < $(DOWNLOAD_DIR)/util-linux-ng-$(UTILLINUXNG_VERSION).patch
endif
	@touch $@

$(UTILLINUXNG_HOST_BUILD_DIR)/.configured:
	$(Q)cd $(UTILLINUXNG_HOST_BUILD_DIR); \
	./configure --build=$(HOST_BUILD) --host=$(HOST_ARCH) \
	--prefix=$(HOSTTOOLS)/usr/local \
	$(UTILLINUXNG_HOST_CONFIGURE_OPTS)
	@touch $@

utillinuxng_host_clean:
	$(call EMBTK_GENERIC_MESSAGE,"Cleanup util-linux-ng...")

##############################
# Common for host and target #
##############################
download_utillinuxng:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(UTILLINUXNG_PACKAGE) \
	if necessary...")
	@test -e $(DOWNLOAD_DIR)/$(UTILLINUXNG_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(UTILLINUXNG_PACKAGE) \
	$(UTILLINUXNG_SITE)/$(UTILLINUXNG_PACKAGE)
ifeq ($(CONFIG_EMBTK_UTILLINUXNG_NEED_PATCH),y)
	@test -e $(DOWNLOAD_DIR)/util-linux-ng-$(UTILLINUXNG_VERSION).patch || \
	wget -O $(DOWNLOAD_DIR)/util-linux-ng-$(UTILLINUXNG_VERSION).patch \
	$(UTILLINUXNG_PATCH_SITE)/util-linux-ng-$(UTILLINUXNG_VERSION)-*.patch
endif
