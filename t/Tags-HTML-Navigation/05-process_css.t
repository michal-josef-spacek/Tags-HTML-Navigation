use strict;
use warnings;

use CSS::Struct::Output::Structure;
use Data::HTML::Navigation;
use Tags::HTML::Navigation;
use Test::More 'tests' => 4;
use Test::NoWarnings;

# Test.
my $css = CSS::Struct::Output::Structure->new;
my $obj = Tags::HTML::Navigation->new(
	'css' => $css,
);
$obj->process_css;
my $ret_ar = $css->flush(1);
is_deeply(
	$ret_ar,
	[],
	'Navigation CSS code (no items).',
);

# Test.
$css = CSS::Struct::Output::Structure->new;
$obj = Tags::HTML::Navigation->new(
	'css' => $css,
	'navigation_items' => [
		Data::HTML::Navigation->new(
			'title' => 'Menu',
			'url' => 'https://example.com/menu',
		),
	],
);
$obj->process_css;
$ret_ar = $css->flush(1);
is_deeply(
	$ret_ar,
	[
		['s', '.navigation'],
		['e'],
	],
	'Navigation CSS code (1 item).',
);

# Test.
$css = CSS::Struct::Output::Structure->new;
$obj = Tags::HTML::Navigation->new(
	'css' => $css,
	'css_navigation' => 'foo',
	'navigation_items' => [
		Data::HTML::Navigation->new(
			'title' => 'Menu',
			'url' => 'https://example.com/menu',
		),
	],
);
$obj->process_css;
$ret_ar = $css->flush(1);
is_deeply(
	$ret_ar,
	[
		['s', '.foo'],
		['e'],
	],
	'Navigation CSS code (1 item, explicit CSS class).',
);
