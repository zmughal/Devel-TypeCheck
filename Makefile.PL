use strict;
use warnings;
use ExtUtils::MakeMaker;

my $h2ph_pre = File::Spec->catdir("lib","_h2ph_pre.ph");
my $opnames_ph = File::Spec->catdir("lib","opnames.ph");
my $h2ph_blib = File::Spec->catdir("blib","lib","_h2ph_pre.ph");
my $opnames_blib = File::Spec->catdir("blib","lib","opnames.ph");

WriteMakefile(
    NAME                => 'Devel::TypeCheck',
    AUTHOR              => 'Gary Jackson <bargle@umiacs.umd.edu>',
    VERSION_FROM        => 'lib/Devel/TypeCheck.pm',
    ABSTRACT_FROM       => 'lib/Devel/TypeCheck.pm',
    #PM		        => { $h2ph_pre => '$(INST_LIB)/_h2ph_pre.ph',
    #			     $opnames_ph => '$(INST_LIB)/opnames.ph'
    #			   },
    PREREQ_PM => {
        'Test::More' => 0,
    },
    META_MERGE   => {
      "meta-spec" => { version => 2 },
      prereqs => {
        runtime => {
          requires => {
            perl => '5.008001',
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

package MY;

sub depend {
  use Config;
  use Cwd;
  my $lib = File::Spec->catdir(getcwd(),"lib");
  my $CORE = File::Spec->catdir($Config{archlibexp},"CORE");
  my $stupid = File::Spec->catdir($lib,$Config{archlibexp},"CORE","opnames.ph");
  my $opnames_dep = File::Spec->catdir($CORE,"opnames.h");
  my $h2ph = File::Spec->catdir($Config{installbin}, "h2ph");
  my $h2ph_pre = File::Spec->catdir("lib", "_h2ph_pre.ph");
  "
$h2ph_pre : $opnames_ph

$opnames_ph : $opnames_dep Makefile
	\$(RM) $h2ph_pre
	\$(FULLPERL) $h2ph -d lib $opnames_dep
	\$(MV) $stupid lib
	\$(RM_RF) $stupid

$h2ph_blib : $h2ph_pre
	\$(CP) \$< \$@

$opnames_blib : $opnames_ph
	\$(CP) \$< \$@
"
}

sub postamble {
"
config :: $h2ph_blib $opnames_blib
";
}
