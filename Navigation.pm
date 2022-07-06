package Tags::HTML::Navigation;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use List::Util qw(none);
use Scalar::Util qw(blessed);

our $VERSION = 0.01;

sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_navigation', 'navigation_items'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# CSS class.
	$self->{'css_navigation'} = 'navigation';

	# Navigation items.
	$self->{'navigation_items'} = [];

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check navigation items.
	if (! defined $self->{'navigation_items'}) {
		err "Parameter 'navigation_items' is required.";
	}
	foreach my $navigation_item (@{$self->{'navigation_items'}}) {
		if (! blessed($navigation_item)
			|| ! $navigation_item->isa('Data::HTML::Navigation')) {

			err "Navigation item must be a 'Data::HTML::Navigation' instance.";
		}
	}

	# Object.
	return $self;
}

sub _process {
	my $self = shift;

	# No navigation items.
	if (! @{$self->{'navigation_items'}}) {
		return;
	}

	$self->{'tags'}->put(
		['b', 'nav'],
		['a', 'class', $self->{'css_navigation'}],
		['b', 'ul'],
	);
	foreach my $navigation_item (@{$self->{'navigation_items'}}) {
		$self->{'tags'}->put(
			['b', 'li'],
			['b', 'a'],
			['a', 'title', $navigation_item->title],
			['a', 'href', $navigation_item->url],
			$navigation_item->active ? (
				['a', 'class', $self->{'css_navigation'}.'-active'],
			) : (),
			['d', $navigation_item->title],
			['e', 'a'],
			['e', 'li'],
		);
	}
	$self->{'tags'}->put(
		['e', 'ul'],
		['e', 'nav'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	# No navigation items.
	if (! @{$self->{'navigation_items'}}) {
		return;
	}

	$self->{'css'}->put(
		['s', '.'.$self->{'css_navigation'}],
		# TODO
		['e'],
	);

	return;
}

1;
