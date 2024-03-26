=encoding utf8

=head1 NAME

subst - 用于文本搜索和替换的Greple模块

=head1 VERSION

Version 2.33_99

=head1 SYNOPSIS

greple -Msubst --dict I<dictionary> [ 选项 ]。

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

这个B<greple>模块支持基于字典数据的文本文件的检查和替换。

字典文件由B<-dict>选项给出，每一行都包含匹配的模式和预期的字符串对。

    greple -Msubst --dict DICT

如果字典文件包含以下数据。

    colou?r      color
    cent(er|re)  center

上述命令找到第一个与第二个字符串不匹配的模式，即本例中的 "颜色 "和 "中心"。

实际上，空格分隔字符串的最后两个元素分别被视为模式和替换字符串。

字典数据也可以如下写法用 C<//> 分隔：

    colou?r      //  color
    cent(er|re)  //  center

C<//> 前后必须有空格。在这种格式中，其前后的字符串被视为模式和替换字符串，而不是最后两个元素。前导空格和 C<//> 前后的空格将被忽略，但所有其他空白均有效。

你可以通过B<greple>的B<-f>选项使用同一个文件，在这种情况下，C</>后面的字符串作为注释被忽略。

    greple -f DICT ...

选项B<--dictdata>可以用来在命令行中提供字典数据。

    greple --dictdata $'colou?r color\ncent(er|re) center\n'

以尖锐符号（C<#>）开始的字典条目是一个注释，被忽略。

=head2 Overlapped pattern

当匹配的字符串与之前被另一个模式匹配的字符串相同或更短时，它将被简单地忽略（默认为B<--no-warn-include>）。因此，如果你必须声明冲突的模式，请将较长的模式放在前面。

如果匹配的字符串与先前匹配的字符串重叠，则会被警告（默认为B<--warn-overlap>）并被忽略。

=head2 Terminal color

这个版本使用L<Getopt::EX::termcolor>模块。它设置选项B<--light-screen>或B<--dark-screen>，这取决于运行命令的终端，或B<TERM_BGCOLOR>环境变量。

一些终端（例如："Apple_Terminal "或 "iTerm"）会被自动检测，不需要任何操作。否则，根据终端的背景颜色，将B<TERM_BGCOLOR>环境设置为#000000（黑色）至#FFFFFF（白色）的数字。

=head1 OPTIONS

=over 7

=item B<--dict>=I<file>

指定字典文件。

=item B<--dictdata>=I<data>

用文本指定字典数据。

=item B<--check>=C<outstand>|C<ng>|C<ok>|C<any>|C<all>|C<none>

选项B<--检查>的参数来自C<ng>、C<ok>、C<any>、C<outstand>、C<all>和C<none>。

在默认值C<outstand>下，只有在同一文件中发现意外字词时，命令才会显示预期和意外字词的信息。

如果默认值为C<ng>，命令将显示意外字词的信息。当值为C<ok>时，你将得到关于预期词的信息。用值C<any>时都是如此。

值C<all>和C<none>只有在与B<--stat>选项一起使用时才有意义，并显示从未匹配的模式的信息。

=item B<--select>=I<N>

从字典中选择第I<N>个条目。参数由L<Getopt::EX::Numbers>模块解释。范围可以像B<--select>=C<1:3,7:9>那样定义。你可以通过B<--stat>选项获得数字。

=item B<--linefold>

如果目标数据被折叠在文本中间，使用B<--linefold>选项。它可以创建与跨行的字符串相匹配的反义词模式。但是，被替换的文本不包括换行。因为它在一定程度上混淆了regex行为，如果可能的话，请避免使用。

=item B<--stat>

=item B<--with-stat>

打印统计信息。与B<--check>选项一起工作。

选项B<--with-stat>在正常输出后打印统计信息，而B<--stat>只打印统计信息。

=item B<--stat-style>=C<default>|C<dict>

将B<--stat-style=dict>选项与B<--stat>和B<--check=any>一起使用，你可以为你的工作文件获得字典式输出。

=item B<--stat-item> I<item>=[0,1]

指定在统计信息中显示哪个项目。默认值是。

    match=1
    expect=1
    number=1
    ng=1
    ok=1
    dict=0

如果你不需要看到模式字段，就像这样使用。

    --stat-item match=0

可以同时设置多个参数。

    --stat-item match=number=0,ng=1,ok=1

=item B<--subst>

将意外匹配的模式替换为预期的字符串。匹配字符串中的换行符被忽略。没有替换字符串的模式不会被改变。

=item B<--[no-]warn-overlap>

警告重叠的模式。默认打开。

=item B<--[no-]warn-include>

警告包含的模式。默认为关闭。

=back

=head2 FILE UPDATE OPTIONS

=over 7

=item B<--diff>

=item B<--diffcmd>=I<command>

选项B<--diff>产生原始文本和转换后文本的差异输出。

指定B<--diff>选项使用的diff命令名称。默认为 "diff -u"。

=item B<--create>

创建新文件并写入结果。后缀".new "将附加到原始文件名上。

=item B<--replace>

