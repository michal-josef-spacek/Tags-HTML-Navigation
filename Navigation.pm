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

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Navigation - Tags helper for navigator.

=head1 SYNOPSIS

 use Tags::HTML::Navigation;

 my $obj = Tags::HTML::Navigation->new(%params);
 $obj->process;
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Navigation->new(%params);

Constructor.

=over 8

=item * C<css>

'CSS::Struct::Output' object for L<process_css> processing.

Default value is undef.

=item * C<css_navigator>

Main CSS class of this block.

Default value is 'navigator'.

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process;

Process Tags structure for output with navigator.

Returns undef.

=head2 C<process_css>

 $obj->process_css;

Process CSS::Struct structure for output.

Returns undef.

=head1 ERRORS

 new():
         Navigation item must be a 'Data::HTML::Navigation' instance.
         Parameter 'navigation_items' is required.
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
         From Tags::HTML::new():
                 Parameter 'tags' must be a 'Tags::Output::*' class.

=head1 EXAMPLE

 use strict;
 use warnings;

 use CSS::Struct::Output::Indent;
 use Data::HTML::Navigation;
 use Tags::HTML::Navigation;
 use Tags::Output::Indent;

 # Object.
 my $css = CSS::Struct::Output::Indent->new;
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Navigation->new(
         'css' => $css,
         'navigation_items' => [
                 Data::HTML::Navigation->new(
                         'active' => 1,
                         'title' => 'Main page',
                         'url' => 'https://example.com/main',
                 ),
                 Data::HTML::Navigation->new(
                         'title' => 'Help',
                         'url' => 'https://example.com/help',
                 ),
         ],
         'tags' => $tags,
 );

 # Process pager.
 $obj->process;
 $obj->process_css;

 # Print out.
 print $tags->flush;
 print "\n\n";
 print $css->flush;

 # Output:
 # <nav class="navigation">
 #   <ul>
 #     <li>
 #       <a title="Main page" href="https://example.com/main" class=
 #         "navigation-active">
 #         Main page
 #       </a>
 #     </li>
 #     <li>
 #       <a title="Help" href="https://example.com/help">
 #         Help
 #       </a>
 #     </li>
 #   </ul>
 # </nav>
 # 
 # .navigation {
 # }

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<Tags::HTML>,
L<List::Util>,
L<Scalar::Util>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Navigation>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© Michal Josef Špaček 2022

BSD 2-Clause License

=head1 VERSION

0.01

=cut
