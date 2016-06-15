#!/usr/bin/perl
use strict;
use Test::More tests => 3;

my @res = qx{./mort ./t/daemon};
is scalar @res, 2, "got 2 results";
is grep(/exit 0$/, @res), 1;
is grep(/exit 64$/, @res), 1;

