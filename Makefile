##
## Makefile
##  
## Made by Julien LEMOINE
## Login   <speedblue@debian.org>
##
## Started on  Sun Apr 14 05:40:53 2002 Julien LEMOINE
## Last update Thu Aug  1 00:58:42 2002 Julien LEMOINE
## 

SmartEiffel	= /usr/lib/smarteiffel/sys/system.se
GOBO		= /usr/lib/gobo
SE		= se-compile -no_warning
XACE		= $(shell which gexace || echo "/usr/bin/gexace")
CURRENT_DIR	= $(shell pwd)
GELEX		= $(shell which gelex || echo "/usr/bin/gelex")
GEYACC		= $(shell which geyacc || echo "/usr/bin/geyacc")
ETC		= $(DESTDIR)/etc
PREFIX		= $(DESTDIR)/usr
XACE_FILES	= cgi orgadoc

################ GENERAL RULES ################
all: ace no_debug binary
debug: ace binary
re: clean all

################ DISABLE DEBUG ################
no_debug:
	for file in $(XACE_FILES); do 					\
	  sed s/assertion\ \(no\)/assertion\ \(boost\)\ debug\ \(no\)/ 	\
	  $$file.ace > tmp; cp tmp $$file.ace; rm tmp;			\
	done

################ GENERATE se.ace ################
ace: test_xace
	for file in $(XACE_FILES); do	\
	  SmartEiffel=$(SmartEiffel)	\
	  GOBO=$(GOBO) 			\
	  CURRENT_DIR=$(CURRENT_DIR)	\
          EXPAT=/usr			\
	  $(XACE) --define="GOBO_XML_EXPAT" --system=se $$file.xace; \
	  mv se.ace $$file.ace; 	\
	done

################ FLEX/BISON ################
scanner: test_gelex
	$(GELEX) scanner.l

parser: test_geyacc
	$(GEYACC) -t TOKENS -o parser.e parser.y

################ BINARY ################
binary: scanner parser
	for file in $(XACE_FILES); do	\
	  SmartEiffel=$(SmartEiffel)	\
	  GOBO=$(GOBO) 			\
	  CURRENT_DIR=$(CURRENT_DIR)	\
          EXPAT=/usr                   	\
	  $(SE) ./$$file.ace;		\
	done

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
		echo "install gobo on Debian Gnu/Linux)";		\
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
	rm -rf *~ *.o *.c *.id *.h orgadoc orgadoc_cgi			\
	cecil.se se.ace *.1 manpage.* scanner.e parser.e tokens.e
	for file in $(XACE_FILES); do rm -f $$file.ace; done

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
		mkdir $(ETC)/orgadoc/templates/cgi;			\
		cp templates/html/*.tpl $(ETC)/orgadoc/templates/html;	\
		cp templates/bibtex/*.tpl $(ETC)/orgadoc/templates/bibtex;\
		cp templates/ast/*.tpl $(ETC)/orgadoc/templates/ast;	\
		cp templates/latex/*.tpl $(ETC)/orgadoc/templates/latex;\
		cp templates/cgi/*.tpl $(ETC)/orgadoc/templates/cgi;	\
		cp orgadoc $(PREFIX)/bin/;				\
	fi
