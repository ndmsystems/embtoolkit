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
# Now generating .config
#

if [ ! "x$downloaddir" = "x" ]; then
	if [ -d $downloaddir ]; then
		echo "CONFIG_EMBTK_DOWNLOAD_DIR=\"$downloaddir\"" >> $workspace/.config
		rm -rf $downloaddir/*.patch
	fi
fi
cat $workspace/defconfigs/common.kconfig >> $workspace/.config

pinfo "Starting toolchain build"
cd $workspace && $xmakecmd olddefconfig && $xmakecmd
