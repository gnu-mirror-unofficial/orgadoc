# Process this file with automake to produce Makefile.in

orgadocdir 	= $(sysconfdir)/orgadoc
dist_orgadoc_DATA= docs/orgadoc.conf
templatesdir 	= $(sysconfdir)/orgadoc/templates
asttpldir	= $(sysconfdir)/orgadoc/templates/ast
dist_asttpl_DATA= templates/ast/comment.tpl templates/ast/document.tpl
htmltpldir	= $(sysconfdir)/orgadoc/templates/html
dist_htmltpl_DATA= ./templates/html/document.tpl ./templates/html/global.tpl \
		   ./templates/html/comment.tpl ./templates/html/link.tpl
cgitpldir	= $(sysconfdir)/orgadoc/templates/cgi
dist_cgitpl_DATA= ./templates/cgi/document.tpl ./templates/cgi/global.tpl   \
		  ./templates/cgi/comment.tpl ./templates/cgi/link.tpl
latextpldir	= $(sysconfdir)/orgadoc/templates/latex
dist_latextpl_DATA= ./templates/latex/document.tpl 			    \
	 	  ./templates/latex/global.tpl ./templates/latex/comment.tpl
bibtextpldir	= $(sysconfdir)/orgadoc/templates/bibtex
dist_bibtextpl_DATA= ./templates/bibtex/document.tpl

exampledir	= $(datadir)/doc/orgadoc/examples
dist_example_DATA= docs/readme.xml

info_TEXINFOS	= docs/orgadoc.texinfo
man_MANS  	= docs/orgadoc.1 docs/orgadoc_cgi.1 		\
		  docs/orgadoc_init_readmes.1			\
		  docs/orgadoc_add_docs.1

SUBDIRS 	= src config utils

EXTRA_DIST 	= 						\
AUTHORS COPYING ChangeLog INSTALL README TODO NEWS		\
./docs/orgadoc.conf ./docs/orgadoc.sgml ./docs/orgadoc_cgi.sgml	\
./docs/orgadoc_init_readmes.sgml ./docs/orgadoc_add_docs.sgml	\
./docs/readme.xml ./templates/ast/document.tpl 			\
./templates/ast/comment.tpl ./templates/html/document.tpl 	\
./templates/html/global.tpl ./templates/html/comment.tpl	\
./templates/html/link.tpl ./templates/latex/document.tpl	\
./templates/latex/global.tpl ./templates/latex/comment.tpl	\
./templates/bibtex/document.tpl ./templates/cgi/comment.tpl	\
./templates/cgi/document.tpl ./templates/cgi/link.tpl		\
./templates/cgi/global.tpl

CLEANFILES      = *~ docs/*.1 config.e docs/manpage.links docs/manpage.refs

SUFFIXES	= .sgml .1

.sgml.1: $<
	@echo "Generating man page $@"
	@if [ -f /usr/bin/docbook2man ]; then                          	\
                cd docs && /usr/bin/docbook2man ../$<;	                \
        else                                                           	\
                /usr/bin/docbook-to-man $< > $@;		 	\
        fi
