package Devel::TypeCheck::Type;

use strict;
use Carp;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = ();
our @EXPORT_OK = qw(n2s s2n);

use Devel::TypeCheck::Util;

# **** CLASS ****

our $AUTOLOAD; # Package global used in &AUTOLOAD

our %name2number; # Mapping type names to numbers from @EXPORTS for &AUTOLOAD
our @number2name; # Mapping numbers to names for printing purposes

our @SUBTYPES;
our @subtypes;

BEGIN {
    my $count = 0;
    @EXPORT = qw(VAR M H K P N AV HV CV IO PV IV DV);

    for my $i (@EXPORT) {
	$number2name[$count] = $i;
	$name2number{$i} = $count++;
    }
}

sub AUTOLOAD {
    my $name = $AUTOLOAD;
    $name =~ s/.*://;   # strip fully-qualified portion

    # Die if the name this was called by isn't exported
    if (!exists($name2number{$name})) {
	confess("Method &$name not implemented");
    }
    
    return $name2number{$name};
}

sub n2s ($) {
    my ($n) = @_;
    return $number2name[$n];
}

sub s2n ($) {
    my ($s) = @_;
    return $name2number{$s};
}

# Required, since AUTOLOAD will suck this up if not defined

sub DESTROY {}

# **** INSTANCE ****

sub new {
    my ($name, $subtype) = @_;

    if ($name eq "Devel::TypeCheck::Type") {
	croak("Method &new not implemented for abstract class Devel::TypeCheck::Type");
    }

    if (! $subtype->isa("Devel::TypeCheck::Type")) {
	croak("Subtype is not a member of class Devel::TypeCheck::Type");
    }

    my $this = {};

    bless($this, $name);

    if (! $this->hasSubtype($subtype->type)) {
	croak("Invalid subtype ", n2s($subtype->type), " for class $name");
    }

    $this->{'subtype'} = $subtype;

    return $this;
}

sub hasSubtype {
    return TRUE;
}

sub type {
    croak("Method &type not implemented for abstract class Devel::TypeCheck::Type");
}

sub subtype {
    my ($this) = @_;
    return $this->{'subtype'};
}

# Shouldn't ever be called except by a Devel::TypeCheck::Environment or an inheritor of Devel::TypeCheck::Type.
sub unify {
    my ($this, $that, $env) = @_;

    $this = $env->find($this);
    $that = $env->find($that);

    # Make sure that types match and that subtypes are valid.
    if ($this->type == $that->type &&
        $this->hasSubtype($this->subtype->type) &&
        $that->hasSubtype($that->subtype->type)) {
	return $this->subtype->unify($that->subtype, $env);
    } else {
	return undef;
    }
}

sub occurs {
    my ($this, $that, $env) = @_;
    
    if ($that->type != Devel::TypeCheck::Type::VAR()) {
	die("Invalid type ", $that->str, " for occurs check");
    }

    return $this->subtype->occurs($that, $env);
}

sub str {
    my ($this, $env) = @_;
    return (n2s($this->type) . $this->subtype->str($env));
}

sub deref {
    my ($this) = @_;
    return $this->subtype->deref;
}

sub is {
    my ($this, $type) = @_;
    if ($this->type == $type) {
	return TRUE;
    } else {
	return $this->subtype->is($type);
    }
}

sub getParent {
    return undef;
}

sub complete {
    my ($this) = @_;
    return $this->subtype->complete;
}

TRUE;
