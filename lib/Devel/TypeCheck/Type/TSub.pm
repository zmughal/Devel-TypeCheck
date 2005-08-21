package Devel::TypeCheck::Type::TSub;

use strict;
use Carp;

use Devel::TypeCheck::Util;

# **** INSTANCE ****

sub hasSubtype {
    croak("Method &hasSubtype is abstract in Devel::TypeCheck::Type::TSub");
}

TRUE;
