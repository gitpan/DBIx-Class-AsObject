package DBIx::Class::AsObject;

use strict;
use warnings;

our $VERSION = '0.09_01';

use base qw( DBIx::Class );

use File::Spec;

use HTML::FormFu;

__PACKAGE__->mk_classdata('as_object_dir' => 'asobject');

__PACKAGE__->mk_classdata('as_object_filename');


sub as_object {
	my $self = shift;
	my $filename = $self->as_object_filename || $self->_as_object_get_filename;
	
	my $form = new HTML::FormFu;
	$form->load_config_file(File::Spec->catfile($self->as_object_dir, $filename));
	
	$form->model->default_values($self);
	
	my @elements = $form->get_elements;
	return _as_object_get($form);
}

# Never dare to ask why this works!!!

sub _as_object_get {
	my $e = shift;
	my $elements = $e->get_elements;
	my $dump;
	
	for my $element (@{$elements}) {
		if($element->can('elements') && !$element->nested_name) {
			$dump ||= [];
			push(@{$dump}, _as_object_get($element));
		} elsif($element->can('elements')) {
			$dump ||= {};
		    $dump->{$element->nested_name} = _as_object_get($element);
		} else {
			$dump ||= {};
			$dump->{$element->name} = _as_object_get($element);
		}
	}
	return $e->default if($e->can('default'));
	return $dump;
	
}


sub _as_object_get_filename {
	my $self = shift;
	my $filename = "".$self;
	$filename =~ s/=HASH\(.*?\)//;
	return lc(File::Spec->catdir(split(/::/, "".$filename))). ".yml";
}



1;