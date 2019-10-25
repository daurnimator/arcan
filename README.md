Arcan
=====

Arcan is a powerful development framework for creating virtually anything from
user interfaces for specialized embedded applications all the way to full-blown
standalone desktop environments.

At its heart lies a robust and portable multimedia engine, with a well-tested
and well-documented Lua scripting interface. The development emphasizes
security, debuggability and performance -- guided by a principle of least
surprise in terms of API design.

For more details about capabilities, design, goals, current development,
roadmap, changelogs, notes on contributing and so on, please refer to the
[arcan-wiki](https://github.com/letoram/arcan/wiki).

There is also a [website](https://arcan-fe.com) that collects other links,
announcements, releases, videos / presentations and so on.

* For community contact, check out the IRC channel #arcan on irc.freenode.net.

* For developer information, see the HACKING.md

For curated issues, use the [git-bug](https://github.com/MichaelMure/git-bug)
tool to browse the currently tracked and acknowledged issues and their details.

We do check the github issues page for user communication from time to time,
and append as necessary, but it is not a priority.

Getting Started
====

Some distributions, e.g. [voidlinux](https://voidlinux.org) have most of arcan
as part of its packages, so you can save yourself some work going for one of
those.

Docker- container templates (mainly used for headless development and testing)
can be found here: [dockerfiles](https://github.com/letoram/arcan-docker).

## Compiling from Source

There are many ways to tune the build steps in order to reduce dependencies.
There are even more ways to configure and integrate the components depending
on what you are going for,

Most options are exposed via the build output from running cmake on the src
directory.

For the sake of simplicity over size, there is a build preset, 'everything'
which is the one we will use here.

### Dependencies

Specific package names depend on your distribution, but common ones are:

    sqlite3, openal-soft, sdl2, opengl, luajit, gbm, kms, freetype, harfbuzz
    libxkbcommon

For encoding and decoding options you would also want:

    libvlc-core (videolan), the ffmpeg suite, leptonica, tesseract
    libvncserver libusb1

First we need some in-source dependencies that are cloned manually for now:

    git clone https://github.com/letoram/arcan.git
    cd external/git
    ../clone.sh
    cd ../arcan

These are typically not needed, with the exception of our temporary openAL
patches pending refactoring of that subsystem in time for the ~0.7 series of
releases.

### Compiling

Now we can configure and build the main engine:

    mkdir build
    cd build
    cmake -DBUILD_PRESET="everything" ../src

Like with other CMake based projects, you can add:

    -DCMAKE_BUILD_TYPE=Debug

To switch from a release build to a debug one.

When it has finished probing dependencies, you will get a report of which
dependencies that has been found and which features that were turned on/off,
or alert you if some of the required dependencies could not be found.

Make and install like normal (i.e. make, sudo make install). A number of
binaries are produced, with the 'main' one being called simply arcan. To
test 'in source' (without installing) you should be able to run:

     ./arcan -T ../data/scripts -p ../data/resources ../data/appl/welcome

The -T argument sets our built-in/shared set of scripts, the -p where shared
resources like fonts and so on can be found, and the last argument being
the actual 'script' to run.

With installation, this should reduce to:

     arcan welcome

It will automatically try to figure out if it should be a native display
server or run nested within another or even itself based on the presence
of various environment variables (DISPLAY, WAYLAND\_DISPLAY, ARCAN\_CONNPATH).

'welcome' is a name of a simple builtin welcome screen, that will shut down
automatically after a few seconds of use. For something of more directly
useful, you can try the builtin appl 'console':

    arcan console

Which should work just like your normal console command-line, but with the
added twist of being able to run (arcan compatible) graphical applications
as well.

### Headless Mode

The 'everything' build option should also produce a binary called
'arcan\_headless', at least on BSDs and Linux. This binary can be used to run
arcan without interfering with your other graphics and display system. Given
access to a 'render node' (/dev/dri/renderD128 and so on) and it should also
work fine inside containers and other strict sandboxing solutions.

To make it useful, it can record/stream to a virtual screen. An example of
such a setup following the example above would be:

    ARCAN_VIDEO_ENCODE=protocol=vnc arcan_headless console

Assuming the build-system found the libvncserver dependency, this should
leave you with an exposed (insecure, unprotected, ...) vnc server at
localhost+5900. See afsrv\_encode for a list of arguments that can be added
to the encode environment in order to control what happens.

Related Projects
================

If you are not interested in developing something of your own, you will
likely find little use with the parts of this project alone. Here are some
projects that you might want to look into:

* [Durden](https://github.com/letoram/durden) is the main desktop
  environment that uses this project as its display server.

* [Safespaces](https://github.com/letoram/safespaces) is an experimental
  VR/3D desktop environment.

* [Prio](https://github.com/letoram/prio) is a simple window manager
  that mimics Plan9- Rio.

To get support for more types of clients and so on, there is also:

* Wayland support (see Tools below).

* [QEmu](https://github.com/letoram/qemu) a patched QEmu version that
  adds a -ui arcan option.

* [Xarcan](https://github.com/letoram/xarcan) is a patched Xorg that
  allows you to run an X session 'as a window'.

Tools
=====

The default build above does not include any support tools other than the
configuration tool, arcan\_db. You have to manually build the ones that
are of interest to you.

These tools are located in 'src/tools', with their own specific README.md
files for instructions on compilation and use.

The main tools of interest are:

## arcan-db

All runtime configuration is consolidated into a database, either the default
'arcan.sqlite' one or an explicitly set one (arcan -d mydb.sqlite). This is
used for platform specific options, engine specific options and for trusted
clients that the running scripts are allowed to start. It is also used as a
configuration key-value store for any arcan applications that are running.

As a quick example, this is how to inspect and modify keys that 'Durden'
are currently using:

    arcan_db show_appl durden
    arcan_db add_appl_kv durden shadow_on true

Advanced configuration for some video platforms can be set via the reserved
arcan appl name. This would, for instance, set the primary graphics card
device name for the 'egl-dri' platform version:

    arcan_db add_appl_kv arcan video_device=/dev/dri/card2

To add 'launch targets', you can use something like:

    arcan_db add_target BIN arcan-net -l netfwd
    arcan_db add_config arcan-net default 10.0.0.10 6666

This allow applications to start a program as a trusted child (that inherits
its connection primitives rather than to try and find them using some OS
dependent namespace). The example above would have spawned arcan-net in the
local mode where clients connecting to the 'netfwd' connpath would be
redirected to the server listening at 10.0.0.10:6666.

There are many controls and options for this tool, so it is suggested that you
look at its manpage for further detail and instructions.

## Waybridge

Waybridge adds support for wayland and X clients (via Xwayland). It can
be run as either a global system service, e.g.

    arcan-wayland -xwl

Or on a case by case basis, like:

    arcan-wayland -exec weston-terminal

For a compliant wayland client, and:

    arcan-wayland -xwl -exec xterm

For an X client. The 'per case' basis is recommended as it is safer and
more secure than letting multiple clients share the same bridge process.

## Acfgfs

Acfgfs is a tool that lets you mount certain arcan applications as a FUSE
file-system. The application has to explicitly support it. For the Durden
desktop environment, you can use global/settings/system/control=somename
and then:

    arcan_cfgfs --control=/path/to/durden/ipc/somename /mnt/desktop

And desktop control / configuration should be exposed in the specified
mountpoint.

## Aclip

Aclip is a clipboard manager similar to Xclip. It allows for bridging the
clipboard between a desktop environment like Durden, and that of an X server.

This requires that clipboard bridging has been allowed (disabled by default
for security reaons). In Durden this is activated via
global/settings/system/clipboard where you can control how much clipboard
access the tool gets.

## Aloadimage

Aloadimage is a simple sandboxing image loader, similar to xloadimage. It
is useful both for testing client behavior when developing applications
using arcan, but also as an image viewer in its own right, with reasonably
fast image loading, basic playlist controls and so on.

## Net

Arcan-net is a tool that allows you to forward one or many arcan clients
over a network. It is built by default, and can be triggered both as a
separate network tool as well as being launched indirectly from shmif by
setting ARCAN\_CONNPATH=a12://id@host:port.

## Vrbridge

VR bridge is an optional input driver that provides the arcan\_vr binary
which adds support for various head-mounted displays. More detailed
instructions on its setup and use can be found as part of the Safespaces
project mentioned in the 'Related Projects 'section.

## Trayicon

Arcan-trayicon is a tool that chain-loads another arcan client, along with
two reference images (active and inactive). It tries to register itself in
the icon-tray of a running arcan application, though it must explicitly
enable the support. In Durden, this is done via the path:

    global/settings/statusbar/buttons/right/add_external=tray

Then you can use:

    ARCAN_CONNPATH=tray arcan-trayicon active.svg inactive.svg afsrv_terminal

Or some other arcan client that will then be loaded when the tray button is
clicked, confined into a popup and then killed off as the popup is destroyed.
This is a quick and convenient way to wrap various system services and external
command scripts.
