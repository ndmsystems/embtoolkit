################################################################################
# Embtoolkit
# Copyright(C) 2009-2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         gdb.mk
# \brief	gdb.mk of Embtoolkit.
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         July 2009
################################################################################

GDB_VERSION := $(subst ",,$(strip $(CONFIG_EMBTK_GDB_VERSION_STRING)))
GDB_SITE := http://ftp.gnu.org/gnu/gdb
GDB_PACKAGE := gdb-$(GDB_VERSION).tar.bz2
GDB_HOST_BUILD_DIR :=$(TOOLS_BUILD)/gdb
GDB_TARGET_BUILD_DIR :=$(PACKAGES_BUILD)/gdb
GDBSERVER_TARGET_BUILD_DIR :=$(PACKAGES_BUILD)/gdbserver

gdb_host_install: $(GDB_HOST_BUILD_DIR)/.installed
gdb_target_install: $(GDB_TARGET_BUILD_DIR)/.installed
gdbserver_target_install: $(GDBSERVER_TARGET_BUILD_DIR)/.installed

#gdb for target
$(GDB_TARGET_BUILD_DIR)/.installed: ncurses_install download_gdb \
	decompress_gdb $(GDB_TARGET_BUILD_DIR)/.configured
	$(Q)$(MAKE) -C $(GDB_TARGET_BUILD_DIR) $(J)
	$(Q)$(MAKE) -C $(GDB_TARGET_BUILD_DIR) install

$(GDBSERVER_TARGET_BUILD_DIR)/.installed: ncurses_install download_gdb \
	decompress_gdb $(GDB_TARGET_BUILD_DIR)/.configured
	cd $(GDB_TARGET_BUILD_DIR); make; cd gdb/gdbserver; make install
	@touch $@

$(GDB_TARGET_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring gdb-$(GDB_VERSION) for \
	$(STRICT_GNU_TARGET) ...")
	@cd $(GDB_TARGET_BUILD_DIR); \
	CC=$(TARGETCC_CACHED) CXX=$(TARGETCXX_CACHED) \
	AR=$(TARGETAR) LD=$(TARGETLD) RANLIB=$(TARGETRANLIB) \
	NM=$(TARGETNM) STRIP=$(TARGETSTRIP) \
	$(TOOLS_BUILD)/gdb-$(GDB_VERSION)/configure \
	--host=$(STRICT_GNU_TARGET) \
	--target=$(STRICT_GNU_TARGET) --prefix=$(SYSROOT)/usr --disable-werror
	@touch $@

gdb_target_clean:
	$(call EMBTK_GENERIC_MESSAGE,"Cleanup gdb for target...")
gdbserver_target_clean:
	$(call EMBTK_GENERIC_MESSAGE,"Cleanup gdbserver for target...")

#gdb for host
$(GDB_HOST_BUILD_DIR)/.installed: download_gdb decompress_gdb \
$(GDB_HOST_BUILD_DIR)/.configured
	@cd $(GDB_HOST_BUILD_DIR); make $(J); make install
	@touch $@

$(GDB_HOST_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring gdb-$(GDB_VERSION) for \
	your host development machine ...")
	@cd $(GDB_HOST_BUILD_DIR); \
	CC=$(HOSTCC_CACHED) CXX=$(HOSTCXX_CACHED) \
	CC_FOR_TARGET=$(TARGETCC_CACHED) CXX_FOR_TARGET=$(TARGETCXX_CACHED) \
	AR_FOR_TARGET=$(TARGETAR) LD_FOR_TARGET=$(TARGETLD) \
	NM_FOR_TARGET=$(TARGETNM)  RANLIB_FOR_TARGET=$(TARGETRANLIB) \
	STRIP_FOR_TARGET=$(TARGETSTRIP) OBJDUMP_FOR_TARGET=$(TARGETOBJDUMP) \
	$(TOOLS_BUILD)/gdb-$(GDB_VERSION)/configure \
	--host=$(HOST_ARCH) --build=$(HOST_ARCH) --target=$(STRICT_GNU_TARGET) \
	--prefix=$(TOOLS) --disable-werror
	@touch $@

download_gdb:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(GDB_PACKAGE) \
	if necessary ...")
	@test -e $(DOWNLOAD_DIR)/$(GDB_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(GDB_PACKAGE) \
	$(GDB_SITE)/$(GDB_PACKAGE)

decompress_gdb:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(GDB_PACKAGE) ...")
	@cd $(TOOLS_BUILD); test -e  gdb-$(GDB_VERSION) || \
	tar xjf $(DOWNLOAD_DIR)/$(GDB_PACKAGE)
	@mkdir -p $(GDB_TARGET_BUILD_DIR)
	@mkdir -p $(GDBSERVER_TARGET_BUILD_DIR)
	@mkdir -p $(GDB_HOST_BUILD_DIR)

