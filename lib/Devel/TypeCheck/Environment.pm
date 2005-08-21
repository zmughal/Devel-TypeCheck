package Devel::TypeCheck::Environment;

use strict;

use Carp;

use Devel::TypeCheck::Type;
use Devel::TypeCheck::Type::Var;
use Devel::TypeCheck::Type::Mu;
use Devel::TypeCheck::Type::Eta;
use Devel::TypeCheck::Type::Kappa;
use Devel::TypeCheck::Type::Rho;
use Devel::TypeCheck::Type::Nu;
use Devel::TypeCheck::Util;

sub new {
    my ($name) = @_;
    my $this = {};

    $this->{'typeVars'} = [];

    return bless($this, $name);
}

# Create a new type variable in the context of the environment.  This
# is so we can find unbound type variables later.
sub fresh {
    my ($this) = @_;

    my $id = $#{$this->{'typeVars'}} + 1;
    my $var = Devel::TypeCheck::Type::Var->new($id);

    push(@{$this->{'typeVars'}}, $var);

    return $var;
}

# Return a fully qualified incomplete Kappa instance
sub freshKappa {
    my ($this) = @_;
    return Devel::TypeCheck::Type::Mu->new(Devel::TypeCheck::Type::Kappa->new($this->fresh()));
}

# Return a fully qualified incomplete Eta instance
sub freshEta {
    my ($this) = @_;
    return Devel::TypeCheck::Type::Mu->new(Devel::TypeCheck::Type::Eta->new($this->freshKappa));
}

# Return a fully qualified incomplete Nu instance
sub freshNu {
    my ($this) = @_;
    return Devel::TypeCheck::Type::Mu->new(Devel::TypeCheck::Type::Kappa->new(Devel::TypeCheck::Type::Nu->new($this->fresh())));
}

# Return a fully qualified incomplete Rho instance
sub freshRho {
    my ($this) = @_;
    return Devel::TypeCheck::Type::Mu->new(Devel::TypeCheck::Type::Kappa->new(Devel::TypeCheck::Type::Rho->new($this->fresh())));
}

# Encapsulate something in a fully qualified reference
sub genRho {
    my ($this, $referent) = @_;
    return Devel::TypeCheck::Type::Mu->new(Devel::TypeCheck::Type::Kappa->new(Devel::TypeCheck::Type::Rho->new($referent)));
}

# Encapsulate something in a fully qualified glob
sub genEta {
    my ($this, $referent) = @_;
    return Devel::TypeCheck::Type::Mu->new(Devel::TypeCheck::Type::Eta->new($referent));
}
    
# Union two types, as per union-find data structure
sub union {
    my ($this, $t1, $t2) = @_;
    
    # Union two type variables
    if ($t1->type == Devel::TypeCheck::Type::VAR() &&
        $t2->type == Devel::TypeCheck::Type::VAR()) {
	if ($t1->{'rank'} > $t2->{'rank'}) {
	    $t2->{'parent'} = $t1;
	    return $t1;
	} elsif ($t1->{'rank'} < $t1->{'rank'}) {
	    $t1->{'parent'} = $t2;
	    return $t2;
	} else {
	    # $t1->{'rank'} == $t2->{'rank'}
	    if ($t1 != $t2) {
		$t1->{'parent'} = $t2;
		$t2->{'rank'}++;
	    }

	    return $t2;
	}
    
    # The next two clauses handle the union of a type variable with a
    # concrete type
    } elsif ($t1->type == Devel::TypeCheck::Type::VAR() &&
	     $t2->type != Devel::TypeCheck::Type::VAR()) {
	$t1->{'parent'} = $t2;
	return $t2;
    } elsif ($t1->type != Devel::TypeCheck::Type::VAR() &&
	     $t2->type == Devel::TypeCheck::Type::VAR()) {
	$t2->{'parent'} = $t1;
	return $t1;

    # There cannot be a union between two concrete types.  If two
    # types contain types that can be unioned, this happens in unify.
    } else {
	# $t1->type != VAR && $t2->type != VAR
	return undef;
    }
}

sub unify {
    my ($this, $t1, $t2) = @_;
    
    $t1 = $this->find($t1);
    $t2 = $this->find($t2);

    # The buck stops here if at least one is a VAR
    if ($t1->type == Devel::TypeCheck::Type::VAR() &&
	$t2->type == Devel::TypeCheck::Type::VAR()) {

	# The unification of two variable types is trivially their
	# union.
	return $this->union($t1, $t2);


    # The next two clauses handle the case where a type variable needs
    # to be unified with a concrete type.  In both cases, we need to
    # make sure that the type variable does not appear in the concrete
    # type.
    } elsif ($t1->type == Devel::TypeCheck::Type::VAR() &&
	     $t2->type != Devel::TypeCheck::Type::VAR()) {

	if (!$t2->occurs($t1, $this)) {
	    $t1->{'parent'} = $t2;
	    return $t2;
	} else {
	    die("Failed occurs check");
	}

    } elsif ($t1->type != Devel::TypeCheck::Type::VAR() &&
	     $t2->type == Devel::TypeCheck::Type::VAR()) {

	if (!$t1->occurs($t2, $this)) {
	    $t2->{'parent'} = $t1;
	    return $t1;
	} else {
	    die("Failed occurs check");
	}

    # In this clause, both t1 and t2 are concrete types
    } else {

	# Call the type-specific unify.  This handles the case where
	# incomplete types need to be unified.
	if ($t1->unify($t2, $this)) {
	    return $t1;
	} else {
	    return undef;
	}
    }
}

sub find {
    my ($this, $elt) = @_;

    if (defined($elt->getParent)) {
	return $elt->setParent($this->find($elt->getParent));
    } else {
	return $elt;
    }
}

TRUE;
