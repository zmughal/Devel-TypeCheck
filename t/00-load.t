#!perl -T

use Test::More tests => 24;

BEGIN {
    use_ok( 'Devel::TypeCheck' );

    for my $helper ( qw ( Environment Glob2type Pad2type Sym2type Type Util ) ) {
        use_ok( "Devel::TypeCheck::$helper" );
    }

    for my $type ( qw( Av Cv Dv Eta Hv Io Iv Kappa Mu Nu Pv Rho TRef TSub TTerm TVar Var ) ) {
        use_ok( "Devel::TypeCheck::Type::$type" );
    }
}

diag( "Testing Devel::TypeCheck $Devel::TypeCheck::VERSION, Perl $], $^X" );
