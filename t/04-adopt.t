#!/usr/bin/perl
use v5.12;

# not using Test::More so we can avoid some test counting issues while forking

say "1..3";

system "./t/adopt-by.pl", "init";
system "./mort", "-q", "./t/adopt-by.pl", "parent";
system "./mort", "-q", "-x", "./t/adopt-by.pl", "helper";
