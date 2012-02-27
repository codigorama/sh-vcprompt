.POSIX:

name          = sh-vcprompt
version      ?= v0.1.0
release      ?= "`date +'%F %T %z'`"

prefix       ?= /usr/local
bindir       ?= $(prefix)/bin
libdir       ?= $(prefix)/lib/$(name)
sharerootdir ?= $(prefix)/share
sharedir     ?= $(sharerootdir)/$(name)
docdir       ?= $(sharerootdir)/doc/$(name)

testdir       = test
directories   = $(prefix) $(bindir) $(libdir) $(sharerootdir) $(sharedir) $(docdir)

program       = shvcp
sources       = vcs.sh git.sh hg.sh

executables   = $(addprefix $(bindir)/,$(program))
libraries     = $(addprefix $(libdir)/,$(sources))
documents     = $(addprefix $(docdir)/,README.html)

errors        = test.err

munge         = m4 -D_NAME=$(name) -D_VERSION=$(version) -D_RELEASE=$(release) \
                   -D_PREFIX=$(prefix) -D_BINDIR=$(bindir) -D_LIBDIR=$(libdir) \
                   -D_PROGRAM=$(program)

all:: build

.SUFFIXES: .m4 .sh .err .md .html

.m4:
	$(munge) $(<) > $(@)
	chmod a+x $(@)

.sh.err: 
	sh -x $(<) 2> $(@)

.md.html:
	markdown $(<) > $(@)

clean:
	rm -rf *.err
	rm -rf *.html
	rm -rf $(testdir)
	rm -rf $(program)

check: $(errors)

doc: README.html

build: $(program)

install: build install-dirs install-bins install-libs install-docs

uninstall: uninstall-bins uninstall-libs uninstall-docs

install-dirs: $(directories)

install-bins: $(executables)

uninstall-bins:
	rm -f $(executables)

install-libs: $(libraries)

uninstall-libs:
	rm -f $(libraries)

install-docs: doc $(documents)

uninstall-docs:
	rm -f $(documents)

$(executables) $(libraries) $(documents):
	cp $(@F) $(@)

$(directories):
	mkdir -p $(@)

