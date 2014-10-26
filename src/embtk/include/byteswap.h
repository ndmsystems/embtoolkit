#if defined(__linux__)
#include_next <byteswap.h>
#else
#include <endian.h>
#endif
