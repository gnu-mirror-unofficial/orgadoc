CC      = gcc
CFLAGS  = `xml2-config --cflags --libs` -Wall -Wextra
LDFLAGS =

SRCS = src/main.c src/orgadoc_argparse.c src/orgadoc_bibtex_tags.c \
	   src/orgadoc_help.c src/orgadoc_html_tags.c src/orgadoc_json_tags.c \
	   src/orgadoc_latex_tags.c src/orgadoc_text_tags.c src/orgadoc_version.c \
	   src/orgadoc_xml_parser.c
	   
OBJS = src/main.o src/orgadoc_argparse.o src/orgadoc_bibtex_tags.o \
       src/orgadoc_help.o src/orgadoc_html_tags.o src/orgadoc_json_tags.o \
       src/orgadoc_latex_tags.o src/orgadoc_text_tags.o src/orgadoc_version.o \
       src/orgadoc_xml_parser.o

orgadoc: $(OBJS)
	$(CC) -o $@ $(OBJS) $(CFLAGS) $(LDFLAGS)
	
docs:

.PHONY: clean

clean:
	rm -f orgadoc src/*.o
