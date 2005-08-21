package Devel::TypeCheck::Util;

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw(getVerbose setVerbose verbose verbose_ TRUE FALSE);

our $verbose = 0;

# getVerbose(): return the verbosity status
sub getVerbose () {
    return $verbose;
}

# setVerbose($status): set the verbosity status
sub setVerbose ($) {
    my $status = shift;
    if ($status) {
        $verbose = 1;
    } else {
        $verbose = 0;
    }
}

# verbose($msg1, $msg2, ...): If verbosity is on, print out the
# messages to stderr
sub verbose {
    if ($verbose) {
        print STDERR (@_, "\n");
    }
}

sub verbose_ {
    if ($verbose) {
	print STDERR (@_);
    }
}

sub TRUE () {
    return 1;
}

sub FALSE () {
    return 0;
}

TRUE;
