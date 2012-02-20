# Works for installing locally or creating a Debian package.
# make install			  # Locally.
# make install DEBIANDIR=$(CURDIR)	  # From debian rules.

# For Debian packages.
ifdef DEBIANDIR
	VIRTUALDIR=$(DEBIANDIR)/debian/$(DEBIANPACKAGE)
else
	DEBIANDIR=
	VIRTUALDIR=
endif


KCTL_LIB=kctllib/*.py
KCTL_CMDS=kctlcmd/*.py
KCTL=main.py

install-kctllib:

# Copy the kctl library.
	mkdir -p $(VIRTUALDIR)/usr/share/python-support/kctllib/kctllib
	for i in $(KCTL_LIB); do \
		install -m644 $$i \
			$(VIRTUALDIR)/usr/share/python-support/kctllib/kctllib;\
	done

# Update python modules if we're not building a debian package
	if [ "$(DEBIANDIR)" = "" ]; then \
		cp -a debian/pyversions $(VIRTUALDIR)/usr/share/python-support/kctllib/.version; \
		update-python-modules kctllib; \
	fi


install-kctllib-nodb:

# Copy the kctl nodb library.
	mkdir -p $(VIRTUALDIR)/usr/share/python-support/kctllib-nodb/kctllib-nodb
	for i in $(KCTL_LIB); do \
		install -m644 $$i \
			$(VIRTUALDIR)/usr/share/python-support/kctllib-nodb/kctllib-nodb;\
	done

# Update python modules if we're not building a debian package
	if [ "$(DEBIANDIR)" = "" ]; then \
		cp -a debian/pyversions $(VIRTUALDIR)/usr/share/python-support/kctllib-nodb/.version; \
		update-python-modules kctllib-nodb; \
	fi


install-kctl:

# Copy the kctl commands
	mkdir -p $(VIRTUALDIR)/usr/share/python-support/kctlcmd/kctlcmd
	for i in $(KCTL_CMDS); do \
		install -m644 $$i \
			$(VIRTUALDIR)/usr/share/python-support/kctlcmd/kctlcmd;\
	done

# Update python modules if we're not building a debian package
	if [ "$(DEBIANDIR)" = "" ]; then \
		cp -a debian/pyversions $(VIRTUALDIR)/usr/share/python-support/kctlcmd/.version; \
		update-python-modules kctlcmd; \
	fi

# Copy the 'binaries'
	mkdir -p $(VIRTUALDIR)/usr/bin
	install -m755 main.py $(VIRTUALDIR)/usr/bin/kctl
	install -m755 kctlimport $(VIRTUALDIR)/usr/bin/kctlimport


install:

# Recall this makefile for all packages to install.
	make install-kctllib DEBIANDIR=$(DEBIANDIR) DEBIANPACKAGE=kctllib
	make install-kctllib-nodb DEBIANDIR=$(DEBIANDIR) DEBIANPACKAGE=kctllib-nodb
	make install-kctl DEBIANDIR=$(DEBIANDIR) DEBIANPACKAGE=kctl


