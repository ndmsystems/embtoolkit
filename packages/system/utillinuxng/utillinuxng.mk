################################################################################
# Embtoolkit
# Copyright(C) 2010-2011 Abdoulaye Walsimou GAYE.
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

UTILLINUXNG_NAME		:= util-linux-ng
UTILLINUXNG_MAJOR_VERSION	:= $(call EMBTK_GET_PKG_VERSION,UTILLINUXNG_MAJOR)
UTILLINUXNG_VERSION		:= $(call EMBTK_GET_PKG_VERSION,UTILLINUXNG)
UTILLINUXNG_SITE		:= ftp://ftp.kernel.org/pub/linux/utils/util-linux-ng/$(UTILLINUXNG_MAJOR_VERSION)
UTILLINUXNG_SITE_MIRROR3	:= ftp://ftp.embtoolkit.org/embtoolkit.org/packages-mirror
UTILLINUXNG_PATCH_SITE		:= ftp://ftp.embtoolkit.org/embtoolkit.org/util-linux-ng/$(UTILLINUXNG_VERSION)
UTILLINUXNG_PACKAGE		:= util-linux-ng-$(UTILLINUXNG_VERSION).tar.bz2
UTILLINUXNG_SRC_DIR		:= $(PACKAGES_BUILD)/util-linux-ng-$(UTILLINUXNG_VERSION)
UTILLINUXNG_BUILD_DIR		:= $(PACKAGES_BUILD)/util-linux-ng-$(UTILLINUXNG_VERSION)

################################
# util-linux-ng for the target #
################################

UTILLINUXNG_BINS =
UTILLINUXNG_SBINS =
UTILLINUXNG_INCLUDES = uuid
UTILLINUXNG_LIBS = libuuid.*
UTILLINUXNG_PKGCONFIGS = uuid.pc

UTILLINUXNG_CONFIGURE_OPTS := --without-audit --without-selinux	\
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

$(UTILLINUXNG_BUILD_DIR)/.installed: $(UTILLINUXNG_DEPS) \
	download_utillinuxng \
	$(UTILLINUXNG_SRC_DIR)/.decompressed \
	$(UTILLINUXNG_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MSG,"Compiling and installing \
	util-linux-ng-$(UTILLINUXNG_VERSION) in your root filesystem...")
	$(Q)$(MAKE) -C $(UTILLINUXNG_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(UTILLINUXNG_BUILD_DIR)/shlibs/uuid DESTDIR=$(SYSROOT) install
	$(Q)$(MAKE) libtool_files_adapt
	$(Q)$(MAKE) pkgconfig_files_adapt
	@touch $@

$(UTILLINUXNG_SRC_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_PKG,UTILLINUXNG)

$(UTILLINUXNG_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_PKG,UTILLINUXNG)

utillinuxng_clean:
	$(call EMBTK_CLEANUP_PKG,UTILLINUXNG)

##################################################
# util-linux-ng for the host development machine #
##################################################
UTILLINUXNG_HOST_NAME		:= $(UTILLINUXNG_NAME)
UTILLINUXNG_HOST_VERSION	:= $(UTILLINUXNG_VERSION)
UTILLINUXNG_HOST_SITE		:= $(UTILLINUXNG_SITE)
UTILLINUXNG_HOST_SITE_MIRROR3	:= $(UTILLINUXNG_SITE_MIRROR3)
UTILLINUXNG_HOST_PATCH_SITE	:= $(UTILLINUXNG_PATCH_SITE)
UTILLINUXNG_HOST_PACKAGE	:= $(UTILLINUXNG_PACKAGE)
UTILLINUXNG_HOST_SRC_DIR	:= $(TOOLS_BUILD)/util-linux-ng-$(UTILLINUXNG_VERSION)
UTILLINUXNG_HOST_BUILD_DIR	:= $(TOOLS_BUILD)/util-linux-ng-$(UTILLINUXNG_VERSION)

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
	@test -e $(UTILLINUXNG_HOST_BUILD_DIR)/.installed || \
	$(MAKE) $(UTILLINUXNG_HOST_BUILD_DIR)/.installed

$(UTILLINUXNG_HOST_BUILD_DIR)/.installed: $(UTILLINUXNG_HOST_DEPS) \
	download_utillinuxng \
	$(UTILLINUXNG_HOST_SRC_DIR)/.decompressed \
	$(UTILLINUXNG_HOST_BUILD_DIR)/.configured
	$(call EMBTK_GENERIC_MSG,"Compiling and installing \
	util-linux-ng-$(UTILLINUXNG_VERSION) in host tools...")
	$(Q)$(MAKE) -C $(UTILLINUXNG_HOST_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(UTILLINUXNG_HOST_BUILD_DIR)/shlibs/uuid install
	@touch $@

$(UTILLINUXNG_HOST_SRC_DIR)/.decompressed:
	$(call EMBTK_DECOMPRESS_HOSTPKG,UTILLINUXNG_HOST)

$(UTILLINUXNG_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_CONFIGURE_HOSTPKG,UTILLINUXNG_HOST)

utillinuxng_host_clean:
	$(call EMBTK_GENERIC_MSG,"Cleanup util-linux-ng for host...")

##############################
# Common for host and target #
##############################
download_utillinuxng download_utillinuxng_host:
	$(call EMBTK_DOWNLOAD_PKG,UTILLINUXNG)
