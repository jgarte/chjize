
# Backspace is being processed differently on Cygwin compared to
# Linux, this is trying to abstract it away:
BS=$(shell bin/BS)

STATIC_TARGETS=.bs .targets .gitignore help clean

.bs:
	bin/gen-BS '\\no'

.targets: Makefile
	bin/make-targets $(STATIC_TARGETS) < Makefile > .targets

.gitignore: .targets
	bin/make-gitignore

help: .targets .gitignore
	@echo "Usage: make <target>"
	@echo
	@echo "  Normal targets: "
	@perl -we 'print map { chomp; "    $$_\n" } <STDIN>' < .targets
	@echo
	@echo "  Special targets: "
	@echo "    clean        remove the time stamps for the above targets"
	@echo "    .gitignore   rebuild .gitignore"
	@echo "    help         this help text (includes making .gitignore)"

clean: .targets
	xargs rm -f < .targets


# Targets that are automatically listed in .targets

key:
	bin/chjize key

perhaps_aptupdate:
	bin/chjize perhaps_aptupdate

debian_upgrade: perhaps_aptupdate
	bin/chjize debian_upgrade

urxvt: perhaps_aptupdate 
	bin/chjize urxvt

debianpackages: urxvt
	bin/chjize debianpackages

cplusplus: perhaps_aptupdate
	bin/chjize cplusplus

git-sign: key
	bin/chjize git-sign

chj-perllib-checkout: .bs git-sign
	bin/chj-checkout chj-perllib-checkout https://github.com/pflanze/chj-perllib.git perllib '^r($(BS)d+)$$'

chj-perllib: chj-perllib-checkout
	bin/chjize chj-perllib

chj-bin: .bs git-sign chj-perllib
	bin/chj-checkout chj-bin https://github.com/pflanze/chj-bin.git bin '^r($(BS)d+)$$'

chj-emacs-checkout: git-sign
	bin/chj-checkout chj-emacs-checkout https://github.com/pflanze/chj-emacs.git emacs

chj-emacs: chj-emacs-checkout
	bin/chjize chj-emacs

debian-emacs:
	bin/chjize debian-emacs

emacs: debian-emacs chj-emacs

chj-fastrandom: git-sign
	bin/chj-checkout chj-fastrandom https://github.com/pflanze/fastrandom.git fastrandom

fastrandom: /usr/local/bin/fastrandom
/usr/local/bin/fastrandom: chj-fastrandom
	make -C /opt/chj/fastrandom install

cj-git-patchtool: debianpackages chj-bin git-sign
	bin/chj-checkout cj-git-patchtool https://github.com/pflanze/cj-git-patchtool.git cj-git-patchtool

locales: chj-bin
	bin/chjize locales

chj: debian_upgrade git-sign debianpackages chj-bin chj-emacs fastrandom cj-git-patchtool locales
	touch chj

xfce4_load_profile: chj-bin
	bin/chjize xfce4_load_profile

load_profile: xfce4_load_profile

moduser: chj key
	bin/chjize moduser

fperl: git-sign debianpackages chj-bin
	bin/chjize fperl

gambit-checkout: .bs git-sign
	bin/chj-checkout gambit-checkout https://github.com/pflanze/gambc.git gambc '^cj($(BS)d+)$$'

gambit: gambit-checkout cplusplus debianpackages chj-bin chj-emacs
	bin/chjize gambit

qemu: git-sign gambit
	bin/chjize qemu

desktop: chj xfce4_load_profile
	bin/chjize desktop

desktop_autoremove: desktop
	apt-get autoremove

dnsresolver:
	bin/chjize dnsresolver

mercurial: chj-bin
	bin/chjize mercurial

