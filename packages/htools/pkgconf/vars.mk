#
# PKG_CONFIG_PATH for target packages
#
__EMBTK_PKG_CONFIG_PATH		:= $(embtk_sysroot)/usr/$(LIBDIR)/pkgconfig
__EMBTK_PKG_CONFIG_PATH		+= $(embtk_sysroot)/usr/share/pkgconfig
EMBTK_PKG_CONFIG_PATH		:= $(subst $(embtk_space),:,$(__EMBTK_PKG_CONFIG_PATH))
EMBTK_PKG_CONFIG_LIBDIR		:= $(EMBTK_PKG_CONFIG_PATH)

export PKGCONFIG_BIN EMBTK_PKG_CONFIG_PATH

#
# PKG_CONFIG_PATH for host packages
#
__EMBTK_HOST_PKG_CONFIG_PATH	:= $(embtk_htools)/usr/lib/pkgconfig/
__EMBTK_HOST_PKG_CONFIG_PATH	+= /usr/lib/pkgconfig/ /usr/share/pkgconfig/
__EMBTK_HOST_PKG_CONFIG_PATH	+= /usr/local/lib/pkgconfig/ /usr/local/share/pkgconfig/
__EMBTK_HOST_PKG_CONFIG_PATH	+= $(dir $(shell find /usr/lib -type f -name '*.pc' 2>/dev/null))
__EMBTK_HOST_PKG_CONFIG_PATH	+= $(dir $(shell find /usr/local/lib -type f -name '*.pc' 2>/dev/null))
EMBTK_HOST_PKG_CONFIG_PATH	:= $(subst $(embtk_space),:,$(sort $(__EMBTK_HOST_PKG_CONFIG_PATH)))

export EMBTK_HOST_PKG_CONFIG_PATH
