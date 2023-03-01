=encoding utf8

=head1 NAME

subst - テキスト検索と置換のための Greple モジュール

=head1 VERSION

Version 2.32

=head1 SYNOPSIS

greple -Msubst --dict I<dictionary> [ オプション ]。

  Dictionary:
    --dict      dictionary file
    --dictdata  dictionary data

  Check:
    --check=[ng,ok,any,outstand,all,none]
    --select=N
    --linefold
    --stat
    --with-stat
    --stat-style=[default,dict]
    --stat-item={match,expect,number,ok,ng,dict}=[0,1]
    --subst
    --[no-]warn-overlap
    --[no-]warn-include

  File Update:
    --diff
    --diffcmd command
    --create
    --replace
    --overwrite

=head1 DESCRIPTION

この B<greple> モジュールは、辞書データに基づくテキストファイルのチェックと置換をサポートする。

辞書ファイルはB<--dict>オプションで与えられ、各行にはマッチするパターンと期待される文字列のペアが含まれる。

    greple -Msubst --dict DICT

辞書ファイルが以下のようなデータを含んでいる場合

    colou?r      color
    cent(er|re)  center

上記のコマンドは、2番目の文字列にマッチしない最初のパターン、つまり、この場合、"color "と "center "を見つける。

辞書データのフィールドC<//>は無視されるので、このファイルはこのように書くことができる。

    colou?r      //  color
    cent(er|re)  //  center

B<greple>のB<-f>オプションで同じファイルを使うこともでき、その場合はC<//>の後ろの文字列はコメントとして無視される。

    greple -f DICT ...

B<--dictdata>オプションは、コマンドラインで辞書データを提供するために使用することができる。

    greple --dictdata $'colou?r color\ncent(er|re) center\n'

