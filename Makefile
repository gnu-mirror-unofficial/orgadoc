CC      = gcc
CFLAGS  = -Wall -Wextra -std=c89 -pedantic -I/usr/include/libxml2/
LDFLAGS = -lxml2

SRCS    = src/main.c src/orgadoc_argparse.c src/orgadoc_bibtex_tags.c \
	   src/orgadoc_help.c src/orgadoc_html_tags.c src/orgadoc_json_tags.c \
	   src/orgadoc_latex_tags.c src/orgadoc_text_tags.c src/orgadoc_version.c \
	   src/orgadoc_xml_parser.c

OBJS    = src/main.o src/orgadoc_argparse.o src/orgadoc_bibtex_tags.o \
       src/orgadoc_help.o src/orgadoc_html_tags.o src/orgadoc_json_tags.o \
       src/orgadoc_latex_tags.o src/orgadoc_text_tags.o src/orgadoc_version.o \
       src/orgadoc_xml_parser.o

orgadoc: $(OBJS)
	$(CC) -o $@ $(OBJS) $(CFLAGS) $(LDFLAGS)
	texi2html docs/orgadoc.texi
	texi2html docs/version.texi

install:

.PHONY: clean

clean:
	rm -f orgadoc src/*.o
	rm -f *.html
