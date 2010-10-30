################################################################################
# Abdoulaye Walsimou GAYE, <awg@embtoolkit.org>
# Copyright(C) 2010 Abdoulaye Walsimou GAYE. All rights reserved.
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
# \file         cmake.mk
# \brief	cmake.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE, <awg@embtoolkit.org>
# \date         June 2010
################################################################################

CMAKE_VERSION := 2.8.1
CMAKE_SITE := http://www.cmake.org/files/v2.8
CMAKE_PACKAGE := cmake-$(CMAKE_VERSION).tar.gz
CMAKE_BUILD_DIR := $(TOOLS_BUILD)/cmake-$(CMAKE_VERSION)
CMAKE_DIR := $(HOSTTOOLS)/usr

CMAKE := $(CMAKE_DIR)/bin/cmake
CMAKE_TOOLCHAIN_FILE := $(HOSTTOOLS)/usr/etc/$(STRICT_GNU_TARGET).cmake
export CMAKE CMAKE_TOOLCHAIN_FILE

cmake_install: $(CMAKE_BUILD_DIR)/.installed

$(CMAKE_BUILD_DIR)/.installed: download_cmake \
	$(CMAKE_BUILD_DIR)/.decompressed $(CMAKE_BUILD_DIR)/.configured
	@$(MAKE) -C $(CMAKE_BUILD_DIR) $(J)
	$(MAKE) -C $(CMAKE_BUILD_DIR) install
	$(MAKE) $(CMAKE_BUILD_DIR)/.generate_target_cmake
	@touch $@

download_cmake:
	$(call EMBTK_GENERIC_MESSAGE,"Downloading $(CMAKE_PACKAGE) if \
	necessary...")
	@test -e $(DOWNLOAD_DIR)/$(CMAKE_PACKAGE) || \
	wget -O $(DOWNLOAD_DIR)/$(CMAKE_PACKAGE) \
	$(CMAKE_SITE)/$(CMAKE_PACKAGE)

$(CMAKE_BUILD_DIR)/.decompressed:
	$(call EMBTK_GENERIC_MESSAGE,"Decompressing $(CMAKE_PACKAGE)...")
	@tar -C $(TOOLS_BUILD) -xzf $(DOWNLOAD_DIR)/$(CMAKE_PACKAGE)
	@mkdir -p $(CMAKE_BUILD_DIR)
	@mkdir -p $(CMAKE_DIR)
	@touch $@

$(CMAKE_BUILD_DIR)/.configured:
	$(call EMBTK_GENERIC_MESSAGE,"Configuring \
	cmake_$(CMAKE_VERSION)...")
	@cd $(CMAKE_BUILD_DIR); \
	$(TOOLS_BUILD)/cmake-$(CMAKE_VERSION)/configure \
	--prefix=$(CMAKE_DIR) --build=$(HOST_BUILD) --host=$(HOST_ARCH)
	@touch $@

$(CMAKE_BUILD_DIR)/.generate_target_cmake:
	@mkdir -p $(HOSTTOOLS)/usr
	@mkdir -p $(HOSTTOOLS)/usr/etc
	@echo "# embtoolkit-$(EMBTK_VERSION): automatically generated, do not edit" > $(CMAKE_TOOLCHAIN_FILE)
	@echo "SET(CMAKE_SYSTEM_NAME Linux)" >> $(CMAKE_TOOLCHAIN_FILE)
	@echo "SET(CMAKE_C_COMPILER $(TARGETCC_CACHED))" >> $(CMAKE_TOOLCHAIN_FILE)
	@echo "SET(CMAKE_CXX_COMPILER $(TARGETCXX_CACHED))" >> $(CMAKE_TOOLCHAIN_FILE)
	@echo "SET(CMAKE_FIND_ROOT_PATH $(SYSROOT) $(SYSROOT)/usr)" >> $(CMAKE_TOOLCHAIN_FILE)
	@echo "SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)" >> $(CMAKE_TOOLCHAIN_FILE)
	@echo "SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)" >> $(CMAKE_TOOLCHAIN_FILE)
	@echo "SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)" >> $(CMAKE_TOOLCHAIN_FILE)
	@touch $@

