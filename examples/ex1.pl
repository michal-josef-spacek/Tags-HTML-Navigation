#!/usr/bin/env perl

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