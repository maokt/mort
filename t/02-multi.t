#!/usr/bin/perl
use strict;
use Test::More tests => 14;

{
    my @res = qx{./mort perl -e 'fork&&exit 0;exit 1'};
    is scalar @res, 2, "got two results";
    is grep(/exit 0$/, @res), 1;
    is grep(/exit 1$/, @res), 1;
}

{
    my @res = qx{./mort perl -e 'fork&&exit 1;exit 2'};
    is scalar @res, 2, "got two results";
    is grep(/exit 1$/, @res), 1;
    is grep(/exit 2$/, @res), 1;
}

{
    my @res = qx{./mort perl -e 'fork&&exit 0;for my \$x (1,2,3) {fork||exit\$x}'};
    is scalar @res, 5, "got 5 results";
    is grep(/exit 0$/, @res), 2;
    is grep(/exit 1$/, @res), 1;
    is grep(/exit 2$/, @res), 1;
    is grep(/exit 3$/, @res), 1;
}

{
    my @res = qx{./mort perl -e 'fork&&exit 0;my \$k = fork; if(\$k){kill TERM=>\$k} else{sleep 10}'};
    is scalar @res, 3, "got 3 results";
    is grep(/exit 0$/, @res), 2;
    is grep(/killed by signal 15$/, @res), 1;
}
