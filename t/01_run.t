use v5.14;
use warnings;
use Encode;
use utf8;

use Test::More;
use Data::Dumper;

use lib '.';
use t::Util;

sub line {
    my($text, $line, $comment) = @_;
    like($text, qr/\A(.*\n){$line}\z/, $comment//'');
}

is( subst(qw(--dict t/JA.dict t/JA-bad.txt))->{result}, 0);
line( subst(qw(--dict t/JA.dict t/JA-bad.txt))->{stdout}, 9, "--dict");
line( subst(qw(--dict t/JA.dict t/JA-bad.txt --stat))->{stdout}, 11, "--stat");
line( subst(qw(--dict t/JA.dict t/JA-bad.txt --with-stat))->{stdout}, 20, "--with-stat");
line( subst(qw(--dict t/JA.dict t/JA-bad.txt --with-stat --stat-item dict=1))->{stdout}, 21, "dict=1");

line( subst(qw(--dict t/JA.dict t/JA-bad.txt --diff))->{stdout}, 28, "--diff");

line( subst(
	'--dictdata',
	"イーハトー(ヴォ|ボ)	イーハトーヴォ\n",
	't/JA-bad.txt')->{stdout}, 2, "--dictdata");

line( subst(
	'--dictdata',
	"イーハトー(ヴォ|ボ)	イーハトーヴォ\n".
	"デストゥ?パーゴ	デストゥパーゴ\n",
	't/JA-bad.txt')->{stdout}, 3, "--dictdata (2)");

done_testing;
