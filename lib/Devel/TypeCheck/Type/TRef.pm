package Devel::TypeCheck::Type::TRef;

use strict;
use Carp;

use Devel::TypeCheck::Util;

# **** INSTANCE ****

sub deref {
    my ($this) = @_;
    return $this->subtype;
}

sub is {
    my ($this, $type) = @_;
    if ($this->type == $type) {
	return TRUE;
    } else {
	return FALSE;
    }
}

sub type {
    croak("Method &type is abstract in class Devel::TypeCheck::Type::Ref");
}

TRUE;