シャープ記号(C<#>)で始まる辞書項目はコメントとなり、無視される。

=head2 Overlapped pattern

マッチした文字列が、以前に別のパターンでマッチした文字列と同じか短い場合は、単に無視される (デフォルトでは B<--no-warn-include>)。したがって、矛盾するパターンを宣言する必要がある場合は、長い方のパターンを先に配置する。

マッチした文字列が前にマッチした文字列と重なる場合、警告を出し (デフォルトでは B<--warn-overlap)、無視される。

=head2 Terminal color

このバージョンでは、L<Getopt::EX::termcolor> モジュールを使用する。これは、コマンドを実行した端末、または環境変数B<TERM_BGCOLOR>に応じて、B<--light-screen>またはB<--dark-screen>オプションを設定する。

一部の端末 (例: "Apple_Terminal" や "iTerm") は自動的に検出され、何もする必要はない。それ以外の場合は、B<TERM_BGCOLOR>環境変数に#000000（黒）〜#FFFFFF（白）の数字を設定し、端末の背景色に依存する。

=head1 OPTIONS

=over 7

=item B<--dict>=I<file>

辞書ファイルを指定する。

=item B<--dictdata>=I<data>

辞書データをテキストで指定する。

=item B<--check>=C<outstand>|C<ng>|C<ok>|C<any>|C<all>|C<none>

オプションB<--check>は、C<ng>, C<ok>, C<any>, C<outstand>, C<all>, C<none>から引数を取る。

デフォルトのC<outstand>では、同じファイルに予想外の単語があった場合のみ、予想外の単語と予想外の単語の両方についての情報を表示する。

C<ng>を指定すると、予期しない単語についての情報を表示する。値C<ok>を指定すると、予想される単語についての情報を表示する。値C<any>の場合は両方である。

C<all>とC<none>はB<--stat>オプションと一緒に使われたときだけ意味があり、マッチしなかったパターンに関する情報を表示する。

=item B<--select>=I<N>

I<N>番目のエントリを辞書から選択する。引数はL<Getopt::EX::Numbers>モジュールによって解釈される。範囲はB<--select>=C<1:3,7:9>のように定義することができる。B<--stat>オプションで数値を取得することができる。

=item B<--linefold>

B<--linefold>オプションは、対象データがテキストの途中で折り返されている場合に使用する。行をまたぐ文字列にマッチする正規表現パターンが作成される。ただし、置換される文字列には改行が含まれない。正規表現の動作を多少混乱させるので、なるべく使わないでください。

=item B<--stat>

=item B<--with-stat>

統計情報を表示する。B<--check>オプションと併用する。

B<--with-stat>オプションは通常の出力の後に統計情報を出力し、B<--stat>は統計情報のみを出力する。

=item B<--stat-style>=C<default>|C<dict>

B<--stat>とB<--check=any>にB<--stat-style=dict>オプションを併用すると、作業文書に対して辞書風の出力を行うことができる。

=item B<--stat-item> I<item>=[0,1]

統計情報に表示される項目を指定する。デフォルト値は

    match=1
    expect=1
    number=1
    ng=1
    ok=1
    dict=0

patternフィールドを表示する必要がない場合は、このように使用する。

    --stat-item match=0

複数のパラメータを一度に設定することができる。

    --stat-item match=number=0,ng=1,ok=1

=item B<--subst>

マッチしたパターンを期待される文字列に置き換える。マッチした文字列の改行文字は無視される。置換文字列のないパターンは変更されない。

=item B<--[no-]warn-overlap>

オーバーラップしたパターンを警告する。デフォルトはonである。

=item B<--[no-]warn-include>

含まれるパターンを警告する。デフォルトはオフ。

=back

=head2 FILE UPDATE OPTIONS

=over 7

=item B<--diff>

=item B<--diffcmd>=I<command>

B<--diff>オプションは、変換前のテキストと変換後のテキストの差分を出力する。

B<--diff>オプションで使用するdiffコマンド名を指定する。デフォルトは "diff -u "である。

=item B<--create>

新規ファイルを作成し、結果を書き込む。元のファイル名の末尾に".new "が付加される。

=item B<--replace>

対象ファイルを変換後の結果で置き換える。元ファイルはバックアップ名に".bak "を付けてリネームされる。

=item B<--overwrite>

バックアップを取らずに、変換後のファイルを上書きする。

=back

=head1 DICTIONARY

本モジュールには、サンプル辞書が含まれている。これらは共有ディレクトリにインストールされ、B<--exdict>オプションでアクセスすることができる。

    greple -Msubst --exdict jtca-katakana-guide-3.dict

=over 7

=item B<--exdict> I<dictionary>

辞書ファイルとしては、配布されているI<dictionary> flieを使用する。

=item B<--exdictdir>

辞書ディレクトリを表示する。

=item B<--exdict> jtca-katakana-guide-3.dict

=item B<--jtca-katakana-guide>

以下のガイドラインに基づいて作成されている。

    外来語（カタカナ）表記ガイドライン 第3版
    制定：2015年8月
    発行：2015年9月
    一般財団法人テクニカルコミュニケーター協会 
    Japan Technical Communicators Association
    https://www.jtca.org/standardization/katakana_guide_3_20171222.pdf

=item B<--jtca>

B<--jtca-katakana-guide>をカスタマイズしたもの。オリジナルの辞書は公開されたデータから自動生成されたものである。この辞書は、実用のためにカスタマイズされている。

=item B<--exdict> jtf-style-guide-3.dict

=item B<--jtf-style-guide>

以下のガイドラインに基づいて作成されている。

    JTF日本語標準スタイルガイド（翻訳用）
    第3.0版
    2019年8月20日
    一般社団法人 日本翻訳連盟（JTF）
    翻訳品質委員会
    https://www.jtf.jp/jp/style_guide/pdf/jtf_style_guide.pdf

=item B<--jtf>

カスタマイズB<--jtf-style-guide>。オリジナル辞書は公開データから自動生成される。この辞書は、実用に耐えるようにカスタマイズされている。

=item B<--exdict> sccc2.dict

=item B<--sccc2>

2014年に出版された「C/C++ セキュアコーディング 第2版」で使用された辞書。

    https://www.jpcert.or.jp/securecoding_book_2nd.html

=item B<--exdict> ms-style-guide.dict

=item B<--ms-style-guide>

Microsoftのローカライズスタイルガイドから生成された辞書。

    https://www.microsoft.com/ja-jp/language/styleguides

本記事から生成されたデータである。

    https://www.atmarkit.co.jp/news/200807/25/microsoft.html

=item B<--microsoft>

カスタマイズされたB<--ms-style-guide>。オリジナルの辞書は、公開されたデータから自動生成されたものである。本辞書は、実用化に向けてカスタマイズしたものである。

修正辞書は、L<こちら|https://github.com/kaz-utashiro/greple-subst/blob/master/share/ms-amend.dict>で見ることができる。更新の要望があれば、issueを送るか、pull-requestを送信してください。

=back

=head1 JAPANESE

このモジュールは、日本語のテキスト編集をサポートするためにオリジナルで作成された。

=head2 KATAKANA

日本語のカタカナ語は、同じ言葉を表すのにいくつものバリエーションがあるので、統一することが重要だが、かなり面倒な作業である。次の例では

    イ[エー]ハトー?([ヴブボ]ォ?)  //  イーハトーヴォ

左のパターンは、次の単語全てにマッチする。

    イエハトブ
    イーハトヴ
    イーハトーヴ
    イーハトーヴォ
    イーハトーボ
    イーハトーブ

このモジュールは、これらの単語を検出し、修正するのに役立つ。

=head1 INSTALL

=head2 CPANMINUS

    $ cpanm App::Greple::subst

=head1 SEE ALSO

L<https://github.com/kaz-utashiro/greple>

L<https://github.com/kaz-utashiro/greple-subst>

L<https://github.com/kaz-utashiro/greple-update>

L<https://www.jtca.org/standardization/katakana_guide_3_20171222.pdf>

L<https://www.jtf.jp/jp/style_guide/styleguide_top.html>, L<https://www.jtf.jp/jp/style_guide/pdf/jtf_style_guide.pdf>

L<https://www.microsoft.com/ja-jp/language/styleguides>，L<https://www.atmarkit.co.jp/news/200807/25/microsoft.html>。

L＜文化庁 国語施策・日本語教育 国語施策情報 内閣告示・内閣訓 外来語の表記|https://www.bunka.go.jp/kokugo_nihongo/sisaku/joho/joho/kijun/naikaku/gairai/index.html>

L<https://qiita.com/kaz-utashiro/items/85add653a71a7e01c415>

L<イーハトーブ|https://ja.wikipedia.org/wiki/%E3%82%A4%E3%83%BC%E3%83%8F%E3%83%88%E3%83%BC%E3%83%96>

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright 2017-2023 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


use v5.14;
package App::Greple::subst;

our $VERSION = '2.32';

use warnings;
use utf8;
use open IO => ':utf8';

use Exporter 'import';
our @EXPORT      = qw(
    &subst_initialize
    &subst_begin
    &subst_diff
    &subst_divert
    &subst_update
    &subst_show_stat
    &subst_search
    );
our %EXPORT_TAGS = ( );
our @EXPORT_OK   = qw();

use Carp;
use Data::Dumper;
use Text::ParseWords qw(shellwords);
use Encode;
use Getopt::EX::Colormap qw(colorize);
use Getopt::EX::LabeledParam;
use App::Greple::Common;
use App::Greple::Pattern;
use App::Greple::subst::Dict;

use File::Share qw(:all);
$ENV{GREPLE_SUBST_DICT} //= dist_dir 'App-Greple-subst';

our $debug = 0;
our $remember_data = 1;
our $opt_subst = 0;
our @opt_subst_from;
our @opt_subst_to;
our @opt_dictfile;
our @opt_dictdata;
our $opt_printdict;
our $opt_dictname;
our $opt_check = 'outstand';
our @opt_format;
our @default_opt_format = ( '%s' );
our $opt_subst_select;
our $opt_linefold;
our $opt_ignore_space = 1;
our $opt_warn_overlap = 1;
our $opt_warn_include = 0;
our $opt_stat_style = "default";
our @opt_stat_item;
our %opt_stat_item = (
    map( { $_ => 1 } qw(match expect number ng ok) ),
    map( { $_ => 0 } qw(dict) ),
    );
our $opt_show_comment = 0;
our $opt_show_numbers = 1;
my %stat;

my $current_file;
my $contents;
my $ignorechar_re;
my @dicts;

sub debug {
    $debug = 1;
}

sub subst_initialize {

    state $once_called++ and return;

    Getopt::EX::LabeledParam
	->new(HASH => \%opt_stat_item)
	->load_params(@opt_stat_item);

    @opt_format = @default_opt_format if @opt_format == 0;

    $ignorechar_re = $opt_ignore_space ? qr/\s+/ : qr/\R+/;

    my $config = { linefold  => $opt_linefold,
		   dictname  => $opt_dictname,
		   printdict => $opt_printdict };
    for my $data (@opt_dictdata) {
	push @dicts, App::Greple::subst::Dict->new(
	    DATA => $data,
	    CONFIG => $config,
	    );
    }
    for my $file (@opt_dictfile) {
	if (-d $file) {
	    warn "$file is directory\n";
	    next;
	}
	push @dicts, App::Greple::subst::Dict->new(
	    FILE => $file,
	    CONFIG => $config,
	    );
    }

    if (@dicts == 0) {
	warn "Module -Msubst requires dictionary data.\n";
	main::usage();
	die;
    }
}

sub subst_begin {
    my %arg = @_;
    $current_file = delete $arg{&FILELABEL} or die;
    $contents = $_ if $remember_data;
}

#
# define &divert_stdout and &recover_stdout
#
{
    my $diverted = 0;
    my $buffer;

    sub divert_stdout {
	$buffer = @_ ? shift : '/dev/null';
	$diverted = $diverted == 0 ? 1 : return;
	open  SUBST_STDOUT, '>&', \*STDOUT or die "open: $!";
	close STDOUT;
	open  STDOUT, '>', $buffer or die "open: $!";
    }

    sub recover_stdout {
	$diverted = $diverted == 1 ? 0 : return;
	close STDOUT;
	open  STDOUT, '>&', \*SUBST_STDOUT or die "open: $!";
    }
}

use Text::VisualWidth::PP;
use Text::VisualPrintf qw(vprintf vsprintf);
use List::Util qw(max any sum first);

sub vwidth {
    if (not defined $_[0] or length $_[0] == 0) {
	return 0;
    }
    Text::VisualWidth::PP::width $_[0];
}

my @match_list;

sub subst_show_stat {
    my %arg = @_;
    my($from_max, $to_max) = (0, 0);
    my $i = -1;
    my @show_list;
    for my $dict (@dicts) {
	my @fromto = $dict->words;
	my @show;
	for my $p (@fromto) {
	    $i++;
	    $p // die;
	    if ($p->is_comment) {
		push @show, [ $i, $p, {} ] if $opt_show_comment;
		next;
	    }
	    my($from_re, $to) = ($p->string, $p->correct // '');
	    my $hash = $match_list[$i] // {};
	    my @keys = keys %{$hash};
	    my @ng = grep { $_ ne $to } @keys;
	    my @ok = grep { $_ eq $to } @keys;
	    if    ($opt_check eq 'none'    ) { next if @keys != 0 }
	    elsif ($opt_check eq 'any'     ) { next if @keys == 0 }
	    elsif ($opt_check eq 'ok'      ) { next if @ok   == 0 }
	    elsif ($opt_check eq 'ng'      ) { next if @ng   == 0 }
	    elsif ($opt_check eq 'outstand') { next if @ng   == 0 }
	    elsif ($opt_check eq 'all')      { }
	    else { die }
	    $from_max = max $from_max, vwidth $from_re;
	    $to_max   = max $to_max  , vwidth $to;
	    push @show, [ $i, $p, $hash ];
	}
	push @show_list, [ $dict => \@show ];
    }
    if ($opt_show_numbers) {
	no warnings 'uninitialized';
	printf "HIT_PATTERN=%d/%d NG=%d, OK=%d, TOTAL=%d\n",
	    $stat{hit}, $stat{total},
	    $stat{ng}, $stat{ok}, $stat{ng} + $stat{ok};
    }
    for my $show_list (@show_list) {
	my($dict, $show) = @{$show_list};
	next if @$show == 0;
	my $dict_format = ">>> %s <<<\n";
	if ($opt_stat_item{dict}) {
	    print colorize('000/L24E', sprintf($dict_format, $dict->NAME));
	}
	for my $item (@$show) {
	    my($i, $p, $hash) = @$item;
	    if ($p->is_comment) {
		say $p->comment if $opt_show_comment;
		next;
	    }
	    my($from_re, $to) = ($p->string, $p->correct // '');
	    my @keys = keys %{$hash};
	    if ($opt_stat_style eq 'dict') {
		vprintf("%-${from_max}s // %s", $from_re // '', $to // '');
	    } else {
		my @ng = sort { $hash->{$b} <=> $hash->{$a} } grep { $_ ne $to } @keys
		    if $opt_stat_item{ng};
		my @ok = grep { $_ eq $to } @keys
		    if $opt_stat_item{ok};
		vprintf("%${from_max}s => ", $from_re // '') if $opt_stat_item{match};
		vprintf("%-${to_max}s",      $to // '')      if $opt_stat_item{expect};
		vprintf(" %4d:",             $i + 1)         if $opt_stat_item{number};
		for my $key (@ng, @ok) {
		    my $index = $key eq $to ? $i * 2 + 1 : $i * 2;
		    printf(" %s(%s)",
			   main::index_color($index, $key),
			   colorize($key eq $to ? 'DB' : 'DR', $hash->{$key})
			);
		}
	    }
	    print "\n";
	}
    }
    $_ = "";
}

use App::Greple::Regions qw(match_regions merge_regions filter_regions);

sub subst_search {
    my $text = $_;
    my %arg = @_;
    $current_file = delete $arg{&FILELABEL} or die;

    my @matched;
    my $index = -1;
    my @effective;
    my $ng = {ng=>1,        any=>1, all=>1, none=>1}->{$opt_check} ;
    my $ok = {       ok=>1, any=>1, all=>1, none=>1}->{$opt_check} ;
    my $outstand = $opt_check eq 'outstand';
    for my $dict (@dicts) {
	for my $p ($dict->words) {
	    $index++;
	    $p // next;
	    next if $p->is_comment;
	    my($from_re, $to) = ($p->string, $p->correct // '');
	    my @match = match_regions pattern => $p->regex;

	    ##
	    ## Remove all overlapped matches.
	    ##
	    my($in, $over, $out, $im, $om) = filter_regions \@match, \@matched;
	    @match = @$out;
	    for my $warn (
		[ "Include", $in,   $im, $opt_warn_include ],
		[ "Overlap", $over, $om, $opt_warn_overlap ],
		) {
		my($kind, $list, $match, $show) = @$warn;
		$show and @$list or next;
		for my $i (0 .. @$list - 1) {
		    my($a, $b) = ($list->[$i], $match->[$i]);
		    warn sprintf("%s \"%s\" with \"%s\" by #%d /%s/ in %s at %d\n",
				 $kind,
				 substr($_, $a->[0], $a->[1] - $a->[0]),
				 substr($_, $b->[0], $b->[1] - $b->[0]),
				 $index + 1, $p->string,
				 $current_file,
				 $a->[0],
			);
		}
	    }

	    $stat{total}++;
	    $stat{hit}++ if @match;
	    next if @match == 0 and $opt_check ne 'all';

	    my $hash = $match_list[$index] //= {};
	    my $callback = sub {
		my($ms, $me, $i, $matched) = @_;
		$stat{$i % 2 ? 'ok' : 'ng'}++;
		my $s = $matched =~ s/$ignorechar_re//gr;
		$hash->{$s}++;
		my $format = @opt_format[ $i % @opt_format ];
		sprintf($format,
			($opt_subst && $to ne '' && $s ne $to) ?
			$to : $matched);
	    };
	    my(@ok, @ng);
	    for (@match) {
		my $matched = substr $text, $_->[0], $_->[1] - $_->[0];
		if ($matched =~ s/$ignorechar_re//gr ne $to) {
		    $_->[2] = $index * 2;
		    push @ng, $_;
		} else {
		    $_->[2] = $index * 2 + 1;
		    push @ok, $_;
		}
		$_->[3] = $callback;
	    }
	    $effective[ $index * 2     ] = 1 if $ng || ( @ng && $outstand );
	    $effective[ $index * 2 + 1 ] = 1 if $ok || ( @ng && $outstand );

	    @matched = merge_regions { nojoin => 1 }, @matched, @match;
	}
    }
    ##
    ## --select
    ##
    if (my $select = $opt_subst_select) {
	my $max = sum map { int $_->words } @dicts;
	use Getopt::EX::Numbers;
	my $numbers = Getopt::EX::Numbers->new(min => 1, max => $max);
	my @select;
	for (my @select_index = do {
	    map  { $_ * 2, $_ * 2 + 1 }
	    map  { $_ - 1 }
	    grep { $_ <= $max }
	    map  { $numbers->parse($_)->sequence }
	    split /,/, $select;
	}) {
	    $select[$_] = 1;
	}
	@matched = grep $select[$_->[2]], @matched;
    }
    grep $effective[$_->[2]], @matched;
}

my $divert_buffer;

sub subst_divert {
    my %arg = @_;
    my $filename = delete $arg{&FILELABEL};

    $divert_buffer = '';
    divert_stdout(\$divert_buffer);
}

1;

__DATA__

builtin         dict=s @opt_dictfile
builtin     dictdata=s @opt_dictdata
builtin   stat-style=s $opt_stat_style
builtin    stat-item=s @opt_stat_item
builtin    printdict!  $opt_printdict
builtin     dictname!  $opt_dictname
builtin subst-format=s @opt_format
builtin        subst!  $opt_subst
builtin        check=s $opt_check
builtin       select=s $opt_subst_select
builtin     linefold!  $opt_linefold
builtin     remember!  $remember_data
builtin warn-overlap!  $opt_warn_overlap
builtin warn-include!  $opt_warn_include
builtin ignore-space!  $opt_ignore_space
builtin show-comment!  $opt_show_comment

option default \
	-Mtermcolor::bg(default=100,light=--subst-color-light,dark=--subst-color-dark) \
	--prologue subst_initialize \
	--begin subst_begin \
	--le +&subst_search --no-regioncolor

##
## Now these options are implemented by -Mupdate module
## --diffcmd, -U are built-in options
##
autoload -Mupdate --update::diff --update::create --update::update
option --diff      --subst --update::diff
option --create    --subst --update::create
option --replace   --subst --update::update --with-backup
option --overwrite --subst --update::update

option --divert-stdout --prologue __PACKAGE__::divert_stdout \
		       --epilogue __PACKAGE__::recover_stdout
option --with-stat     --epilogue subst_show_stat
option --stat          --divert-stdout --with-stat

autoload -Msubst::dyncmap --dyncmap

help	--subst-color-light light terminal color
option	--subst-color-light --colormap --dyncmap \
	range=0-2,except=000:111:222,shift=3,even="555D/%s",odd="IU;000/%s"

help	--subst-color-dark dark terminal color
option	--subst-color-dark --colormap --dyncmap \
	range=2-4,except=222:333:444,shift=1,even="D;L01/%s",odd="IU;%s/L01"

##
## Handle included sample dictionaries.
##

option --exdict  --dict $ENV{GREPLE_SUBST_DICT}/$<shift>

option --exdictdir --prologue 'sub{ say "$ENV{GREPLE_SUBST_DICT}"; exit }'

option --jtca-katakana-guide --exdict jtca-katakana-guide-3.dict
option --jtf-style-guide     --exdict jtf-style-guide-3.dict
option --ms-style-guide      --exdict ms-style-guide.dict

option --sccc2     --exdict sccc2.dict
option --jtca      --exdict jtca.dict
option --jtf       --exdict jtf.dict
option --microsoft --exdict ms-amend.dict --exdict ms-style-guide.dict

# deprecated. don't use.
option --ms --microsoft

option --all-sample-dict --jtf --jtca --microsoft

option --all-katakana --exdict all-katakana.dict

option --dumpdict --printdict --prologue 'sub{exit}'

#  LocalWords:  subst Greple greple ng ok outstand linefold dict diff
#  LocalWords:  regex Kazumasa Utashiro
