bin_SCRIPTS 	= orgadoc_add_docs orgadoc_init_readmes
EXTRA_DIST	= orgadoc_add_docs.src orgadoc_init_readmes.src

SUFFIXES	= .src

.src:
	cat $< | sed "s/\[VERSION\]/@VERSION@/" > $@
	chmod +x $@

CLEANFILES 	= *~ orgadoc_add_docs orgadoc_init_readmes