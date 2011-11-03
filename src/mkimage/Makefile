CFLAGS		?= -O2
CPPFLAGS	?=
LDFLAGS		?=

build:
	$(CC) -c $(CPPFLAGS) $(CPPFLAGS) crc32.c -o crc32.o
	$(CC) -c $(CPPFLAGS) $(CPPFLAGS) mkimage.c -o mkimage.o
	$(CC) -o $(LDFLAGS) mkimage *.o

clean:
	rm -f mkimage *.o

install:
	install -d $(DESTDIR)/usr/bin
	install -s mkimage $(DESTDIR)/usr/bin
