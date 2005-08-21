package Devel::TypeCheck::Sym2type;

use strict;
use Devel::TypeCheck::Type;
use Devel::TypeCheck::Util;

sub new {
    my ($name) = @_;
    return bless({}, $name);
}

sub get {
    die("Method &get is abstract in class Devel::TypeCheck::Sym2type");
}

TRUE;
