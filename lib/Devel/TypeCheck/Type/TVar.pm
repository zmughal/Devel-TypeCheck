package Devel::TypeCheck::Type::TVar;

use strict;
use Carp;

use Devel::TypeCheck::Type;
use Devel::TypeCheck::Util;

our @ISA = qw(Devel::TypeCheck::Type);

# **** INSTANCE ****

sub unify {
    my ($this, $that, $env) = @_;

    $this = $env->find($this);
    $that = $env->find($that);

    if ($this->type == $that->type) {
	# If a subtype is VAR, then we need to go back to the main
	# unify()
	if ($this->subtype->type == Devel::TypeCheck::Type::VAR() ||
	    $that->subtype->type == Devel::TypeCheck::Type::VAR()) {
	    return $env->unify($this->subtype, $that->subtype);
	} else {
	    return $this->subtype->unify($that->subtype, $env);
	}
    } else {
	return undef;
    }
}

sub type {
    croak("Method &type not implemented for abstract class Devel::TypeCheck::Type::TVar");
}

TRUE;
