################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
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
# __embtk_streq:
# A macro for two strings comparison. It returns y if the strings are identical
# and nothing if not.
# Note: This macro strips passed parameters
# Usage:
# $(call __embtk_streq,str1,str2)
#
__embtk_streq = $(if $(subst $(1),,$(2))$(subst $(2),,$(1)),,y)

#
# __embtk_strneq:
# A macro for two strings comparison. It returns y if the strings are different
# and nothing if they are the same.
# Note: This macro strips passed parameters
# Usage:
# $(call __embtk_strneq,str1,str2)
#
__embtk_strneq = $(if $(subst $(1),,$(2))$(subst $(2),,$(1)),y)

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
__embtk_mk_uquote	= $(subst ",,$(strip $(1)))
embtk_uquote		= $(call __embtk_mk_uquote,$(1))

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
#
include core/mk/pkg-macros/vars.mk
include core/mk/pkg-macros/include.mk
include core/mk/pkg-macros/pkg-config.mk
include core/mk/pkg-macros/libtool.mk
include core/mk/pkg-macros/download.mk
include core/mk/pkg-macros/configure.mk
include core/mk/pkg-macros/install.mk
include core/mk/pkg-macros/clean.mk

#
# help macros
#
define help_toolchain_summary
	$(call embtk_echo_blue," ~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Toolchain |")
	$(call embtk_echo_blue," ~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"\tEmbToolkit          : v$(EMBTK_VERSION)")
	$(call embtk_echo_blue,"\tArchitecture        : $(call embtk_ucase,$(LINUX_ARCH)) ($(EMBTK_MCU_FLAG))")
	$(call embtk_echo_blue,"\tFloating Point      : $(if $(CONFIG_EMBTK_SOFTFLOAT),Soft,Hard)")
	$(if $(GCC_WITH_FPU-y),
	$(call embtk_echo_blue,"\tFPU                 : $(GCC_WITH_FPU-y)"))
	$(call embtk_echo_blue,"\tLinux kernel headers: linux-$(call __embtk_pkg_version,linux)")
	$(call embtk_echo_blue,"\tBinutils            : binutils-$(call  __embtk_pkg_version,binutils)")
	$(if $(CONFIG_EMBTK_HOST_HAVE_LLVM),
	$(call embtk_echo_blue,"\tCLANG/LLVM          : clang/llvm-$(call __embtk_pkg_version,llvm_host)"))
	$(call embtk_echo_blue,"\tGCC                 : gcc-$(call __embtk_pkg_version,gcc)")
	$(call embtk_echo_blue,"\tC library           : $(call __embtk_pkg_name,$(embtk_clib))-$(call __embtk_pkg_version,$(embtk_clib))")
	$(if $(CONFIG_EMBTK_HAVE_GDB_SYSTEM),
	$(call embtk_echo_blue,"\tGDB                 : gdb-$(call __embtk_pkg_version,gdb)"))
	$(if $(CONFIG_EMBTK_HAVE_LTRACE),
	$(call embtk_echo_blue,"\tltrace              : ltrace-$(call __embtk_pkg_version,ltrace)"))
	$(if $(CONFIG_EMBTK_HAVE_STRACE),
	$(call embtk_echo_blue,"\tStrace              : strace-$(call __embtk_pkg_version,strace)"))
	$(call embtk_echo_blue,"\tToolchain location  :")
	$(call embtk_echo_blue,"\t├── generated")
	$(call embtk_echo_blue,"\t│   ├─[ sysroot ] $(notdir $(embtk_sysroot))")
	$(call embtk_echo_blue,"\t│   └─[ xtools  ] $(notdir $(embtk_tools))")
	$(call embtk_echo_blue,"\t└── generated/toolchains")
	$(call embtk_echo_blue,"\t    └─[ tarball ] toolchain-$(__xtools_archos)-$(__xtools_bins)-$(__xtools_env)")
endef

define help_rootfs_summary
	$(if $(CONFIG_EMBTK_HAVE_ROOTFS),
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Root FS packages |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"\tNumber of root FS packages: $(__embtk_rootfs_nrpkgs-y)")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Root FS types |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"\tTAR.BZ2        : Yes")
	$(call embtk_echo_blue,"\tInitramfs      : $(if $(CONFIG_EMBTK_ROOTFS_HAVE_INITRAMFS_CPIO),Yes,No)")
	$(call embtk_echo_blue,"\tsquashFS       : $(if $(CONFIG_EMBTK_ROOTFS_HAVE_SQUASHFS),Yes,No)")
	$(call embtk_echo_blue,"\tJFFS2          : $(if $(CONFIG_EMBTK_ROOTFS_HAVE_JFFS2),Yes,No)")
	$(call embtk_echo_blue,"\tImages location:")
	$(call embtk_echo_blue,"\t└── generated"))
endef

define help_successful_build
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"| Embedded systems Toolkit   |")
	$(call embtk_echo_blue," ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ")
	$(call embtk_echo_blue,"We hope that EmbToolkit will be useful for your project !!!")
	$(call embtk_echo_blue,"We will be happy to know it at embtk-users@embtoolkit.org")
	@echo
	$(call embtk_echo_blue,"Please report any bugs/suggestion at:")
	$(call embtk_echo_blue,"   $(EMBTK_BUGURL)")
	$(call embtk_echo_blue,"You can also visit the project web site at:")
	$(call embtk_echo_blue,"   http://www.embtoolkit.org")
	$(call embtk_echo_blue,$(__embtk_msg_h))
endef
