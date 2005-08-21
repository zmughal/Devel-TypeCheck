package Devel::TypeCheck::Type::Nu;

use strict;
use Carp;

use Devel::TypeCheck::Type;
use Devel::TypeCheck::Type::TSub;
use Devel::TypeCheck::Util;

our @ISA = qw(Devel::TypeCheck::Type::TSub Devel::TypeCheck::Type::TVar);

# **** CLASS ****

our @SUBTYPES;
our @subtypes;

BEGIN {
    @SUBTYPES = (Devel::TypeCheck::Type::IV(), Devel::TypeCheck::Type::DV(), Devel::TypeCheck::Type::VAR());

    for my $i (@SUBTYPES) {
	$subtypes[$i] = 1;
    }
}

sub hasSubtype {
    my ($this, $index) = @_;
    return ($subtypes[$index]);
}

sub type {
    return Devel::TypeCheck::Type::N();
}

TRUE;
