#!/bin/sh

# NOTE: this script only accepts long options

perror() {
	echo "[IC-BUILD-ERROR]  : $1"
}

pwarning() {
	echo "[IC-BUILD-WARNING]: $1"
}

pinfo() {
	echo "[IC-BUILD-INFO]   : $1"
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

if [ ! -e $workspace/defconfigs/$arch/$arch-ic-build.sh ]; then
	perror "Architecture $arch does not provide specifics"
	exit 1
fi
cd $workspace && rm -rf .config .config.old && gmake clean

#
# arch script
#
. $workspace/defconfigs/$arch/$arch-ic-build.sh

#
# Now generating .config
#

cat $workspace/defconfigs/common.kconfig >> $workspace/.config
cd $workspace && rm -rf $workspace/generated/* && gmake olddefconfig && gmake
