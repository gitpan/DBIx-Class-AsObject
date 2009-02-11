#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DBIx::Class::AsObject' );
}

diag( "Testing DBIx::Class::AsObject $DBIx::Class::AsObject::VERSION, Perl $], $^X" );
