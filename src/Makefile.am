# Process this file with automake to produce Makefile.in

include Makefile.sources

EXTRA_DIST		= $(ESRC) Makefile.sources orgadoc.xace cgi.xace
bin_PROGRAMS 		= orgadoc orgadoc_cgi

VARS			= EXPAT=@EXPAT@ GOBO=@GOBO@ 		\
			  GOBO_EIFFEL=@GOBO_EIFFEL@		\
			  CURRENT_DIR=@CURRENT_DIR@
orgadoc_SOURCES		=
orgadoc_cgi_SOURCES	=

orgadoc: $(ESRC)
	$(VARS) gexace --define="GOBO_XML_EXPAT @DEBUG@" 	\
	  --system=@GOBO_EIFFEL@ orgadoc.xace
	$(VARS) $(EC) ./@GOBO_EIFFEL@.ace

orgadoc_cgi: $(ESRC)
	$(VARS) gexace --define="GOBO_XML_EXPAT @DEBUG@" 	\
	  --system=@GOBO_EIFFEL@ cgi.xace
	$(VARS) $(EC) ./@GOBO_EIFFEL@.ace

SUFFIXES=.e .l .y .ge

.l.e:
	gelex $<

.y.e:
	geyacc -t TOKENS -o $@ $<
.ge.e:
	gepp -D@GOBO_EIFFEL@ $< $@

CLEANFILES      	= *~ *.c *.h *.id scanner.e parser.e params.e
