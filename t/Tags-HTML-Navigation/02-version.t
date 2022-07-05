use strict;
use warnings;

use Tags::HTML::Navigation;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Tags::HTML::Navigation::VERSION, 0.01, 'Version.');
