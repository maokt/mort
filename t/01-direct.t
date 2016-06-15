#!/usr/bin/perl
use strict;
use Test::More tests => 8;

{
    my @res = qx{./mort /bin/true};
    is $?, 0, "no error for true";
    is @res, 1, "got one result for true";
    like $res[0], qr/^\d+ exit 0$/;
}

{
    my @res = qx{./mort /bin/false};
    is $?, 0, "no error for false";
    is @res, 1, "got one result for false";
    like $res[0], qr/^\d+ exit 1$/;
}

{
    my @res = qx{./mort};
    is $?, 0, "no error for nothing";
    is scalar @res, 0, "no results";
}
