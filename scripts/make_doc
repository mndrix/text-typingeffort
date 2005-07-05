#!/usr/bin/perl

use Pod::Simple::HTMLBatch;

my $b = Pod::Simple::HTMLBatch->new;
$b->css_flurry( 0 );
$b->add_css( 'pod.css', 1 );
$b->javascript_flurry( 0 );

$b->batch_convert('lib', 'doc');
