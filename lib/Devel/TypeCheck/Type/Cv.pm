package Devel::TypeCheck::Type::Cv;

use strict;
use Carp;

use Devel::TypeCheck::Type;
use Devel::TypeCheck::Util;
use Devel::TypeCheck::Type::TTerm;

our @ISA = qw(Devel::TypeCheck::Type::TTerm);

# **** INSTANCE ****

sub type {
    return Devel::TypeCheck::Type::CV();
}

TRUE;
