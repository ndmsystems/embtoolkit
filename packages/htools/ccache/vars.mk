################################################################################
# Embtoolkit
# Copyright(C) 2009-2014 Abdoulaye Walsimou GAYE.
#
# This program is free software; you can distribute it and/or modify it
##
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
# \file         vars.mk
# \brief	variables defined by ccache
# \author       Abdoulaye Walsimou GAYE <awg@embtoolkit.org>
# \date         May 2009
################################################################################

CCACHE_DIR		:= $(EMBTK_ROOT)/.ccache
CCACHE_BIN		:= $(embtk_htools)/usr/bin/ccache

# Variables for use in env
__ccache_clang_cflags	:= $(if $(embtk_hostcc_clang-y),-Qunused-arguments)
__HOSTCC_CACHED		:= $(CCACHE_BIN) $(HOSTCC) $(__ccache_clang_cflags)
HOSTCC_CACHED		:= "$(__HOSTCC_CACHED)"
__HOSTCXX_CACHED	:= $(CCACHE_BIN) $(HOSTCXX) $(__ccache_clang_cflags)
HOSTCXX_CACHED		:= "$(__HOSTCXX_CACHED)"

CROSS_COMPILE_CACHED	:= "$(CCACHE_BIN) $(CROSS_COMPILE)"
TARGETCC_CACHED		:= "$(CCACHE_BIN) $(TARGETCC)"
TARGETCXX_CACHED	:= "$(CCACHE_BIN) $(TARGETCXX)"

TARGETGCC_CACHED	:= "$(CCACHE_BIN) $(TARGETGCC)"
TARGETGCXX_CACHED	:= "$(CCACHE_BIN) $(TARGETGCXX)"

TARGETCLANG_CACHED	:= "$(CCACHE_BIN) $(TARGETCLANG)"
TARGETCLANGXX_CACHED	:= "$(CCACHE_BIN) $(TARGETCLANGXX)"

# Variables for use directly
hostcc_cached		:= $(CCACHE_BIN) $(HOSTCC)
hostcxx_cached		:= $(CCACHE_BIN) $(HOSTCXX)

targetcc_cached		:= $(CCACHE_BIN) $(TARGETCC)
targetcxx_cached	:= $(CCACHE_BIN) $(TARGETCXX)

targetgcc_cached	:= $(CCACHE_BIN) $(TARGETGCC)
targetgcxx_cached	:= $(CCACHE_BIN) $(TARGETGCXX)

targetclang_cached	:= $(CCACHE_BIN) $(TARGETCLANG)
targetclangxx_cached	:= $(CCACHE_BIN) $(TARGETCLANGXX)

export CCACHE_DIR HOSTCC_CACHED HOSTCXX_CACHED TARGETCC_CACHED TARGETCXX_CACHED
