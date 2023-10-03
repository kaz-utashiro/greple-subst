=encoding utf8

=head1 NAME

subst - 텍스트 검색 및 대체를 위한 Greple 모듈

=head1 VERSION

Version 2.33

=head1 SYNOPSIS

greple -Msubst --dict I<사전> [ 옵션 ]을 입력하세요.

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

이 B<greple> 모듈은 사전 데이터를 기반으로 텍스트 파일의 확인 및 치환을 지원합니다.

사전 파일은 B<--dict> 옵션으로 지정되며 각 줄에는 일치하는 패턴과 예상 문자열 쌍이 포함됩니다.

    greple -Msubst --dict DICT

사전 파일에 다음과 같은 데이터가 포함되어 있다면

    colou?r      color
    cent(er|re)  center

위의 명령은 두 번째 문자열과 일치하지 않는 첫 번째 패턴, 즉 이 경우 "색상"과 "가운데"를 찾습니다.

사전 데이터의 필드 C<//>는 무시되므로 이 파일은 다음과 같이 작성할 수 있습니다:

    colou?r      //  color
    cent(er|re)  //  center

B<greple>의 B<-f> 옵션으로 동일한 파일을 사용할 수 있으며, 이 경우 C<//> 뒤의 문자열은 주석으로 무시됩니다.

    greple -f DICT ...

옵션 B<--dictdata>는 명령줄에서 사전 데이터를 제공하는 데 사용할 수 있습니다.

    greple --dictdata $'colou?r color\ncent(er|re) center\n'

