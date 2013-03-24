################################################################################
# EmbToolkit
# Copyright(C) 2011 Abdoulaye Walsimou GAYE.
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
# \file         help.mk
# \brief	help.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         August 2011
################################################################################

help:
	$(call embtk_pinfo,"Embedded systems Toolkit help. Please \
	visit - http://www.embtoolkit.org - for more details")
	@echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
	@echo "| Building and configuring: |"
	@echo " ~~~~~~~~~~~~~~~~~~~~~~~~~~~ "
	@echo "make xconfig:    Show EmbToolkit configure GUI and let you to"
	@echo "                 configure your toolchain and your root"
	@echo "                 filesystem (if selected)."
	@echo
	@echo "make menuconfig: Same as xconfig but using this time ncurse GUI."
	@echo
	@echo "make:            Start building your toolchain and your root"
	@echo "                 filesystem (if selected) or start xconfig if"
	@echo "                 you did not configure before."
	@echo
	@echo " ~~~~~~~~~~~ "
	@echo "| Cleaning: |"
	@echo " ~~~~~~~~~~~ "
	@echo "make clean:      Remove all built files, but keep downloaded"
	@echo "                 packages."
	@echo
	@echo "make distclean:  WARNING: like clean, but remove all downloaded"
	@echo "                 packages and .config.old files."
	@echo
	@echo " ~~~~~~~~~~~~~~~~~ "
	@echo "| Root filesystem |"
	@echo " ~~~~~~~~~~~~~~~~~ "
	@echo "make rootfs_build:"
	@echo "                 if after a first build of your toolchain and"
	@echo "                 your root filesystem, you change the contents"
	@echo "                 of the root filesystem, use this target to"
	@echo "                 rebuild it."
	@echo
	@echo " ~~~~~~~~~~~~~~~ "
	@echo "| miscellaneous |"
	@echo " ~~~~~~~~~~~~~~~ "
	@echo "make packages_fetch:"
	@echo "                 This will download all needed packages tarball."
	@echo "                 This should be used after configuration and if"
	@echo "                 you want to do an offline build."
	@echo

# Successful build of EmbToolkit message
successful_build:
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Toolchain build log |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"$(GNU_TARGET) ($(EMBTK_MCU_FLAG)) toolchain successfully generated.")
	$(call embtk_echo_blue,"Generated tools (compilers, Binutils, etc.) are in:")
	$(call embtk_echo_blue,"    $(embtk_tools)/bin")
	$(call embtk_echo_blue,"The packaged toolchain (for external use) is in:")
	$(call embtk_echo_blue,"    $(embtk_generated)")
	@echo
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Root file system build log |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
ifeq ($(CONFIG_EMBTK_HAVE_ROOTFS),y)
	$(call embtk_echo_blue,"Generated root filesystems are located in the")
	$(call embtk_echo_blue,"'generated' sub-directory of EmbToolkit.")
else
	$(call embtk_echo_green,"Build of root filesystem not selected.")
endif
	@echo
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Embedded systems Toolkit   |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"We hope that EmbToolkit will be useful for your project !!!")
	$(call embtk_echo_blue,"We will be happy to know it at embtk-users@embtoolkit.org")
	$(call embtk_echo_blue,"Please report any bugs/suggestion at:")
	$(call embtk_echo_blue,"   http://www.embtoolkit.org/issues/projects/show/embtoolkit")
	$(call embtk_echo_blue,"You can also visit the wiki at:")
	$(call embtk_echo_blue,"   http://www.embtoolkit.org")
	@echo
	$(call embtk_echo_blue,$(__embtk_msg_h))
