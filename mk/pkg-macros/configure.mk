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
# \file         configure.mk
# \brief	configure.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         January 2014
################################################################################

#
# embtk_fixgconfigsfor_pkg
#
__embtk_gconfigsub	:= $(EMBTK_ROOT)/scripts/config.sub
__embtk_gconfiguess	:= $(EMBTK_ROOT)/scripts/config.guess
define __embtk_fixgconfigsfor_pkg
	subs="$$(find $(__embtk_pkg_srcdir)/ -type f -name config.sub)";	\
	for sub in $$subs; do							\
		if [ -n $$sub -a -e $$sub ]; then				\
			ln -sf $(__embtk_gconfigsub) $$sub;			\
		fi;								\
	done;									\
	guesses="$$(find $(__embtk_pkg_srcdir)/ -type f -name config.guess)"; 	\
	for guess in $$guesses; do						\
		if [ -n $$guess -a -e $$guess ]; then				\
			ln -sf $(__embtk_gconfiguess) $$guess;			\
		fi;								\
	done;
endef

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package and sets environment variables correctly.
# Usage:
# $(call embtk_configure_pkg,PACKAGE)
#
define __embtk_configure_autoreconfpkg
if [ "x$(CONFIG_EMBTK_$(PKGV)_NEED_AUTORECONF)" = "xy" ]; then			\
	test -e $(__embtk_pkg_srcdir)/configure.ac ||				\
	test -e $(__embtk_pkg_srcdir)/configure.in || exit 1;			\
	cd $(__embtk_pkg_srcdir);						\
	$(AUTORECONF) --install -f;						\
fi
endef

__embtk_parse_configure_opts = $(subst $(embtk_space),"\\n\\t",$(strip $(1)))
define __embtk_print_configure_opts
	$(if $(strip $(1)),
	$(call embtk_echo_blue,"Configure options:\\n\\t$(__embtk_parse_configure_opts)"))
	echo
endef

__embtk_pkg_ildflags	= -L$(embtk_sysroot)/$(LIBDIR)
__embtk_pkg_ildflags	+= -L$(embtk_sysroot)/usr/$(LIBDIR)
define embtk_configure_pkg
	$(if $(EMBTK_BUILDSYS_DEBUG),
		$(call embtk_pinfo,"Configure $(__embtk_pkg_package)..."))
	$(call __embtk_configure_autoreconfpkg,$(1))
	$(Q)test -e $(__embtk_pkg_srcdir)/configure || exit 1
	$(call __embtk_print_configure_opts,$(__embtk_pkg_configureopts))
	$(if $(CONFIG_EMBTK_CLIB_MUSL),$(call __embtk_fixgconfigsfor_pkg,$(1)))
	$(Q)cd $(__embtk_pkg_builddir);						\
	CC=$(TARGETCC_CACHED)							\
	$(if $(CONFIG_EMBTK_GCC_LANGUAGE_CPP),CXX=$(TARGETCXX_CACHED))		\
	AR=$(TARGETAR)								\
	RANLIB=$(TARGETRANLIB)							\
	AS=$(CROSS_COMPILE)as							\
	NM=$(TARGETNM)								\
	STRIP=$(TARGETSTRIP)							\
	OBJDUMP=$(TARGETOBJDUMP)						\
	OBJCOPY=$(TARGETOBJCOPY)						\
	CFLAGS="$(__embtk_pkg_cflags) $(TARGET_CFLAGS)"				\
	CXXFLAGS="$(__embtk_pkg_cxxflags) $(TARGET_CXXFLAGS)"			\
	LDFLAGS="$(__embtk_pkg_ildflags) $(__embtk_pkg_ldflags)"		\
	CPPFLAGS="-I$(embtk_sysroot)/usr/include $(__embtk_pkg_cppflags)"	\
	PKG_CONFIG="$(PKGCONFIG_BIN)"						\
	PKG_CONFIG_PATH="$(EMBTK_PKG_CONFIG_PATH)"				\
	PKG_CONFIG_LIBDIR="$(EMBTK_PKG_CONFIG_LIBDIR)"				\
	ac_cv_func_malloc_0_nonnull=yes						\
	ac_cv_func_realloc_0_nonnull=yes					\
	CONFIG_SHELL=$(CONFIG_EMBTK_SHELL)					\
	$(__embtk_pkg_configureenv) $(__embtk_pkg_scanbuild)			\
	$(CONFIG_EMBTK_SHELL) $(__embtk_pkg_srcdir)/configure			\
	--build=$(HOST_BUILD) --host=$(STRICT_GNU_TARGET)			\
	--target=$(STRICT_GNU_TARGET) --libdir=/usr/$(LIBDIR)			\
	--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-rpath	\
	$(__embtk_pkg_configureopts)
	$(Q)$(call __embtk_setconfigured_pkg,$(1))
	$(Q)$(call __embtk_kill_lt_rpath,$(__embtk_pkg_builddir))
endef

#
# A macro which runs configure script (conpatible with autotools configure)
# for a package for host development machine and sets environment variables
# correctly.
# Usage:
# $(call embtk_configure_hostpkg,PACKAGE)
#
__embtk_hostpkg_rpathldflags	= "-Wl,-rpath,$(embtk_htools)/usr/lib"
__embtk_hostpkg_rpath		= $(strip $(if $(__embtk_pkg_setrpath),		\
					$(__embtk_hostpkg_rpathldflags)))

__embtk_hostpkg_ldflags		= -L$(embtk_htools)/usr/lib $(__embtk_hostpkg_rpath)
__embtk_hostpkg_cppflags	= -I$(embtk_htools)/usr/include
define embtk_configure_hostpkg
	$(if $(EMBTK_BUILDSYS_DEBUG),
	$(call embtk_pinfo,"Configure $(__embtk_pkg_package) for host..."))
	$(call __embtk_configure_autoreconfpkg,$(1))
	$(if $(CONFIG_EMBTK_CLIB_MUSL),$(call __embtk_fixgconfigsfor_pkg,$(1)))
	$(Q)test -e $(__embtk_pkg_srcdir)/configure || exit 1
	$(call __embtk_print_configure_opts,$(__embtk_pkg_configureopts))
	$(Q)cd $(__embtk_pkg_builddir);						\
	CPPFLAGS="$(__embtk_hostpkg_cppflags)"					\
	LDFLAGS="$(__embtk_hostpkg_ldflags)"					\
	PKG_CONFIG="$(PKGCONFIG_BIN)"						\
	PKG_CONFIG_PATH="$(EMBTK_HOST_PKG_CONFIG_PATH)"				\
	$(if $(call __embtk_mk_strcmp,$(PKGV),CCACHE),,CC=$(HOSTCC_CACHED))	\
	$(if $(call __embtk_mk_strcmp,$(PKGV),CCACHE),,CXX=$(HOSTCXX_CACHED))	\
	CONFIG_SHELL=$(CONFIG_EMBTK_SHELL)					\
	$(__embtk_pkg_configureenv)						\
	$(CONFIG_EMBTK_SHELL) $(__embtk_pkg_srcdir)/configure			\
	--build=$(HOST_BUILD) --host=$(HOST_ARCH)				\
	--prefix=$(strip $(if $(__embtk_pkg_prefix),				\
				$(__embtk_pkg_prefix),$(embtk_htools)/usr))	\
	$(__embtk_pkg_configureopts)
	$(Q)$(call __embtk_setconfigured_pkg,$(1))
endef
