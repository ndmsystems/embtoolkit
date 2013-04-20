#!/bin/sh

mips_perror() {
	echo "[CI-BUILD-ERROR] MIPS: $1"
}

cibuild_kconfig=$workspace/cibuild-mips.kconfig
rm -rf $cibuild_kconfig
echo "CONFIG_EMBTK_ARCH_MIPS=y" > $cibuild_kconfig

set_mips_isa() {
	case "$archvariant" in
		mips1|mips2|mips3|mips4|mips32|mips32r2|mips64|mips64r2|octeon)
			echo "CONFIG_EMBTK_ARCH_MIPS_"$(echo $archvariant | tr a-z A-Z)"=y" >> $cibuild_kconfig
			;;
		*)
			mips_perror "Unknown MIPS ISA: $archvariant"
			exit 1
			;;
	esac
}

set_abi() {
	case "$abi" in
		o32|O32)
			echo "CONFIG_EMBTK_ARCH_MIPS_ABI_O32=y" >> $cibuild_kconfig
			;;
		n32|N32)
			echo "CONFIG_EMBTK_ARCH_MIPS_ABI_N32=y" >> $cibuild_kconfig
			;;
		n64|N64)
			echo "CONFIG_EMBTK_ARCH_MIPS_ABI_N64=y" >> $cibuild_kconfig
			;;
		*)
			mips_error "Unknown MIPS abi: $abi"
			exit 1
			;;
	esac
}

set_endian() {
	case "$endian" in
		little|LITTLE)
			echo "CONFIG_EMBTK_ARCH_MIPS_LITTLE_ENDIAN=y" >> $cibuild_kconfig
			;;
		big|BIG)
			echo "CONFIG_EMBTK_ARCH_MIPS_BIG_ENDIAN=y" >> $cibuild_kconfig
			;;
		*)
			mips_perror "Unknown endianness for $archvariant"
			exit 1
			;;
	esac
}

set_float() {
	case "$float" in
		softfloat)
			echo "CONFIG_EMBTK_SOFTFLOAT=y" >> $cibuild_kconfig
			;;
		hardfloat)
			echo "CONFIG_EMBTK_HARDFLOAT=y" >> $cibuild_kconfig
			;;
		*)
			mips_perror "Unknown floating point type $float for $archvariant"
			exit 1
			;;
	esac
}

set_os() {
	case "$os" in
		linux|LINUX)
			echo "CONFIG_EMBTK_OS_LINUX=y" >> $cibuild_kconfig
			;;
		*)
			mips_perror "Unsupported OS $os, please help to support it"
			exit 1
			;;
	esac
}

set_xcompiler() {
	case "$toolchain" in
		gcc|GCC)
			echo "CONFIG_EMBTK_GCC_TOOLCHAIN=y" >> $cibuild_kconfig
			;;
		Clang+llvm)
			echo "CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN=y" >> $cibuild_kconfig
			;;
		*)
			mips_perror "Unsupported cross compiler $toolchain, please help to support it"
			exit 1
			;;
	esac
}

set_clibrary() {
	case "$clibrary" in
		eglibc)
			echo "CONFIG_EMBTK_CLIB_EGLIBC=y" >> $cibuild_kconfig
			;;
		uClibc)
			echo "CONFIG_EMBTK_CLIB_UCLIBC=y" >> $cibuild_kconfig
			;;
		*)
			mips_perror "Unsupported c library $clibrary, please help to support it"
			exit 1
			;;
	esac
}

set_mips_isa
set_abi
set_endian
set_float
set_xcompiler
set_clibrary

cat $cibuild_kconfig >> $workspace/.config && rm -rf $cibuild_kconfig
