package Devel::TypeCheck;

use warnings;
use strict;

=head1 NAME

Devel::TypeCheck - Identify type-unsafe usage in Perl programs

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

This file exists as a placeholder for the documentation.  To use,
invoke the B::TypeCheck module as one normally would with any other
compiler back-end module:

	perl -MO=TypeCheck[,-verbose][,-main][,I<subroutine> ...] I<SCRIPTNAME>

=head1 OPTIONS

=over 4

=item B<-verbose>

Print out the relevant parts of the opcode tree along with their
inferred types.  This can be useful for identifying where a
type-inconsistant usage is in your program, and for debugging
TypeCheck itself.

=item B<-main>

Type check the main body of the Perl program in question.

=item B<I<subroutine>>

Type check a specific subroutine.  In this release, TypeCheck does not
do generalized interprocedural analysis.  However, it does keep track
of types for global variables.

=back

=head1 EXAMPLES

Here is an example program that treats $foo in a type-consistent manner:

 # pass
 if (int(rand(2)) % 2) {
     $foo = 1;
 } else {
     $foo = 2;
 }

When we run the TypeChecker against this program, we get the following
output:

 Type checking CVs:
   main::MAIN
   Pad Table Types:
   Name                Type
   ---------------------------------------- 
 
   Result type of main::MAIN is undefined
   Return type of main::MAIN is undefined
 
 Global Symbol Table Types:
 Name                Type
 ------------------------------------------------------------------------------
 foo                 MH:...,MKN<IV>
 Total opcodes processed: 24
 2.pl syntax OK

The indented stanza indicates that there are no named local variables in MAIN.

The stanza at the bottom shows that we have a global variable named
foo of the glob (C<< MH:... >>) type that contains an integer (C<< MKNE<lt>IVE<gt> >>) in
its scalar value element.

Here is another that does not:

 # fail
 if (int(rand(2)) % 2) {
     $foo = 1;
 } else {
     $foo = \1;
 }

We get the following when we run TypeChecker against the project:

 Type checking CVs:
   main::MAIN
 Could not unify MKPMKN<IV> and C<< MKN<IV> >> at line 5, file 3.pl
 CHECK failed--call queue aborted.

This means that the type inference algorithm was not able to unify a
reference to an integer type (C<< MKPMKNE<lt>IVE<gt> >>) with an integer type
(C<< MKNE<lt>IVE<gt> >>).  To get a better idea about how this works, we will look at
the verbose output (with lines numbered and extraneous lines removed
for clarity):

    24	                S:leave {
    25	                    S:enter {
    26	                    } = void
    27	                    S:nextstate {
    28	                      line 3, file 3.pl
    29	                    } = void
    30	                    S:sassign {
    31	                        S:const {
    32	                        } = MKN<IV>
    33	                        S:null {
    34	                            S:gvsv {
    35	                            } = MKf
    36	                        } = MKf
    37	                      unify(MKN<IV>, MKf) = MKN<IV>
    38	                    } = MKN<IV>
    39	                } = void
    40	                S:leave {
    41	                    S:enter {
    42	                    } = void
    43	                    S:nextstate {
    44	                      line 5, file 3.pl
    45	                    } = void
    46	                    S:sassign {
    47	                        S:const {
    48	                        } = MKPMKN<IV>
    49	                        S:null {
    50	                            S:gvsv {
    51	                            } = MKN<IV>
    52	                        } = MKN<IV>
    53	                      unify(MKPMKN<IV>, MKN<IV>) = FAIL
    54	Could not unify MKPMKN<IV> and MKN<IV> at line 5, file 3.pl
    55	CHECK failed--call queue aborted.
    56	Type checking CVs:
    57	  main::MAIN

Lines 30-38 represent the assignment that constitutes the first branch
of the if statement.  Here, an integer constant (C<< MKNE<lt>IVE<gt> >>, lines 31-32)
is assigned to the variable represented by the gvsv operator (lines
34-35).  The variable is brand new, so it is instantiated with a brand
new unspecified scalar value type (MKf).  This is unified with the
constant (line 37), binding the type variable "f" with the concrete
type C<< E<lt>IVE<gt> >>.

Lines 46-53 represent the assignment that consitutes the second branch
of the if statement.  Like the last assignment, we generate a type for
our constant.  Here, the type is a reference to an integer
(C<< MKPMKNE<lt>IVE<gt> >>, lines 47-48).  Since we have already inferred an integer
type for the $foo variable, that is what we get when we access it with
the gvsv operator (C<< MKNE<lt>IVE<gt> >>, lines 50-51).  When we try to assign the
constant to the variable, we get a failure in the unification since
the types do not match and there is no free type variable to unify
type components with.

=head1 REFERENCES

The author has written a paper explaining the need, operation,
results, and future direction for this project.  It is available at the
following URL:

  http://www.umiacs.umd.edu/~bargle/project2.pdf

This is suggested reading for this release.  In future releases, we
hope to have a proper manual.

=head1 AUTHOR

Gary Jackson, C<< <bargle at umiacs.umd.edu> >>

=head1 BUGS

This version is specific to Perl 5.8.1.  It may work with other
versions that have the same opcode list and structure, but this is
entirely untested.  It definitely will not work if those parameters
change.

Please report any bugs or feature requests to
C<bug-devel-typecheck at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Devel-TypeCheck>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 COPYRIGHT & LICENSE

Copyright 2005 Gary Jackson, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Devel::TypeCheck
