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
# \file         boost.mk
# \brief	boost.mk of Embtoolkit
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2014
################################################################################

BOOST_NAME		:= boost
BOOST_VERSION		:= $(call embtk_get_pkgversion,boost)
BOOST_SITE		:= http://downloads.sourceforge.net/project/boost/boost/$(subst _,.,$(BOOST_VERSION))
BOOST_PACKAGE		:= boost_$(BOOST_VERSION).tar.bz2
BOOST_SRC_DIR		:= $(embtk_pkgb)/boost_$(BOOST_VERSION)
BOOST_BUILD_DIR		:= $(embtk_pkgb)/boost_$(BOOST_VERSION)

BOOST_INCLUDES		:= boost
BOOST_LIBS		:= libboost_*
BOOST_CFLAGS		:= $(TARGET_CXXFLAGS)
BOOST_CPPFLAGS		:=
BOOST_CXXFLAGS		:= $(TARGET_CXXFLAGS)
BOOST_LDFLAGS		:= -L$(embtk_sysroot)/$(LIBDIR)
BOOST_LDFLAGS		+= -L$(embtk_sysroot)/usr/$(LIBDIR)

BOOST_CONFIGURE_OPTS	:= $(if $(CONFIG_EMBTK_BOOST_WITH_ICU),--with-icu,--without-icu)
BOOST_CONFIGURE_OPTS	+= --with-toolset=gcc

BOOST_MAKE_OPTS		:= $(if $(CONFIG_EMBTK_BOOST_WITH_ATOMIC),,--without-atomic)
BOOST_MAKE_OPTS		+= $(if $(CONFIG_EMBTK_BOOST_WITH_COROUTINE),,--without-coroutine)
BOOST_MAKE_OPTS		+= $(if $(CONFIG_EMBTK_BOOST_WITH_LOG),,--without-log)
BOOST_MAKE_OPTS		+= --without-python
BOOST_MAKE_OPTS		+= -q variant=release
BOOST_MAKE_OPTS		+= link=shared runtime-link=shared
BOOST_MAKE_OPTS		+= threading=multi toolset=gcc
ifeq ($(CONFIG_EMBTK_CLIB_UCLIBC),y)
BOOST_MAKE_OPTS		+= boost.locale.posix=off
endif

BOOST_DEPS-$(CONFIG_EMBTK_BOOST_WITH_ICU) := icu_install
BOOST_DEPS	:= zlib_install bzip2_install gettext_install $(BOOST_DEPS-y)

# FIXME: consider using clang++ when libc++ will be fully integrated
embtk_boost_cxx		= using gcc : $(shell $(TARGETGCC) -dumpversion) : $(TARGETGCXX_CACHED)
embtk_boost_flags	:= <compileflags>\"$(BOOST_CXXFLAGS)\"
embtk_boost_flags	+= <linkflags>\"$(BOOST_LDFLAGS)\"
embtk_boost_userjam	:= $(BOOST_SRC_DIR)/user-config.jam

define embtk_configure_boost
	cd $(BOOST_SRC_DIR)/tools/build/v2/engine/;				\
	./build.sh $(notdir $(HOSTCC))
	for f in $(BOOST_SRC_DIR)/tools/build/v2/engine/bin.*/*; do		\
		cp $$f $(BOOST_SRC_DIR);					\
	done
	echo "$(embtk_boost_cxx) : $(embtk_boost_flags) ;"			\
		> $(embtk_boost_userjam)
	echo "" >> $(embtk_boost_userjam)
endef

define pembtk_install_boost
	$(call __embtk_preinstall_pkg,boost)
	$(embtk_configure_boost)
	cd $(BOOST_SRC_DIR); ./b2 install					\
		--user-config=$(embtk_boost_userjam)				\
		--prefix=$(embtk_sysroot)/usr					\
		$(BOOST_MAKE_OPTS)
	$(call __embtk_postinstall_pkg,boost)
endef

define embtk_install_boost
	$(if $(call __embtk_pkg_runrecipe-y,boost),$(pembtk_install_boost))
endef