날카로운 기호(C<#>)로 시작하는 사전 항목은 주석이며 무시됩니다.

=head2 Overlapped pattern

일치하는 문자열이 다른 패턴으로 이전에 일치한 문자열과 같거나 더 짧으면 무시됩니다(기본적으로 B<--no-warn-include>). 따라서 충돌하는 패턴을 선언해야 하는 경우 더 긴 패턴을 더 앞에 배치하세요.

일치된 문자열이 이전에 일치된 문자열과 겹치면 경고(기본적으로 B<--warn-overlap>)가 표시되고 무시됩니다.

=head2 Terminal color

이 버전은 L<Getopt::EX::termcolor> 모듈을 사용합니다. 이 모듈은 명령이 실행되는 터미널에 따라 옵션 B<--밝은 화면> 또는 B<--어두운 화면> 또는 B<TERM_BGCOLOR> 환경 변수를 설정합니다.

일부 터미널(예: "Apple_Terminal" 또는 "iTerm")은 자동으로 감지되므로 별도의 조치가 필요하지 않습니다. 그렇지 않으면 단말기 배경색에 따라 B<TERM_BGCOLOR> 환경을 #000000(검은색) ~ #FFFFFF(흰색) 숫자로 설정합니다.

=head1 OPTIONS

=over 7

=item B<--dict>=I<file>

사전 파일을 지정합니다.

=item B<--dictdata>=I<data>

사전 데이터를 텍스트로 지정합니다.

=item B<--check>=C<outstand>|C<ng>|C<ok>|C<any>|C<all>|C<none>

옵션 B<--check>는 C<ng>, C<ok>, C<any>, C<outstand>, C<all>, C<none>에서 인수를 받습니다.

기본값 C<outstand>를 사용하면 명령은 동일한 파일에서 예기치 않은 단어가 발견된 경우에만 예상 단어와 예기치 않은 단어에 대한 정보를 모두 표시합니다.

C<ng> 값을 사용하면 명령은 예기치 않은 단어에 대한 정보를 표시합니다. C<ok> 값을 사용하면 예상 단어에 대한 정보를 얻을 수 있습니다. 둘 다 C<any> 값을 사용합니다.

C<모두> 및 C<없음> 값은 B<--stat> 옵션과 함께 사용할 때만 의미가 있으며 일치하지 않는 패턴에 대한 정보를 표시합니다.

=item B<--select>=I<N>

사전에서 I<N>번째 항목을 선택합니다. 인자는 L<Getopt::EX::Numbers> 모듈에 의해 해석됩니다. 범위는 B<--선택>=C<1:3,7:9>처럼 정의할 수 있습니다. B<--stat> 옵션으로 숫자를 가져올 수 있습니다.

=item B<--linefold>

대상 데이터가 텍스트 중간에 접혀있는 경우 B<--linefold> 옵션을 사용합니다. 줄에 걸쳐 펼쳐진 문자열과 일치하는 정규식 패턴을 생성합니다. 하지만 대체된 텍스트에는 개행이 포함되지 않습니다. 정규식 동작에 다소 혼란을 줄 수 있으므로 가급적 사용하지 마세요.

=item B<--stat>

=item B<--with-stat>

통계 정보를 인쇄합니다. B<--체크> 옵션과 함께 작동합니다.

B<--with-stat> 옵션은 일반 출력 후 통계를 인쇄하고, B<--stat>은 통계만 인쇄합니다.

=item B<--stat-style>=C<default>|C<dict>

B<--stat-style=dict> 옵션을 B<--stat> 및 B<--check=any>와 함께 사용하면 작업 문서에 대한 사전 스타일 출력을 얻을 수 있습니다.

=item B<--stat-item> I<item>=[0,1]

통계 정보에 표시할 항목을 지정합니다. 기본값은 다음과 같습니다:

    match=1
    expect=1
    number=1
    ng=1
    ok=1
    dict=0

패턴 필드를 볼 필요가 없는 경우 다음과 같이 사용하세요:

    --stat-item match=0

한 번에 여러 매개변수를 설정할 수 있습니다:

    --stat-item match=number=0,ng=1,ok=1

=item B<--subst>

예상치 못한 일치 패턴을 예상 문자열로 대체합니다. 일치하는 문자열의 개행 문자는 무시됩니다. 대체 문자열이 없는 패턴은 변경되지 않습니다.

=item B<--[no-]warn-overlap>

중복된 패턴 경고. 기본값은 켜짐입니다.

=item B<--[no-]warn-include>

포함된 패턴 경고. 기본값은 꺼짐입니다.

=back

=head2 FILE UPDATE OPTIONS

=over 7

=item B<--diff>

=item B<--diffcmd>=I<command>

옵션 B<--diff>는 원본 텍스트와 변환된 텍스트의 diff 출력을 생성합니다.

B<--diff> 옵션에서 사용할 diff 명령 이름을 지정합니다. 기본값은 "diff -u"입니다.

=item B<--create>

새 파일을 생성하고 결과를 씁니다. 원본 파일 이름에 접미사 ".new"가 추가됩니다.

=item B<--replace>

대상 파일을 변환된 결과로 바꿉니다. 원본 파일에 접미사 ".bak"이 붙은 백업 이름으로 이름이 바뀝니다.

=item B<--overwrite>

백업 없이 변환된 결과로 대상 파일을 덮어씁니다.

=back

=head1 DICTIONARY

이 모듈에는 예제 딕셔너리가 포함되어 있습니다. 예제 사전은 공유 디렉터리에 설치되며 B<--exdict> 옵션으로 액세스합니다.

    greple -Msubst --exdict jtca-katakana-guide-3.dict

=over 7

=item B<--exdict> I<dictionary>

배포에서 I<사전> 플라이를 사전 파일로 사용합니다.

=item B<--exdictdir>

사전 디렉토리를 표시합니다.

=item B<--exdict> jtca-katakana-guide-3.dict

=item B<--jtca-katakana-guide>

다음 가이드라인 문서에서 생성합니다.

    外来語（カタカナ）表記ガイドライン 第3版
    制定：2015年8月
    発行：2015年9月
    一般財団法人テクニカルコミュニケーター協会 
    Japan Technical Communicators Association
    https://www.jtca.org/standardization/katakana_guide_3_20171222.pdf

=item B<--jtca>

사용자 지정 B<--jtca-katakana-guide>. 원본 사전은 게시된 데이터에서 자동으로 생성됩니다. 이 사전은 실제 사용을 위해 사용자 정의됩니다.

=item B<--exdict> jtf-style-guide-3.dict

=item B<--jtf-style-guide>

다음 가이드라인 문서에서 생성합니다.

    JTF日本語標準スタイルガイド（翻訳用）
    第3.0版
    2019年8月20日
    一般社団法人 日本翻訳連盟（JTF）
    翻訳品質委員会
    https://www.jtf.jp/jp/style_guide/pdf/jtf_style_guide.pdf

=item B<--jtf>

사용자 정의 B<--jtf-style-guide>. 게시된 데이터에서 원본 사전이 자동으로 생성됩니다. 이 사전은 실제 사용에 맞게 사용자 정의됩니다.

=item B<--exdict> sccc2.dict

=item B<--sccc2>

2014년에 출간된 "C/C++ セキュアコーディング 第2版"에 사용된 사전입니다.

    https://www.jpcert.or.jp/securecoding_book_2nd.html

=item B<--exdict> ms-style-guide.dict

=item B<--ms-style-guide>

Microsoft 로컬라이제이션 스타일 가이드에서 생성된 사전입니다.

    https://www.microsoft.com/ja-jp/language/styleguides

이 문서에서 데이터를 생성합니다:

    https://www.atmarkit.co.jp/news/200807/25/microsoft.html

=item B<--microsoft>

사용자 지정 B<--ms-style-guide>. 원본 사전은 게시된 데이터에서 자동으로 생성됩니다. 이 사전은 실제 사용을 위해 사용자 지정되었습니다.

수정 사전은 L<여기|https://github.com/kaz-utashiro/greple-subst/blob/master/share/ms-amend.dict>에서 찾을 수 있습니다. 업데이트 요청이 있는 경우 이슈를 제기하거나 풀 리퀘스트를 보내주세요.

=back

=head1 JAPANESE

이 모듈은 원래 일본어 텍스트 편집 지원을 위해 만들어졌습니다.

=head2 KATAKANA

일본어 가타카나 단어는 같은 단어를 설명하는 변형이 많기 때문에 통일이 중요하지만 상당히 번거로운 작업입니다. 다음 예제에서는

    イ[エー]ハトー?([ヴブボ]ォ?)  //  イーハトーヴォ

왼쪽 패턴은 다음의 모든 단어와 일치합니다.

    イエハトブ
    イーハトヴ
    イーハトーヴ
    イーハトーヴォ
    イーハトーボ
    イーハトーブ

이 모듈은 이를 감지하고 수정하는 데 도움이 됩니다.

=head1 INSTALL

=head2 CPANMINUS

    $ cpanm App::Greple::subst

=head1 SEE ALSO

L<https://github.com/kaz-utashiro/greple>

L<https://github.com/kaz-utashiro/greple-subst>

L<https://github.com/kaz-utashiro/greple-update>

L<https://www.jtca.org/standardization/katakana_guide_3_20171222.pdf>

L<https://www.jtf.jp/jp/style_guide/styleguide_top.html>, L<https://www.jtf.jp/jp/style_guide/pdf/jtf_style_guide.pdf>

L<https://www.microsoft.com/ja-jp/language/styleguides>, L<https://www.atmarkit.co.jp/news/200807/25/microsoft.html>

L<文化庁 国語施策・日本語教育 国語施策情報 内閣告示・内閣訓令 外来語の表記|https://www.bunka.go.jp/kokugo_nihongo/sisaku/joho/joho/kijun/naikaku/gairai/index.html>

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

our $VERSION = '2.33';

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
