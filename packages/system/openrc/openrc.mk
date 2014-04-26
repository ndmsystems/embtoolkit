################################################################################
# Copyright(C) 2013-2014 Abdoulaye Walsimou GAYE.
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
# \file         openrc.mk
# \brief	openrc.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         December 2013
################################################################################

OPENRC_NAME		:= openrc
OPENRC_VERSION		:= $(call embtk_get_pkgversion,openrc)
OPENRC_SITE		:= $(embtk_ftp/packages-mirror)
OPENRC_PACKAGE		:= openrc-$(OPENRC_VERSION).tar.bz2
OPENRC_SRC_DIR		:= $(embtk_pkgb)/openrc-$(OPENRC_VERSION)
OPENRC_BUILD_DIR	:= $(embtk_pkgb)/openrc-$(OPENRC_VERSION)

embtk_openrc_mk		:= $(EMBTK_ROOT)/packages/system/openrc

embtk_openrc_hostname	:= EmbToolkit-$(embtk_os)

# sysinit runlevel scripts
embtk_openrc_sysinit	:= devfs dmesg sysfs

# boot runlevel scripts
embtk_openrc_boot	:= bootmisc hostname localmount loopback modules mtab
embtk_openrc_boot	+= network procfs root staticroute swap sysctl urandom

# default runlevel scripts
embtk_openrc_default-y	:=
embtk_openrc_default	:= netmount
embtk_openrc_default-$(CONFIG_KEMBTK_BUSYB_UDHCPC) += udhcpc
embtk_openrc_default	+= $(embtk_openrc_default-y)

# shutdown runlevel scripts
embtk_openrc_shutdown	:= killprocs

# Installed dir/files in sysroot
OPENRC_ETC		:= conf.d init.d.misc init.d local.d rc.conf runlevels
OPENRC_ETC		+= sysctl.d
OPENRC_LIBEXECS		:= rc

ifeq ($(embtk_os),linux)
OPENRC_MAKE_OPTS	:= OS=Linux
endif

OPENRC_MAKE_ENV		:= LIBNAME=$(LIBDIR) MKSTATICLIBS=no MKPKGCONFIG=no
OPENRC_MAKE_ENV		+= AR=$(TARGETAR) RANLIB=$(TARGETRANLIB)
OPENRC_MAKE_ENV		+= CC=$(TARGETCC_CACHED) CFLAGS="$(TARGET_CFLAGS)"
OPENRC_MAKE_ENV		+= LIBEXECDIR=/usr/libexec/rc
OPENRC_MAKE_ENV		+= BRANDING="EmbToolkit v$(EMBTK_VERSION)"
OPENRC_MAKE_ENV		+= MKCONFD=no
OPENRC_MAKE_ENV		+= MKETC=no
OPENRC_MAKE_ENV		+= MKINITD=no
OPENRC_MAKE_ENV		+= MKLOCALD=no
OPENRC_MAKE_ENV		+= MKMAN=no
OPENRC_MAKE_ENV		+= MKSCRIPTS=no
OPENRC_MAKE_ENV		+= MKSYSCTLD=no
OPENRC_MAKE_ENV		+= MKRUNLEVELS=no

define embtk_install_openrc
	$(call embtk_makeinstall_pkg,openrc)
endef

define __embtk_install_openrc_runlevel
	install -d $(embtk_rootfs)/etc/runlevels/$(1) || exit $$?
	for f in $(embtk_openrc_$(1)); do					\
		install -m 0755 $(embtk_openrc_mk)/etc/init.d/$$f		\
			$(embtk_rootfs)/etc/init.d/$$f || exit $$?;		\
		ln -snf /etc/init.d/$$f						\
			$(embtk_rootfs)/etc/runlevels/$(1)/$$f || exit $$?;	\
	done
endef

define __embtk_install_openrc_confd
	install -d $(embtk_rootfs)/etc/conf.d || exit $$?
	for f in $(embtk_openrc_mk)/etc/conf.d/*; do				\
		install -m 0644 $$f $(embtk_rootfs)/etc/conf.d || exit $$?;	\
	done
	echo "hostname=\"$(embtk_openrc_hostname)\""				\
		> $(embtk_rootfs)/etc/conf.d/hostname
	echo "$(embtk_openrc_hostname)"						\
		> $(embtk_rootfs)/etc/hostname
endef

__embtk_rootfs_tty		:= $(call embtk_uquote,$(CONFIG_EMBTK_ROOTFS_TTY))
__embtk_rootfs_tty_baudrate	:= $(call embtk_uquote,$(CONFIG_EMBTK_ROOTFS_TTY_BAUDRATE))
define __embtk_install_openrc_inittab
	cat $(embtk_openrc_mk)/etc/inittab.runlevel				\
		> $(embtk_rootfs)/etc/inittab
	cat $(embtk_openrc_mk)/etc/inittab.tty |				\
	sed	-e 's;{ROOTFS_TTY};$(__embtk_rootfs_tty);g'			\
		-e 's;{ROOTFS_TTY_BAUDRATE};$(__embtk_rootfs_tty_baudrate);g'	\
		>> $(embtk_rootfs)/etc/inittab
	cat $(embtk_openrc_mk)/etc/inittab.logging				\
		>> $(embtk_rootfs)/etc/inittab
	cat $(embtk_openrc_mk)/etc/inittab.reboot				\
		>> $(embtk_rootfs)/etc/inittab
endef
define embtk_postinstall_openrc
	$(__embtk_install_openrc_confd)
	$(__embtk_install_openrc_inittab)
	rm -rf $(embtk_rootfs)/etc/init.d
	install -d $(embtk_rootfs)/etc/init.d || exit $$?
	install -m 0644 $(embtk_openrc_mk)/etc/defaultdomain			\
		$(embtk_rootfs)/etc/defaultdomain || exit $$?
	install -m 0644 $(embtk_openrc_mk)/etc/rc.conf				\
		$(embtk_rootfs)/etc/rc.conf || exit $$?
	$(if $(CONFIG_EMBTK_OS_LINUX),
		install -m 0644 $(embtk_openrc_mk)/etc/issue.linux		\
			$(embtk_rootfs)/etc/issue)
	$(call __embtk_install_openrc_runlevel,sysinit)
	$(call __embtk_install_openrc_runlevel,boot)
	$(call __embtk_install_openrc_runlevel,default)
	$(call __embtk_install_openrc_runlevel,shutdown)
endef

define embtk_cleanup_openrc
	rm -rf $(embtk_sysroot)/$(LIBDIR)/libeinfo.*
	rm -rf $(embtk_sysroot)/$(LIBDIR)/librc.*
	rm -rf $(embtk_sysroot)/bin/rc-status
	rm -rf $(embtk_sysroot)/sbin/rc
	rm -rf $(embtk_sysroot)/sbin/rc-service
	rm -rf $(embtk_sysroot)/sbin/rc-update
	rm -rf $(embtk_sysroot)/sbin/runscript
	rm -rf $(embtk_sysroot)/sbin/service
	rm -rf $(embtk_sysroot)/sbin/start-stop-daemon
	rm -rf $(embtk_sysroot)/sbin/openrc
	rm -rf $(embtk_sysroot)/sbin/openrc-run
endef
