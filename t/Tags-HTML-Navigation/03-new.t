use strict;
use warnings;

use Data::HTML::Navigation;
use English;
use Error::Pure::Utils qw(clean err_msg);
use Tags::HTML::Navigation;
use Tags::Output::Raw;
use Test::More 'tests' => 8;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::Navigation->new;
isa_ok($obj, 'Tags::HTML::Navigation');

# Test.
$obj = Tags::HTML::Navigation->new(
	'tags' => Tags::Output::Raw->new,
);
isa_ok($obj, 'Tags::HTML::Navigation');

# Test.
$obj = Tags::HTML::Navigation->new(
	'navigation_items' => [
		Data::HTML::Navigation->new(
			'title' => 'Title',
			'url' => 'title/',
		),
	],
);
isa_ok($obj, 'Tags::HTML::Navigation');

# Test.
eval {
	Tags::HTML::Navigation->new(
		'tags' => 'foo',
	);
};
is(
	$EVAL_ERROR,
	"Parameter 'tags' must be a 'Tags::Output::*' class.\n",
	"Missing required parameter 'tags'.",
);
clean();

# Test.
eval {
	Tags::HTML::Navigation->new(
		'tags' => Tags::HTML::Navigation->new,
	);
};
is(
	$EVAL_ERROR,
	"Parameter 'tags' must be a 'Tags::Output::*' class.\n",
	"Bad 'Tags::Output' instance.",
);
clean();

# Test.
eval {
	Tags::HTML::Navigation->new(
		'navigation_items' => undef,
	);
};
is(
	$EVAL_ERROR,
	"Parameter 'navigation_items' is required.\n",
	"Parameter 'navigation_items' is required.",
);
clean();

# Test.
eval {
	Tags::HTML::Navigation->new(
		'navigation_items' => [undef],
	);
};
is(
	$EVAL_ERROR,
	"Navigation item must be a 'Data::HTML::Navigation' instance.\n",
	"Navigation item must be a 'Data::HTML::Navigation' instance.",
);
clean();
