#!/bin/sh

# NOTE: this script only accepts long options

perror() {
	echo "[CI-BUILD-ERROR]  : $1"
}

pwarning() {
	echo "[CI-BUILD-WARNING]: $1"
}

pinfo() {
	echo "[CI-BUILD-INFO]   : $1"
}

set_os() {
	local x_os=$1
	local x_cibuild_kconfig=$2
	case "$x_os" in
		linux|LINUX)
			echo "CONFIG_EMBTK_OS_LINUX=y" >> $x_cibuild_kconfig
			;;
		*)
			perror "Unsupported OS $x_os , please help to support it"
			exit 1
			;;
	esac
}

set_xcompiler() {
	local x_toolchain=$1
	local x_cibuild_kconfig=$2
	case "$x_toolchain" in
		gcc|GCC)
			echo "CONFIG_EMBTK_GCC_TOOLCHAIN=y" >> $x_cibuild_kconfig
			;;
		Clang+llvm)
			echo "CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN=y" >> $x_cibuild_kconfig
			;;
		*)
			perror "Unsupported cross compiler $x_toolchain , please help to support it"
			exit 1
			;;
	esac
}

set_clibrary() {
	local x_clibrary=$1
	local x_cibuild_kconfig=$2
	case "$x_clibrary" in
		eglibc)
			echo "CONFIG_EMBTK_CLIB_EGLIBC=y" >> $x_cibuild_kconfig
			;;
		uClibc)
			echo "CONFIG_EMBTK_CLIB_UCLIBC=y" >> $x_cibuild_kconfig
			;;
		glibc)
			echo "CONFIG_EMBTK_CLIB_GLIBC=y" >> $x_cibuild_kconfig
			;;
		musl)
			echo "CONFIG_EMBTK_CLIB_MUSL=y" >> $x_cibuild_kconfig
			;;
		*)
			perror "Unsupported c library $x_clibrary , please help to support it"
			exit 1
			;;
	esac
}

options=$(echo $* | sed 's/=/ /g')
set -- $options

pinfo "Parsing parameters"

while true; do
	case "$1" in
		--abi)
			abi=$2; shift 2;;
		--arch)
			arch=$2; shift 2;;
		--archvariant)
			archvariant=$2; shift 2;;
		--clibrary)
			clibrary=$2; shift 2;;
		--endian)
			endian=$2; shift 2;;
		--float)
			float=$2; shift 2;;
		--os)
			os=$2; shift 2;;
		--toolchain)
			toolchain=$2; shift 2;;
		--workspace)
			workspace=$2; shift 2;;
		--downloaddir)
			downloaddir=$2; shift 2;;
		--makecmd)
			makecmd=$2; shift 2;;
		--)
			shift; break ;;
		*)
			break;;
	esac
done

#
# Basic checks
#
if [ "x$workspace" = "x" ]; then
	perror "Workspace not specified"
	exit 1
fi

if [ "x$arch" = "x" ]; then
	perror "Architecture not specified"
	exit 1
fi

if [ ! -d $workspace/defconfigs/$arch ]; then
	perror "Architecture $arch seems not be supported"
	exit 1
fi

if [ ! -e $workspace/defconfigs/$arch/$arch-ci-build.sh ]; then
	perror "Architecture $arch does not provide specifics"
	exit 1
fi

xmakecmd=""
if [ "x$makecmd" = "x" ]; then
	xmakecmd=make
else
	xmakecmd=$makecmd
fi

#
# Clean up old build
#
pinfo "Clean up old build"
cd $workspace && $xmakecmd clean
rm -rf $workspace/.config
rm -rf $workspace/.config.old
rm -rf $workspace/dl/*.patch
rm -rf $workspace/src/toolchain/*.git
rm -rf $workspace/src/toolchain/*.svn
rm -rf $workspace/generated/*

pinfo "Generating .config file"
#
# arch script
#
. $workspace/defconfigs/$arch/$arch-ci-build.sh

#
# toolchain and OS
#
set_os $os $workspace/.config
set_xcompiler $toolchain $workspace/.config
set_clibrary $clibrary $workspace/.config

#
# Now generating final .config
#

if [ ! "x$downloaddir" = "x" ]; then
	if [ -d $downloaddir ]; then
		echo "CONFIG_EMBTK_DOWNLOAD_DIR=\"$downloaddir\"" >> $workspace/.config
		rm -rf $downloaddir/*.patch
	fi
fi
cat $workspace/defconfigs/common.kconfig >> $workspace/.config

pinfo "Starting toolchain build"
set --
cd $workspace && $xmakecmd olddefconfig && $xmakecmd
