#!/usr/bin/perl

use strict;
use warnings;

use blib;

use Unicode::Digits qw/digits_to_dual/;

my $n = digits_to_dual "\x{1815}";

print "$n is ", $n + 0, "\n";
