# Chjize

Mod a bare-bones (e.g. debootstrap) Debian install into one that I
like. Also partially works on Cygwin (at least the chj-perllib target
does).


## How?

    sudo su -
    apt-get update
    apt-get install -y git make gnupg
    cd /opt/
    mkdir chj
    cd chj
    git clone https://github.com/pflanze/chjize.git
    cd chjize/
    
You can verify via signed git tags that you've got the pristine source
(note that most rules import the key to gpg, too, and as the key is
included in the repository, this means that if you got a trusted
checkout of this repository then this verification step can be
skipped; it will properly check signatures of other repositories it
fetches in any case):

    gpg --import cj-key.asc
    version=r`git tag -l | grep ^r | sed s/^r// | LANG=C sort -rn | head -1`
    git checkout "$version"
    git tag -v "$version"
    # Check that the above command says "Good signature", and shows
    #   my fingerprint (A54A1D7CA1F94C866AC81A1F0FA5B21104EDB072, feel 
    #   free to google it) if you don't have a trust path to the key.
    # You can also do the more paranoid verification of running the
    #   script lines shown by the above command (those lines starting 
    #   with a "$"), and verifying that you get the same output as shown.

Once you trust that the source is mine, run:
    
    make help

for the list of available targets. To e.g. only install my software
into `/opt/chj` (and dependences, which is debianpackages in this
case, see `Makefile` for details), run:

    make chj

## Current list of targets

### graph-deps

install dependencies to run the `graph` target.

### key

import cj-key.asc into the keyring of the current user.

### perhaps_aptupdate

run `apt-get update` unless already run in the last 24 hours.

### debian_upgrade

upgrade the system (via dist-upgrade), necessary on a fresh instance
on typical cloud hostings like Amazon's.

### urxvt

install `rxvt-unicode` and trim it down for security and simplicity.

### debianpackages

install my preferred Debian packages.

### cplusplus

install `g++`

### git-sign

check out [git-sign](https://github.com/pflanze/git-sign); used by
most other targets.

### chj-perllib-checkout


### chj-perllib


### chj-bin

install [chj-bin](https://github.com/pflanze/chj-bin.git) (checking
signatures).

### chj-emacs-checkout


### chj-emacs

install [chj-emacs](https://github.com/pflanze/chj-emacs) in
/opt/chj/emacs/.

### debian-emacs

install GNU Emacs from apt.

### emacs


### chj-fastrandom


### fastrandom

install [chj-fastrandom](https://github.com/pflanze/fastrandom.git).

### cj-git-patchtool


### locales

automatically configure some (English and German speaking) locales.

### chj

check out the last tagged versions of various repositories into
`/opt/chj` (uses signed tags via git-sign to ensure you get what I
signed)

### xfce4_load_profile


### load_profile

sets up Debian so that a graphical login will read the `~/.profile`
file (which they stopped doing at some point, dunno why); currently
only implemented for Xfce.

### moduser

modify the `/root`, `/etc/skel`, and if present `/home/chris`
directories to use a checkout of
[chj-home](https://github.com/pflanze/chj-home); it should safely
store previous versions of your files in the Git repository that's
at this place before checking out my versions, see them via `gitk
--all`. This also sets up emacs to work nicely with Gambit, see
below. Note: if there is a `.git` directory in those directories
before, it will ask whether to continue by first moving those to
`/root/.trash/`.

If you want to modify a particular user's home without affecting the
other users, instead run `/opt/chj/chjize/bin/mod-user` as that user
(in its home dir)

### fperl

install the [Functional Perl](http://functional-perl.org) library
and its dependencies. WARNING: not fully secured by signatures as it
downloads packages from CPAN whithout verifying signatures (which
most packages don't even have). Note: requires you to enter `yes` a
couple times.

### gambit-checkout


### gambit

install a patched version of the Gambit Scheme system

### qemu

install Qemu, and
[cj-qemucontrol](https://github.com/pflanze/cj-qemucontrol.git).

### desktop


### desktop_autoremove

make my preferred changes to Debian's Xfce4 and default display
manager setup (automatically removes superfluous packages via `apt
autoremove`, to prevent that you could use the `desktop` target
instead.) NOTE: xfce4 has to be started via `startx` from the
console after this!

### dnsresolver

install and configure a local dns resolver (unbound).

### mercurial

install mercurial, and hg-fast-export from either Debian or upstream
source.

### system

ensure basic system readyness.
