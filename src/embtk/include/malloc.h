#ifndef __malloc_compat_h
#define __malloc_compat_h

#if defined(__APPLE__)
#include <stdlib.h>
#else
#include_next <malloc.h>
#endif

#endif