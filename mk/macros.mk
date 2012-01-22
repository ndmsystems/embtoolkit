################################################################################
# Embtoolkit
# Copyright(C) 2009-2012 Abdoulaye Walsimou GAYE.
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
# \file         macros.mk
# \brief	macros.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

# Embtoolkit colors
__embtk_color_red	= "\E[1;31m"
__embtk_color_green	= "\E[1;32m"
__embtk_color_yellow	= "\E[0;33m"
__embtk_color_blue	= "\E[1;34m"
__embtk_no_color	= "\E[0m"

#
# echo colored text
# usage: $(call embtk_echo_{color},msg)
#
embtk_echo_red		= echo -e $(__embtk_color_red)$(1)$(__embtk_no_color)
embtk_echo_green	= echo -e $(__embtk_color_green)$(1)$(__embtk_no_color)
embtk_echo_yellow	= echo -e $(__embtk_color_yellow)$(1)$(__embtk_no_color)
embtk_echo_blue		= echo -e $(__embtk_color_blue)$(1)$(__embtk_no_color)

__embtk_msg_h = "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

#
# __embtk_mk_strcmp:
# A macro for two strings comparison. It returns y if the strings are identical
# and nothing if not.
# Note: This macro strips passed parameters
# Usage:
# $(call __embtk_mk_strcmp,str1,str2)
#
__embtk_mk_strcmp = $(shell [ $(strip $(1)) = $(strip $(2)) ] && echo y)

#
# __embtk_mk_pathexist
# A macro to test if a path exists. It returns y if the path exists and nothing
# if not.
# Usage: $(call __embtk_mk_pathexist,/path/to/test)
#
__embtk_mk_pathexist = $(if $(wildcard $(1)),y)

#
# __embtk_mk_pathnotexist
# A macro to test if a path does not exist. It returns y if the path does not
# exist and nothing if it exists.
# Usage: $(call __embtk_mk_pathnotexist,/path/to/test)
#
__embtk_mk_pathnotexist = $(if $(wildcard $(1)),,y)

# Macro to print messages
embtk_pwarning	= $(call embtk_echo_yellow,"$(__embtk_msg_h)\\n~~ EmbToolkit ~~ WARNING: $(1)\\n$(__embtk_msg_h)")
embtk_perror	= $(call embtk_echo_red,"$(__embtk_msg_h)\\n~~ EmbToolkit ~~ ERROR: $(1)\\n$(__embtk_msg_h)")
embtk_pinfo	= $(call embtk_echo_blue,"$(__embtk_msg_h)\n~~ EmbToolkit ~~ $(1)\n$(__embtk_msg_h)")

# Packages management macros
include $(EMBTK_ROOT)/mk/macros.packages.mk
