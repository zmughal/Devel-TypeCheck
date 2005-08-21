package Devel::TypeCheck::Pad2type;

use strict;
use Devel::TypeCheck::Type;
use Devel::TypeCheck::Sym2type;
use B;
use IO::Handle;

our @ISA = qw(Devel::TypeCheck::Sym2type);

sub new {
    my ($name) = @_;
    return bless([], $name);
}

sub get {
    my ($this, $pad, $env) = @_;

    if (!exists($this->[$pad])) {
        $this->[$pad] = $env->fresh();
    }

    return $this->[$pad];
}

sub print {
    my ($this, $fh, $cv, $env) = @_;

    my ($i, $t);

    $fh->print("  Pad Table Types:\n  Name                Type\n  ----------------------------------------\n");

    format P2T =
  @<<<<<<<<<<<<<<<<<< @<<<<<<<<<<<<<<<<<<
  $i,                 $t
.

    my %set;

    for my $j (0 .. $#$this) {
	next unless defined($this->[$j]);

	my $sv = (($cv->PADLIST()->ARRAY())[0]->ARRAY)[$j];
	$i = $sv->PVX;
	my $intro = $sv->NVX;
	my $finish = int($sv->IVX);
	$i .= ":$intro,$finish";

	$t = $this->[$j]->str($env);

	$fh->format_write("Devel::TypeCheck::Pad2type::P2T");
    }

    $fh->print("\n");
}

1;
