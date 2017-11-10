# Tools

This folder contains optional tools that extend or complement Arcan
extending its feature-set or providing command-line wrappers for
engine features.

## Aclip
This tool is built separately and provides clipboard integration,
similarly to how 'xclip' works for Xorg.

## Db
This tool is already built as part of the normal engine build, and
provides command-line access to updating database configuration.

## Aloadlimage
This is a sandboxed image loader, supporting multi-process privilege
separation, playlists and so on - similar to xloadimage.

## Kbdconv
This is a semi-working skeleton for generating .lua files that can
be used as keyboard maps in applications that use the 'symtables.lua'
support script.

## Leddec
This is a simple skeleton that can be used for interfacing with custom
LED controllers. See its README.md for how it connects to arcan.

## LTUI
This is a patched version of the Lua interactive CLI that loads in
the shmif-tui (text-user interfaces )

## VRbridge
This tools aggregates samples from VR related SDKs and binds into a
single avatar in a way that integrates with the core engine VR path.

## Waybridge
This tool act as a wayland service so that clients which speaks the
wayland protocol can connect to an arcan instance.