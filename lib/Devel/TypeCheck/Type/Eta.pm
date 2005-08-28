package Devel::TypeCheck::Type::Eta;

use strict;
use Carp;

use Devel::TypeCheck::Type;
use Devel::TypeCheck::Util;
use Devel::TypeCheck::Type::TRef;

our @ISA = qw(Devel::TypeCheck::Type::TRef Devel::TypeCheck::Type);

# **** INSTANCE ****

sub new {
    my ($name, $kappa) = @_;

    if ($kappa->type != Devel::TypeCheck::Type::M() &&
        $kappa->type->subtype->type != Devel::TypeCheck::Type::K()) {
	carp("Impossible included type ", $kappa->type, " for Eta\n");
    }

    my $this = {};

    $this->{'subtype'} = $kappa;

    return bless($this, $name);
}

sub type {
    return Devel::TypeCheck::Type::H();
}

sub str {
    my ($this, $env) = @_;
    return ("H:...," . $this->deref->str($env));
}

TRUE;
