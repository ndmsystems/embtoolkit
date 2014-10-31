#ifndef __elf_compat_h
#define __elf_compat_h

#if defined(__APPLE__)
#include <libelf.h>
#define R_386_32	1
#define R_386_PC32	2
#define R_ARM_PC24	1
#define R_ARM_ABS32	2
#define R_MIPS_32	2
#define R_MIPS_26	4
#define R_MIPS_HI16	5
#define R_MIPS_LO16	6
#else
#include_next <elf.h>
#endif

#endif
