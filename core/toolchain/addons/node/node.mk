NODE_HOST_NAME		:= node
NODE_HOST_VERSION	:= $(call embtk_get_pkgversion,node_host)
NODE_HOST_SITE		:= http://nodejs.org/dist/v$(NODE_HOST_VERSION)
NODE_HOST_PACKAGE	:= node-v$(NODE_HOST_VERSION).tar.gz
NODE_HOST_SRC_DIR	:= $(embtk_toolsb)/node-v$(NODE_HOST_VERSION)
NODE_HOST_BUILD_DIR	:= $(embtk_toolsb)/node-v$(NODE_HOST_VERSION)
NODE_HOST_DESTDIR	:= $(embtk_tools)

ifeq ($(CONFIG_EMBTK_NODE_HOST_STATIC),y)
  NODE_HOST_CONFIGURE_OPTS := --fully-static
endif

define embtk_install_node_host
	$(call embtk_makeinstall_hostpkg,node_host)
endef

define embtk_beforeinstall_node_host
	cd $(NODE_HOST_BUILD_DIR); 					\
	$(CONFIG_SHELL) $(NODE_HOST_SRC_DIR)/configure --prefix=/	\
		$(NODE_HOST_CONFIGURE_OPTS)
endef
