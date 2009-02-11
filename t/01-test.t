#!perl

use lib qw(t/lib);

BEGIN {
    use Test::DBIC;

    eval 'require DBD::SQLite';
    if ($@) {
        plan skip_all => 'DBD::SQLite not installed';
    } else {
        plan tests => 2;  # change this to the correct number of tests
    }
};

Test::DBIC->db_dir('t/var');
Test::DBIC->db_file("test.db");
my $schema = Test::DBIC->init_schema(
	schema_class => "MySchema",
	sqlt_deploy => 1,
);



my $master = $schema->resultset('Master')->create({ id => 1 });

# filler

$master->create_related( 'user', {
        name      => 'filler',
        addresses => [ { address => 'somewhere', }, { address => 'somewhere else', } ],
 		} );

my $band1 = $schema->resultset('Band')->create({ band => 'band 1'});
my $band2 = $schema->resultset('Band')->create({ band => 'band 2'});

my $user = $schema->resultset('User')->search({},{})->first;

$user->add_to_bands($band1);

$user->add_to_bands($band2);

is($user->name, 'filler');

#use Data::Dumper;
#my $d = Data::Dumper->new([$user->as_object]);
#$d->Indent(0);
#print $d->Dump;


is_deeply($user->as_object, {'addresses' => [{'id_1' => '1','user' => {'name_1' => 'filler','id_1' => '1'},'address_1' => 'somewhere'},{'id_2' => '2','user' => {'id_2' => '1','name_2' => 'filler'},'address_2' => 'somewhere else'}],'name' => 'filler','bands' => [{'id_1' => '1','band_1' => 'band 1'},{'id_2' => '2','band_2' => 'band 2'}]});