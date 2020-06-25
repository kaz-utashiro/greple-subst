all: \
	jtca-katakana-guide-3.dict \
	jtf-style-guide-3.dict \
	microsoft.dict \
	sccc2.dict

.SUFFIXES: .pl .dict

.pl.dict:
	perl $< > $@
