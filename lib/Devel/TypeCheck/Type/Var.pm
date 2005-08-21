package Devel::TypeCheck::Type::Var;

use strict;
use Carp;

use Devel::TypeCheck::Type;
use Devel::TypeCheck::Util;

our @ISA = qw(Devel::TypeCheck::Type);

# **** INSTANCE ****

sub new {
    my ($name, $index) = @_;

    my $this = {};

    $this->{'index'} = $index;
    $this->{'rank'} = 0;
    $this->{'parent'} = undef;

    return bless($this, $name);
}

sub type {
    return Devel::TypeCheck::Type::VAR();
}

sub subtype {
    confess("Method &subtype is abstract in Devel::TypeCheck::Type::Var");
}

sub unify {
    my ($this, $that, $env) = @_;

    $this = $env->find($this);
    $that = $env->find($that);

    return $env->unify($this, $that);
}

sub occurs {
    my ($this, $that, $env) = @_;
    
    if ($that->type != Devel::TypeCheck::Type::VAR()) {
	die("Invalid type ", $that->str, " for occurs check");
    }

    my $f = $env->find($this);
    my $g = $env->find($that);

    if ($f->type != Devel::TypeCheck::Type::VAR()) {
	return ($f->occurs($g, $env));
    } else {
	return ($f == $g);
    }
}

sub letters {
    my ($int) = @_;
    if ($int != 0) {
	use integer;
	return letters($int / 26) . chr(ord('a') + ($int % 26));
    } else {
	return "";
    }
}

sub str {
    my ($this, $env) = @_;

    my $that = $this;

    if (defined($env)) {
	$that = $env->find($this);
    }

    if ($this == $that) {
	return letters($this->{'index'});
    } else {
	return $that->str($env);
    }
}

sub deref {
    return undef;
}

sub getParent {
    my ($this) = @_;
    return $this->{'parent'};
}

sub setParent {
    my ($this, $parent) = @_;

    die ("Devel::TypeCheck::Type::Var cannot be it's own parent") if ($this == $parent);

    $this->{'parent'} = $parent;
}

sub is {
    return FALSE;
}

sub complete {
    return FALSE;
}

TRUE;
