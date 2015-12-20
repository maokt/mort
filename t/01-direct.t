#!/usr/bin/perl
use strict;
use Test::More tests => 6;

my @res;

@res = qx{./mort /bin/true};
is scalar @res, 1, "got one result";
like $res[0], qr/^\d+ exit 0$/;
is $?>>8, 0, "true";

@res = qx{./mort /bin/false};
is scalar @res, 1, "got one result";
like $res[0], qr/^\d+ exit 1$/;
is $?>>8, 1, "false";
