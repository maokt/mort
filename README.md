Mort
====

[![Travis status](https://api.travis-ci.org/maokt/mort.svg)](https://travis-ci.org/maokt/mort)

**tl;dr** Mort prevents daemons from being adopted by pid 1, making them easier to manage with runit.

Mort is a simple program for Linux (only) that will adopt any orphaned descendents, in place of pid 1. It will wait for all
those descendents to exit, and then exit itself. This can be useful if you want to manage a traditional daemonising program with
a service supervisor like runit, or if you need to run a program that carelessly exits without waiting on its own children.

Startup scripts
---------------

Instead of having to rewrite the SysVinit script for $program, you should be able to do

    mort /etc/init.d/$program start

and mostly manage that with runit. But there are still a few issues:

* It won't work if your init script is actually a wrapper that sends messages to another non-SysV init system, such as systemd.
* It only deals with starting and restarting; you'll need to add something else for stopping.
* It may be better in the long term to rewrite the script, and run the underlying daemon with Mort directly if needed.

Requirements
------------

Linux kernel version 3.4 or greater, as Mort uses the "child subreaper" feature.

Bugs?
-----

Mort should probably ignore or handle some signals, but I have not yet decided how.

