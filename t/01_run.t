use v5.14;
use warnings;
use Encode;

use Test::More;
use Data::Dumper;

use lib '.';
use t::Util;

sub line {
    my($text, $line) = @_;
    like($text, qr/\A(.*\n){$line}\z/);
}

is( subst(qw(--dict t/JA.dict t/JA-bad.txt))->{result}, 0);
line( subst(qw(--dict t/JA.dict t/JA-bad.txt))->{stdout}, 9);
line( subst(qw(--dict t/JA.dict t/JA-bad.txt --stat))->{stdout}, 11);
line( subst(qw(--dict t/JA.dict t/JA-bad.txt --with-stat))->{stdout}, 20);
line( subst(qw(--dict t/JA.dict t/JA-bad.txt --with-stat --stat-item dict=1))->{stdout}, 21);

done_testing;
