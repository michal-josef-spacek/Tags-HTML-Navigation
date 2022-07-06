use strict;
use warnings;

use Data::HTML::Navigation;
use Tags::HTML::Navigation;
use Tags::Output::Structure;
use Test::More 'tests' => 4;
use Test::NoWarnings;

# Test.
my $tags = Tags::Output::Structure->new;
my $obj = Tags::HTML::Navigation->new(
	'tags' => $tags,
);
$obj->process;
my $ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[],
	'Navigation HTML code (no items).',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Navigation->new(
	'navigation_items' => [
		Data::HTML::Navigation->new(
			'title' => 'Menu',
			'url' => 'https://example.com/menu',
		),
	],
	'tags' => $tags,
);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'nav'],
		['a', 'class', 'navigation'],
		['b', 'ul'],
		['b', 'li'],
		['b', 'a'],
		['a', 'title', 'Menu'],
		['a', 'href', 'https://example.com/menu'],
		['d', 'Menu'],
		['e', 'a'],
		['e', 'li'],
		['e', 'ul'],
		['e', 'nav'],
	],
	'Navigation HTML code (1 item).',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Navigation->new(
	'navigation_items' => [
		Data::HTML::Navigation->new(
			'title' => 'Menu',
			'url' => 'https://example.com/menu',
		),
		Data::HTML::Navigation->new(
			'title' => 'Main page',
			'url' => 'https://example.com/main_page',
		),
	],
	'tags' => $tags,
);
$obj->process;
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'nav'],
		['a', 'class', 'navigation'],
		['b', 'ul'],
		['b', 'li'],
		['b', 'a'],
		['a', 'title', 'Menu'],
		['a', 'href', 'https://example.com/menu'],
		['d', 'Menu'],
		['e', 'a'],
		['e', 'li'],
		['b', 'li'],
		['b', 'a'],
		['a', 'title', 'Main page'],
		['a', 'href', 'https://example.com/main_page'],
		['d', 'Main page'],
		['e', 'a'],
		['e', 'li'],
		['e', 'ul'],
		['e', 'nav'],
	],
	'Navigation HTML code (2 items).',
);
