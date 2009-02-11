use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'DBIx::Class::AsObject',
    AUTHOR              => 'Moritz Onken <onken@houseofdesign.de>',
    VERSION_FROM        => 'lib/DBIx/Class/AsObject.pm',
    ABSTRACT_FROM       => 'lib/DBIx/Class/AsObject.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
		'Test::DBIC' => 0,
		'HTML::FormFu' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'DBIx-Class-AsObject-*' },
);
