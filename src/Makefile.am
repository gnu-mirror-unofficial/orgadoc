# Process this file with automake to produce Makefile.in

EXTRA_DIST 		= 

bin_PROGRAMS 		= orgadoc orgadoc_cgi

VARS			= EXPAT=@EXPAT@ GOBO=@GOBO@ 		\
			  GOBO_EIFFEL=@GOBO_EIFFEL@		\
			  CURRENT_DIR=@CURRENT_DIR@
DEBUG			= @DEBUG@

include Makefile.sources

orgadoc: $(ESRC)
	$(VARS) gexace --define="GOBO_XML_EXPAT @DEBUG@" 	\
	  --system=@GOBO_EIFFEL@ orgadoc.xace
	$(VARS) $(EC) ./@GOBO_EIFFEL@.ace

orgadoc_cgi: $(ESRC)
	$(VARS) gexace --define="GOBO_XML_EXPAT @DEBUG@" 	\
	  --system=@GOBO_EIFFEL@ cgi.xace
	$(VARS) $(EC) ./@GOBO_EIFFEL@.ace

.l.e:
	gelex $<

.y.e:
	geyacc -t TOKENS -o $@ $<

noinst_PKGDATA 		= Makefile.e_sources orgadoc.xace cgi.xace $(ESRC)

CLEANFILES      	= *~ *.c *.h *.id scanner.e parser.e
