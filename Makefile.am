# Process this file with automake to produce Makefile.in

orgadocdir 	= $(sysconfdir)/orgadoc
orgadoc_DATA	= docs/orgadoc.conf
templatesdir 	= $(sysconfdir)/orgadoc/templates
asttpldir	= $(sysconfdir)/orgadoc/templates/ast
asttpl_DATA	= templates/ast/comment.tpl templates/ast/document.tpl
htmltpldir	= $(sysconfdir)/orgadoc/templates/html
htmltpl_DATA	= ./templates/html/document.tpl ./templates/html/global.tpl \
		  ./templates/html/comment.tpl ./templates/html/link.tpl
cgitpldir	= $(sysconfdir)/orgadoc/templates/cgi
cgitpl_DATA	= ./templates/cgi/document.tpl ./templates/cgi/global.tpl   \
		  ./templates/cgi/comment.tpl ./templates/cgi/link.tpl
latextpldir	= $(sysconfdir)/orgadoc/templates/latex
latextpl_DATA	= ./templates/latex/document.tpl 			    \
	 	  ./templates/latex/global.tpl ./templates/latex/comment.tpl
bibtextpldir	= $(sysconfdir)/orgadoc/templates/bibtex
bibtextpl_DATA	= ./templates/bibtex/document.tpl

exampledir	= $(datadir)/doc/orgadoc/examples
example_DATA  	= docs/readme.xml

man_MANS  	= orgadoc.1

SUBDIRS 	= src config

EXTRA_DIST 	= 						\
AUTHORS COPYING ChangeLog INSTALL README TODO NEWS		\
./docs/orgadoc.conf ./docs/orgadoc.sgml				\
./docs/readme.xml ./templates/ast/document.tpl 			\
./templates/ast/comment.tpl ./templates/html/document.tpl 	\
./templates/html/global.tpl ./templates/html/comment.tpl	\
./templates/html/link.tpl ./templates/latex/document.tpl	\
./templates/latex/global.tpl ./templates/latex/comment.tpl	\
./templates/bibtex/document.tpl ./templates/cgi/comment.tpl	\
./templates/cgi/document.tpl ./templates/cgi/link.tpl		\
./templates/cgi/global.tpl

CLEANFILES      = *~ orgadoc.1

orgadoc.1: docs/orgadoc.sgml
	@if [ -f /usr/bin/docbook2man ]; then                          	\
                /usr/bin/docbook2man docs/orgadoc.sgml;                	\
        else                                                           	\
                /usr/bin/docbook-to-man docs/orgadoc.sgml > orgadoc.1; 	\
        fi
