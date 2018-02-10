CC=gcc
CFLAGS= `xml2-config --cflags --libs` -Wall -Wextra
SOURCES = *.c
SOURCEDIR =./src/
DOCSDIR = ./docs/

orgadoc:
	gcc -o $@ $^ $(SOURCEDIR)$(SOURCES) $(CFLAGS)
	
docs:

.PHONY: clean

clean:
	rm -f orgadoc
