#!/usr/bin/perl
use v5.12;

#
# Check that daemon is adopted correctly.  We will have 3 options:
# 1. init
# 2. the parent of this script, which should be mort
# 3. this helper script itself, if mort exec'd this script directly
#
# We test 2 things:
# 1. that the daemon is adopted as expected
# 2. if helper is selected, the helper should adopt the daemon

my %opt = (
    init => 1,
    parent => getppid(),
    helper => $$,
);

my $arg = shift;
my $expect = $opt{$arg} or die "usage: $0 {init|parent|helper}\n";

#
# We will use a pipes to signal the daemon that its parent is dead,
# and also for the daemon to signal this script that it is finished.
# The daemon's parent is not actually dead until it is reaped,
# so this top helper process will wait for the tmp proccess,
# then tell the daemon by closing the pipe.
#

pipe my ($rdown, $wdown);
pipe my ($rup, $wup);

#
# here we go
#

my $tmp = fork;
die "tmp fork failed: $!\n" if $tmp < 0;

if ($tmp == 0) {
    # the tmp process that will fork and exit to daemonise
    close $wdown;
    close $rup;

    my $daemon = fork;
    die "daemon fork failed: $!\n" if $daemon < 0;
    exit 0 if $daemon > 0; # tmp process exits

    # wait for tmp parent to be reaped by script.
    my $wait = <$rdown>;
    my $parent = getppid();

    # and now, the actual test we want:
    if ($parent == $expect) {
        say "ok - daemon $$ parent is $parent";
    } else {
        say "not ok - daemon $$ parent is $parent but expected $expect";
    }

    close $wup; # rendevous with the script
    exit 0;

} else {
    close $rdown;
    close $wup;

    # wait for tmp then rendevous with daemon
    waitpid $tmp, 0;
    close $wdown; # signal daemon
    my $wait = <$rup>; # wait for daemon's signal
    my $kid = wait; # wait for the daemon itself, maybe

    if ($expect == $$) {
        # I'm supposed to adopt the daemon
        if ($kid > 0) {
            say "ok - $$ adopted daemon $kid";
        } else {
            say "not ok - $$ has no children";
        }
    } else {
        if ($kid > 0) {
            say "not ok - $$ adopted unexpected child";
        } else {
            say "ok - $$ has no children";
        }
    }
    exit 0;
}

