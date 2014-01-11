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
__embtk_color_red	= "\033[1;31m"
__embtk_color_green	= "\033[1;32m"
__embtk_color_yellow	= "\033[0;33m"
__embtk_color_blue	= "\033[1;34m"
__embtk_no_color	= "\033[0m"

#
# echo colored text
# usage: $(call embtk_echo_{color},msg)
#
embtk_echo_red		= printf $(__embtk_color_red)$(1)$(__embtk_no_color)"\n"
embtk_echo_green	= printf $(__embtk_color_green)$(1)$(__embtk_no_color)"\n"
embtk_echo_yellow	= printf $(__embtk_color_yellow)$(1)$(__embtk_no_color)"\n"
embtk_echo_blue		= printf $(__embtk_color_blue)$(1)$(__embtk_no_color)"\n"

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
__embtk_mk_pathexist = $(shell test -e $(1) && echo y)

#
# __embtk_mk_pathnotexist
# A macro to test if a path does not exist. It returns y if the path does not
# exist and nothing if it exists.
# Usage: $(call __embtk_mk_pathnotexist,/path/to/test)
#
__embtk_mk_pathnotexist = $(shell test -e $(1) || echo y)

#
# __embtk_mk_uquote
# A macro to unquote a string.
# Usage: $(call __embtk_mk_uquote,$(myquotedvar))
#
__embtk_mk_uquote = $(subst ",,$(strip $(1)))

# Macro to print messages
embtk_pwarning	= $(call embtk_echo_yellow,"$(__embtk_msg_h)\\n~~ EmbToolkit ~~ WARNING: $(call __embtk_mk_uquote,$(1))\\n$(__embtk_msg_h)")
embtk_perror	= $(call embtk_echo_red,"$(__embtk_msg_h)\\n~~ EmbToolkit ~~ ERROR: $(call __embtk_mk_uquote,$(1))\\n$(__embtk_msg_h)")
embtk_pinfo	= $(call embtk_echo_blue,"$(__embtk_msg_h)\\n~~ EmbToolkit ~~ $(call __embtk_mk_uquote,$(1))\\n$(__embtk_msg_h)")
embtk_pdone	= $(call embtk_echo_blue,"[✔] Done  : $(call __embtk_mk_uquote,$(1))")
embtk_pfailed	= $(call embtk_echo_red,"[✘] Failed: $(call __embtk_mk_uquote,$(1))")

# Macros for emmpty, space and comma
embtk_empty	:=
embtk_space	:= $(embtk_empty) $(embtk_empty)
embtk_comma	:= ,

#
# Macros to change strings case (upper->lower or lower to upper)
#
[U-l]           := A,a B,b C,c D,d E,e F,f G,g H,h I,i J,j K,k L,l M,m N,n O,o P,p Q,q R,r S,s T,t U,u V,v W,w X,x Y,y Z,z
[l-U]           := a,A b,B c,C d,D e,E f,F g,G h,H i,I j,J k,K l,L m,M n,N o,O p,P q,Q r,R s,S t,T u,U v,V w,W x,X y,Y z,Z

embtk_lcase	= $(strip $(call __embtk_lcase,$(1)))
define __embtk_lcase
	$(eval __lcase := $(1))
	$(foreach __c,$([U-l]),
		$(eval __c1	:= $(word 1,$(subst $(embtk_comma),$(embtk_space),$(__c))))
		$(eval __c2	:= $(word 2,$(subst $(embtk_comma),$(embtk_space),$(__c))))
		$(eval __lcase	:= $(subst $(__c1),$(__c2),$(__lcase))))$(__lcase)
endef

embtk_ucase	= $(strip $(call __embtk_ucase,$(1)))
define __embtk_ucase
	$(eval __ucase := $(1))
	$(foreach __c,$([l-U]),
		$(eval __c1	:= $(word 1,$(subst $(embtk_comma),$(embtk_space),$(__c))))
		$(eval __c2	:= $(word 2,$(subst $(embtk_comma),$(embtk_space),$(__c))))
		$(eval __ucase	:= $(subst $(__c1),$(__c2),$(__ucase))))$(__ucase)
endef

#
# Packages management macros
include mk/pkg-macros/vars.mk
include mk/pkg-macros/incl.mk
include mk/pkg-macros/pkg-config.mk
include mk/pkg-macros/libtool.mk
include mk/pkg-macros/download.mk
include mk/pkg-macros/configure.mk
include mk/pkg-macros/install.mk
include mk/pkg-macros/clean.mk
