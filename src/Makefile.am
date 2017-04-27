# This file is part of GNU OrgaDoc.
#
# GNU OrgaDoc is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3
# of the License, or (at your option) any later version.
#
# GNU OrgaDoc is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.

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

CLEANFILES = *~ *.c *.h *.id scanner.e parser.e params.e tokens.e *.ace	\
	     orgadoc orgadoc_cgi