用转换后的结果替换目标文件。原始文件被重命名为后缀为".bak "的备份名。

=item B<--overwrite>

用转换后的结果覆盖目标文件，没有备份。

=back

=head1 DICTIONARY

这个模块包括字典的例子。它们被安装在共享目录中，通过B<--exdict>选项访问。

    greple -Msubst --exdict jtca-katakana-guide-3.dict

=over 7

=item B<--exdict> I<dictionary>

使用分布中的I<dictionary> flie作为字典文件。

=item B<--exdictdir>

显示字典目录。

=item B<--exdict> jtca-katakana-guide-3.dict

=item B<--jtca-katakana-guide>

从以下指导性文件中创建。

    外来語（カタカナ）表記ガイドライン 第3版
    制定：2015年8月
    発行：2015年9月
    一般財団法人テクニカルコミュニケーター協会 
    Japan Technical Communicators Association
    https://www.jtca.org/standardization/katakana_guide_3_20171222.pdf

=item B<--jtca>

定制的B<--jtca-katakana-guide>。原始字典是由已发表的数据自动生成的。本词典是为实际使用而定制的。

=item B<--exdict> jtf-style-guide-3.dict

=item B<--jtf-style-guide>

从以下指导性文件中创建。

    JTF日本語標準スタイルガイド（翻訳用）
    第3.0版
    2019年8月20日
    一般社団法人 日本翻訳連盟（JTF）
    翻訳品質委員会
    https://www.jtf.jp/jp/style_guide/pdf/jtf_style_guide.pdf

=item B<--jtf>

定制的B<--jtf-style-guide>。原始字典是由公布的数据自动生成的。这个字典是为实际使用而定制的。

=item B<--exdict> sccc2.dict

=item B<--sccc2>

词典用于2014年出版的 "C/C++ セキュアコーディング 第2版"。

    https://www.jpcert.or.jp/securecoding_book_2nd.html

=item B<--exdict> ms-style-guide.dict

=item B<--ms-style-guide>

词典根据微软本地化风格指南生成。

    https://www.microsoft.com/ja-jp/language/styleguides

数据从这篇文章中生成。

    https://www.atmarkit.co.jp/news/200807/25/microsoft.html

=item B<--microsoft>

Customized B<--ms-style-guide>。原始词典是由已发表的数据自动生成的。本词典是为实际使用而定制的。

修正后的字典可以找到L<这里|https://github.com/kaz-utashiro/greple-subst/blob/master/share/ms-amend.dict>。如果你有更新的要求，请提出问题或发送pull-request。

=back

=head1 JAPANESE

本模块是为支持日语文本编辑而制作的。

=head2 KATAKANA

日本的KATAKANA词有很多变体来描述同一个词，所以统一很重要，但这是很累人的工作。在下一个例子中。

    イ[エー]ハトー?([ヴブボ]ォ?)  //  イーハトーヴォ

左边的模式匹配了所有下面的词。

    イエハトブ
    イーハトヴ
    イーハトーヴ
    イーハトーヴォ
    イーハトーボ
    イーハトーブ

这个模块有助于检测和纠正它们。

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

L<文化庁 國語施策・日本語教育 國語施策情報 內閣告示・內閣訓令 外來語の表記|https://www.bunka.go.jp/kokugo_nihongo/sisaku/joho/joho/kijun/naikaku/gairai/index.html>

L<https://qiita.com/kaz-utashiro/items/85add653a71a7e01c415>

L<イーハトーブ|https://ja.wikipedia.org/wiki/%E3%82%A4%E3%83%BC%E3%83%8F%E3%83%88%E3%83%BC%E3%83%96>

=head1 AUTHOR

Kazumasa Utashiro

=head1 LICENSE

Copyright 2017-2024 Kazumasa Utashiro.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


use v5.14;
package App::Greple::subst;

our $VERSION = '2.33_99';

use warnings;
use utf8;
use open IO => ':utf8';

use Exporter 'import';
our @EXPORT      = qw(
    &subst_initialize
    &subst_begin
    &subst_diff
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
our $opt_ignore_space = 0;
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
		for my $i (keys @$list) {
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
builtin subst-select=s $opt_subst_select
builtin     linefold!  $opt_linefold
builtin warn-overlap!  $opt_warn_overlap
builtin warn-include!  $opt_warn_include
builtin ignore-space!  $opt_ignore_space
builtin show-comment!  $opt_show_comment

# override greple's original option
option --select --subst-select

option default \
	-Mtermcolor::bg(default=100,light=--subst-color-light,dark=--subst-color-dark) \
	--prologue subst_initialize \
	--begin subst_begin \
	--le +&subst_search --no-regioncolor

##
## Now these options are implemented by -Mupdate module
## --diffcmd, -U are built-in options
##
autoload -Mupdate \
	--update::diff   \
	--update::create \
	--update::update \
	--update::discard

option --diff      --subst --update::diff
option --create    --subst --update::create
option --replace   --subst --update::update --with-backup
option --overwrite --subst --update::update

option --with-stat --epilogue subst_show_stat
option --stat      --update::discard --with-stat

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
