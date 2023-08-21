use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Devel::TypeCheck',
    AUTHOR              => 'Gary Jackson <bargle@umiacs.umd.edu>',
    VERSION_FROM        => 'lib/Devel/TypeCheck.pm',
    ABSTRACT_FROM       => 'lib/Devel/TypeCheck.pm',
    PREREQ_PM => {
        'Opcodes'    => 0,
        'Test::More' => 0,
    },
    META_MERGE   => {
      "meta-spec" => { version => 2 },
      prereqs => {
        runtime => {
          requires => {
            perl         => '5.008001',
            'Opcodes'    => 0,
          },
        },
        test => {
          requires => {
            'Test::More' => '0',
          },
          recommends => {
            'Test::Pod::Coverage' => '1.04',
            'Test::Pod' => '1.14',
          },
        },
        develop => {
          requires => {
            'Test::Pod::Coverage' => '1.04',
            'Test::Pod' => '1.14',
          },
        },
      },
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Devel-TypeCheck-* lib/*.ph' },
);
