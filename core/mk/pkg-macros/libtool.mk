################################################################################
# Embtoolkit
# Copyright(C) 2014 Abdoulaye Walsimou GAYE.
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
# \file         libtool.mk
# \brief	libtool.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2014
################################################################################

#Macro to adapt libtool files (*.la) for cross compiling
__ltlibdirold		= libdir='\/usr\/$(LIBDIR)\(.*\)'
__ltlibdirnew		= libdir='$(embtk_sysroot)\/usr\/$(LIBDIR)\1'
__lt_usr/lib		= $(embtk_space)\/usr\/$(LIBDIR)\/
__lt_sysroot/usr/lib	= $(embtk_space)$(embtk_sysroot)\/usr\/$(LIBDIR)\/
__lt_path		= $(addprefix $(embtk_sysroot)/usr/,$(or $(1),$(LIBDIR)))
define __embtk_fix_libtool_files
	__lt_las=$$(find $(__lt_path) -name '*.la');				\
	for la in $$__lt_las; do						\
		sed -e "s;$(__ltlibdirold);$(__ltlibdirnew);"			\
			-e "s;$(__lt_usr/lib);$(__lt_sysroot/usr/lib);g"	\
			 < $$la > $$la.new;					\
		mv $$la.new $$la;						\
	done
endef
libtool_files_adapt:
	$(Q)$(call __embtk_fix_libtool_files)

#A macro to remove rpath in packages that use libtool -rpath
define __embtk_kill_lt_rpath
	cd $(strip $(1));								\
	LOCAL_LT_FILES=`find . -type f -name libtool`;					\
	for i in $$LOCAL_LT_FILES; do							\
		sed -e 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g'	\
			-e 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g'	\
			< $$i > $$i.new;						\
		mv $$i.new $$i;								\
	done
endef
