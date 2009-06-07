use strict;
use warnings;

use Test::More tests => 64;

use Unicode::Digits qw/digits_to_dual/;

my $warn = '';
$SIG{__WARN__} = sub { $warn = join '', @_ };

sub test {
	my ($mode, $string, $num, $name, $warning) = @_;
	my $result = digits_to_dual $string, $mode;
	my $w = $warn;
	is $result, $string, $name;
	is 0+$result, $num,    $name;
	is $w, $warning, $name;
	$warn = '';
}

test undef, "42",                    42, "a", "";
test undef, "\x{1814}\x{1812}",      42, "b", "";
test undef, "4\x{1812}",             42, "c", "";
test undef, "a is \x{06f4}\x{06f2}", 42, "d", "";

test "loosest", "42",                    42, "e", "";
test "loosest", "\x{1814}\x{1812}",      42, "f", "";
test "loosest", "4\x{1812}",             42, "g", "";
test "loosest", "a is \x{06f4}\x{06f2}", 42, "h", "";

test "looser", "42",               42, "i", "";
test "looser", "\x{1814}\x{1812}", 42, "j", "";
test "looser", "4\x{1812}",        42, "k", "string '4\x{1812}' contains digits from different ranges at t/02-digits_to_dual.t line 11\n";
test "looser", "a is \x{06f4}\x{06f2}", 42, "l", "string 'a is \x{06f4}\x{06f2}' contains non-digit characters at t/02-digits_to_dual.t line 11\n";

test "loose", "42",               42, "m", "";
test "loose", "\x{1814}\x{1812}", 42, "n", "";
test "loose", "4\x{1812}",        42, "o", "string '4\x{1812}' contains digits from different ranges at t/02-digits_to_dual.t line 11\n";
eval { digits_to_dual "a is \x{06f4}\x{06f2}", "loose" };
is $@, "string 'a is \x{06f4}\x{06f2}' contains non-digit characters at t/02-digits_to_dual.t line 39\n", "p";

test "strict", "42",               42, "q", "";
test "strict", "\x{1814}\x{1812}", 42, "r", "";
eval { digits_to_dual "4\x{1812}", "strict" };
is $@, "string '4\x{1812}' contains digits from different ranges at t/02-digits_to_dual.t line 43\n", "s";
eval { digits_to_dual "a is \x{06f4}\x{06f2}", "strict" };
is $@, "string 'a is \x{06f4}\x{06f2}' contains non-digit characters at t/02-digits_to_dual.t line 45\n", "t";
