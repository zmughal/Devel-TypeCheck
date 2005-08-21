package Devel::TypeCheck::Type::Mu;

use strict;
use Carp;

use Devel::TypeCheck::Type;
use Devel::TypeCheck::Type::TSub;
use Devel::TypeCheck::Util;

our @ISA = qw(Devel::TypeCheck::Type::TSub Devel::TypeCheck::Type);

# **** CLASS ****

our @SUBTYPES;
our @subtypes;

BEGIN {
    @SUBTYPES = (Devel::TypeCheck::Type::H(), Devel::TypeCheck::Type::K(), Devel::TypeCheck::Type::AV(), Devel::TypeCheck::Type::HV(), Devel::TypeCheck::Type::CV(), Devel::TypeCheck::Type::IO());

    for my $i (@SUBTYPES) {
	$subtypes[$i] = 1;
    }
}

sub hasSubtype {
    my ($this, $index) = @_;
    return ($subtypes[$index]);
}

sub type {
    return Devel::TypeCheck::Type::M();
}

TRUE;
