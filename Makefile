##
## Makefile
##  
## Made by Julien LEMOINE
## Login   <speedblue@debian.org>
##
## Started on  Sun Apr 14 05:40:53 2002 Julien LEMOINE
## Last update Sat Jul 27 02:06:48 2002 Julien LEMOINE
## 

SmallEiffel	= /usr/lib/smalleiffel
GOBO		= /usr/lib/gobo
UCSTRING	= /usr/lib/ucstring
EXML		= /usr/lib/exml
SE		= se-compile -no_warning
XACE		= $(shell which xace || echo "/usr/bin/xace")
CURRENT_DIR	= $(shell pwd)
GELEX		= $(shell which gelex || echo "/usr/bin/gelex")
GEYACC		= $(shell which geyacc || echo "/usr/bin/geyacc")
ETC		= $(DESTDIR)/etc
PREFIX		= $(DESTDIR)/usr

################ GENERAL RULES ################
all: ace no_debug binary
debug: ace binary
re: clean all

################ DISABLE DEBUG ################
no_debug:
	sed s/assertion\ \(no\)/assertion\ \(boost\)\ debug\ \(no\)/ se.ace > tmp
	cp tmp se.ace
	rm tmp

################ GENERATE se.ace ################
ace: test_xace
	EXML=$(EXML)			\
	SmallEiffel=$(SmallEiffel)	\
	UCSTRING=$(UCSTRING)		\
	GOBO=$(GOBO) 			\
	CURRENT_DIR=$(CURRENT_DIR)	\
	$(XACE) --build --se orgadoc.xace

################ FLEX/BISON ################
scanner: test_gelex
	$(GELEX) scanner.l

parser: test_geyacc
	$(GEYACC) -t TOKENS -o parser.e parser.y

################ BINARY ################
binary: scanner parser
	EXML=$(EXML)			\
	SmallEiffel=$(SmallEiffel)	\
	UCSTRING=$(UCSTRING)		\
	GOBO=$(GOBO) 			\
	CURRENT_DIR=$(CURRENT_DIR)	\
	$(SE) ./se.ace

################ GENERATE DOCUMENTATIONS ################
doc:
	@if [ -f /usr/bin/docbook2man ]; then				\
		/usr/bin/docbook2man orgadoc.sgml;			\
	else								\
		/usr/bin/docbook-to-man orgadoc.sgml > orgadoc.1;	\
	fi

################ TESTS ################
test_xace:
	@if ! [ -f $(XACE) ]; then					\
		echo -n "Error : You Need to install xace (apt-get ";	\
		echo "install exml-util on Debian Gnu/Linux)";		\
		exit 1;							\
	fi

test_gelex:
	@if ! [ -f $(GELEX) ]; then					\
		echo -n "Error : You Need to install gelex (apt-get ";	\
		echo "install gobo on Debian Gnu/Linux)";		\
		exit 1;							\
	fi

test_geyacc:
	@if ! [ -f $(GEYACC) ]; then					\
		echo -n "Error : You Need to install geyacc (apt-get ";	\
		echo "install gobo on Debian Gnu/Linux)";		\
		exit 1;							\
	fi

################ CLEAN ################
clean:
	rm -rf *~ *.o *.c *.id *.h orgadoc				\
	cecil.se se.ace *.1 manpage.* scanner.e parser.e tokens.e

################ INSTALL ################
install: 
	@if ! [ -d /etc/orgadoc ]; then					\
		mkdir $(ETC)/orgadoc;					\
		cp orgadoc.conf $(ETC)/orgadoc;				\
		mkdir $(ETC)/orgadoc/templates;				\
		mkdir $(ETC)/orgadoc/templates/html;			\
		mkdir $(ETC)/orgadoc/templates/latex;			\
		mkdir $(ETC)/orgadoc/templates/ast;			\
		mkdir $(ETC)/orgadoc/templates/bibtex;			\
		cp templates/html/*.tpl $(ETC)/orgadoc/templates/html;	\
		cp templates/bibtex/*.tpl $(ETC)/orgadoc/templates/bibtex;\
		cp templates/ast/*.tpl $(ETC)/orgadoc/templates/ast;	\
		cp templates/latex/*.tpl $(ETC)/orgadoc/templates/latex;\
		cp orgadoc $(PREFIX)/bin/;				\
	fi
