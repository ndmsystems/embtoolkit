#!/bin/sh

arm_perror() {
	echo "[CI-BUILD-ERROR] ARM: $1"
}

cibuild_kconfig=$workspace/cibuild-arm.kconfig
rm -rf $cibuild_kconfig
 
set_arch_family() {
	case "$archvariant" in
		arm9tdmi|arm920t|arm922t)
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_ARM9TDMI=y" >> $cibuild_kconfig
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_ARM9TDMI_"$(echo $archvariant | tr a-z A-Z)"=y" >> $cibuild_kconfig
			;;
		arm926ej-s)
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_ARM9E=y" >> $cibuild_kconfig
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_ARM9E_"$(echo $archvariant | tr a-z A-Z)"=y" >> $cibuild_kconfig
			;;
		arm1020e|arm1022e|arm1026ej-s)
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_ARM10E=y" >> $cibuild_kconfig
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_ARM10E_"$(echo $archvariant | tr a-z A-Z)"=y" >> $cibuild_kconfig
			;;
		xscale)
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_XSCALE=y" >> $cibuild_kconfig
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_XSCALE_"$(echo $archvariant | tr a-z A-Z)"=y" >> $cibuild_kconfig
			;;
		arm1136j-s|arm1136jf-s|arm1176jz-s|arm1176jzf-s|mpcore)
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_ARM11=y" >> $cibuild_kconfig
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_ARM11_"$(echo $archvariant | tr a-z A-Z)"=y" >> $cibuild_kconfig
			;;
		cortex-a7|cortex-a8|cortex-a9|cortex-a15)
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_CORTEX=y" >> $cibuild_kconfig
			echo "CONFIG_EMBTK_ARCH_ARM_FAMILY_CORTEX_"$(echo $archvariant | tr a-z A-Z)"=y" >> $cibuild_kconfig
			;;
		*)
			arm_perror "Unknown ARM architecture family for $archvariant"
			exit 1
			;;
	esac
}

set_endian() {
	case "$endian" in
		LITTLE)
			echo "CONFIG_EMBTK_ARCH_ARM_LITTLE_ENDIAN=y" >> $cibuild_kconfig
			;;
		BIG)
			echo "CONFIG_EMBTK_ARCH_ARM_LITTLE_ENDIAN=y" >> $cibuild_kconfig
			;;
		*)
			arm_perror "Unknown ARM endianness for $archvariant"
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
			arm_perror "Unknown ARM floating point type $float for $archvariant"
			exit 1
			;;
	esac
}

set_os() {
	case "$os" in
		LINUX)
			echo "CONFIG_EMBTK_OS_LINUX=y" >> $cibuild_kconfig
			;;
		*)
			arm_perror "Unsupported OS $os for ARM, please help to support it"
			exit 1
			;;
	esac
}

set_xcompiler() {
	case "$toolchain" in
		GCC)
			echo "CONFIG_EMBTK_GCC_TOOLCHAIN=y" >> $cibuild_kconfig
			;;
		Clang+llvm)
			echo "CONFIG_EMBTK_LLVM_ONLY_TOOLCHAIN=y" >> $cibuild_kconfig
			;;
		*)
			arm_perror "Unsupported cross compiler $toolchain for ARM, please help to support it"
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
			arm_perror "Unsupported c library $clibrary for ARM, please help to support it"
			exit 1
			;;
	esac
}

set_os
set_endian
set_arch_family
set_float
set_xcompiler
set_clibrary

cat $cibuild_kconfig >> $workspace/.config && rm -rf $cibuild_kconfig
