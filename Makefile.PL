use strict;
use warnings;
use ExtUtils::MakeMaker;

# Normalize version strings like 6.30_02 to 6.3002,
# so that we can do numerical comparisons on it.
my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ s/_//;

WriteMakefile(
    NAME                => 'Parse',
    AUTHOR              => q{YOUR NAME <youremail@example.com>},
    VERSION_FROM        => 'lib/Parse.pm',
    ABSTRACT            => 'YOUR APPLICATION ABSTRACT',
    ($eumm_version >= 6.3001
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'        => 0,
        'YAML'              => 0,
        'Dancer2'           => 0.205002,
        'Modern::Perl'      => 0,
        'LWP'               => 5.64,
        'HTTP::Cookies'     => 0,
        'Encode'            => 0,
        'DBI'               => 0,
        'DBD:Mysql'         => 0,
        'Test::Spec'        => 0.54,
        'Test::Spec::Mocks' => 0
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Parse-*' },
);
