package Devel::TypeCheck::Glob2type;

use strict;
use Devel::TypeCheck::Type;
use Devel::TypeCheck::Sym2type;

our @ISA = qw(Devel::TypeCheck::Sym2type);

sub get {
    my ($this, $glob, $env) = @_;

    if (!exists($this->{$glob})) {
        $this->{$glob} = $env->freshEta();
    }

    return $this->{$glob};
}

sub symbols {
    my ($this) = @_;
    return keys(%$this);
}

1;
