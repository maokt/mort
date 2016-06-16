#!/usr/bin/perl
use strict;
use Test::More tests => 13;

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
    is $?>>8, 64, "usage error for nothing";
    is scalar @res, 0, "no results";
}

{
    # double dash ends options
    my @res = qx{./mort -- /bin/true};
    is $?, 0, "no error for true";
    is @res, 1, "got one result for -- true";
    like $res[0], qr/^\d+ exit 0$/;
}
{
    # try quiet mode
    my @res = qx{./mort -q /bin/true};
    is $?, 0, "no error for true";
    is @res, 0, "got no results for quiet true";
}

