package Devel::TypeCheck::Type::TTerm;

use strict;
use Carp;

our @ISA = qw(Devel::TypeCheck::Type);

use Devel::TypeCheck::Type qw(n2s);
use Devel::TypeCheck::Util;

# **** INSTANCE ****

sub new {
    my ($name) = @_;

    my $this = {};

    bless($this, $name);

    return $this;
}


sub unify {
    my ($this, $that, $env) = @_;

    $this = $env->find($this);
    $that = $env->find($that);

    if ($this->type == $that->type) {
	return $this->type;
    } else {
	return undef;
    }
}

sub occurs {
    my ($this, $that, $env) = @_;
    
    return FALSE;
}

sub type {
    croak("Method &type not implemented for abstract class Devel::TypeCheck::Type::TVar");
}

sub subtype {
    croak("Method &subtype is abstract in class Devel::TypeCheck::Type::TVar");
}

sub str {
    my ($this, $env) = @_;
    return ("<" . Devel::TypeCheck::Type::n2s($this->type) . ">");
}

sub deref {
    return undef;
}

sub is {
    my ($this, $type) = @_;
    if ($this->type == $type) {
	return TRUE;
    } else {
	return FALSE;
    }
}

sub complete {
    return TRUE;
}

TRUE;
